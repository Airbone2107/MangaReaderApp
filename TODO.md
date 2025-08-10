Các thay đổi chính bao gồm:
1.  **Backend:**
    *   Cập nhật `User Model` để lưu trữ thông tin chi tiết của chapter đã đọc gần nhất (ID, tên, số chương, ngôn ngữ).
    *   Điều chỉnh API endpoint `reading-progress` để xử lý dữ liệu chapter mới và giới hạn lịch sử chỉ lưu 10 truyện gần nhất.
2.  **Frontend:**
    *   Tạo một model mới `ChapterInfo` để lưu trữ thông tin chapter trong lịch sử.
    *   Cập nhật `User Model` để sử dụng model mới này.
    *   Cập nhật `UserApiService` và `ChapterReaderLogic` để gửi thông tin chapter đầy đủ lên backend.
    *   Thay đổi `AccountScreenLogic` để hiển thị lịch sử đọc ngay lập tức mà không cần gọi API bổ sung.

### Bước 1: Cập nhật Backend

Chúng ta sẽ bắt đầu bằng việc điều chỉnh cấu trúc dữ liệu và logic ở phía backend.

#### 1.1. Cập nhật User Model

Mở file `MangaReaderBackend\models\User.js` và thay đổi cấu trúc của `readingManga` để lưu trữ một object thay vì chỉ một `String` cho `lastChapter`.

```javascript
// MangaReaderBackend/models/User.js
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const crypto = require('crypto');

const chapterInfoSchema = new mongoose.Schema({
  id: { type: String, required: true },
  chapter: { type: String, default: null },
  title: { type: String, default: null },
  translatedLanguage: { type: String, required: true },
}, { _id: false });

const userSchema = new mongoose.Schema({
  authProvider: {
    type: String,
    required: [true, 'Auth provider is required.'],
    enum: ['google', 'email'],
    default: 'email'
  },
  googleId: {
    type: String,
    unique: true,
    sparse: true
  },
  email: {
    type: String,
    required: [true, 'Vui lòng cung cấp email của bạn'],
    unique: true,
    lowercase: true,
  },
  password: {
    type: String,
    select: false
  },
  displayName: {
    type: String,
    required: [true, 'Vui lòng cung cấp tên hiển thị']
  },
  photoURL: {
    type: String
  },
  isVerified: {
    type: Boolean,
    default: false,
  },
  verificationToken: String,
  verificationTokenExpires: Date,
  passwordResetToken: String,
  passwordResetTokenExpires: Date,
  followingManga: [{
    type: String
  }],
  readingManga: [{
    mangaId: {
      type: String,
      required: true
    },
    lastReadChapter: {
      type: chapterInfoSchema,
      required: true
    },
    lastReadAt: {
      type: Date,
      default: Date.now
    }
  }],
  tokens: [{
    token: {
      type: String,
      required: true
    },
    createdAt: {
      type: Date,
      default: Date.now,
      expires: '30d'
    }
  }],
  createdAt: {
    type: Date,
    default: Date.now
  }
});

// Đảm bảo index unique cho googleId chỉ áp dụng khi field tồn tại và là string
userSchema.index(
  { googleId: 1 },
  {
    unique: true,
    sparse: true,
    partialFilterExpression: { googleId: { $exists: true, $type: 'string' } },
  }
);

userSchema.pre('save', async function(next) {
  if (!this.isModified('password')) return next();
  this.password = await bcrypt.hash(this.password, 12);
  next();
});

userSchema.methods.comparePassword = async function(candidatePassword) {
  if (!this.password) return false;
  return await bcrypt.compare(candidatePassword, this.password);
};

userSchema.methods.generateVerificationToken = function() {
  const token = crypto.randomBytes(32).toString('hex');
  this.verificationToken = crypto
    .createHash('sha256')
    .update(token)
    .digest('hex');
  this.verificationTokenExpires = Date.now() + 24 * 60 * 60 * 1000;
  return token;
};

userSchema.methods.generatePasswordResetToken = function() {
  const resetToken = Math.floor(100000 + Math.random() * 900000).toString();
  this.passwordResetToken = crypto
    .createHash('sha256')
    .update(resetToken)
    .digest('hex');
  this.passwordResetTokenExpires = Date.now() + 60 * 60 * 1000;
  return resetToken;
};

userSchema.methods.addToken = async function(token) {
  this.tokens = this.tokens || [];
  this.tokens.push({ token });
  await this.save({ validateBeforeSave: false });
  return token;
};

userSchema.methods.removeToken = async function(token) {
  this.tokens = this.tokens.filter(t => t.token !== token);
  await this.save({ validateBeforeSave: false });
};

module.exports = mongoose.model('User', userSchema);
```

#### 1.2. Cập nhật Route xử lý tiến độ đọc

Mở file `MangaReaderBackend\routes\userRoutes.js` và cập nhật logic của route `/reading-progress` để xử lý object `lastChapter` mới và giới hạn lịch sử còn 10 truyện.

```javascript
// MangaReaderBackend/routes/userRoutes.js
const express = require('express');
const router = express.Router();
const User = require('../models/User');
const jwt = require('jsonwebtoken');
const { OAuth2Client } = require('google-auth-library');
const crypto = require('crypto');
const sendEmail = require('../utils/emailService');
const { JWT_SECRET, GOOGLE_CLIENT_ID } = process.env;

const client = new OAuth2Client(GOOGLE_CLIENT_ID);
const BASE_URL = process.env.PUBLIC_BASE_URL || 'https://manga-reader-app-backend.onrender.com';

// --- NEW: Email + Password Authentication ---

router.post('/register', async (req, res) => {
  try {
    const { displayName, email, password } = req.body;

    if (!displayName || !email || !password) {
      return res.status(400).json({ message: 'Vui lòng cung cấp tên hiển thị, email và mật khẩu.' });
    }

    const existingUser = await User.findOne({ email: email.toLowerCase(), authProvider: 'email' });
    if (existingUser) {
      return res.status(409).json({ message: 'Một tài khoản với email này đã tồn tại.' });
    }

    const newUser = new User({
      displayName,
      email: email.toLowerCase(),
      password,
      authProvider: 'email',
    });

    const verificationToken = newUser.generateVerificationToken();
    await newUser.save();

    const verificationURL = `${BASE_URL}/api/users/verify/${verificationToken}`;
    const message = `Chào mừng bạn đến với Manga Reader! Để hoàn tất đăng ký, vui lòng sử dụng liên kết sau để xác minh địa chỉ email của bạn. Liên kết này có hiệu lực trong 24 giờ.\n\n${verificationURL}\n\nNếu bạn không tạo tài khoản, vui lòng bỏ qua email này.`;

    try {
      await sendEmail({
        email: newUser.email,
        subject: 'Xác thực Email - Manga Reader',
        message,
      });
      res.status(201).json({ message: 'Đăng ký thành công! Vui lòng kiểm tra email để xác minh tài khoản của bạn.' });
    } catch (emailError) {
      console.error('Lỗi gửi email:', emailError);
      await User.findByIdAndDelete(newUser._id);
      return res.status(500).json({ message: 'Không thể gửi email xác thực. Vui lòng thử lại sau.' });
    }
  } catch (error) {
    console.error('Lỗi đăng ký:', error);
    res.status(500).json({ message: `Đã xảy ra lỗi trong quá trình đăng ký: ${error.message}` });
  }
});

router.get('/verify/:token', async (req, res) => {
  try {
    const hashedToken = crypto.createHash('sha256').update(req.params.token).digest('hex');

    const user = await User.findOne({
      verificationToken: hashedToken,
      verificationTokenExpires: { $gt: Date.now() },
    });

    if (!user) {
      return res.status(400).send('<h1>Token không hợp lệ hoặc đã hết hạn.</h1><p>Vui lòng thử đăng ký lại.</p>');
    }

    user.isVerified = true;
    user.verificationToken = undefined;
    user.verificationTokenExpires = undefined;
    await user.save();

    res.status(200).send('<h1>Email đã được xác thực thành công!</h1><p>Bây giờ bạn có thể đóng cửa sổ này và đăng nhập vào ứng dụng.</p>');
  } catch (error) {
    console.error('Lỗi xác thực:', error);
    res.status(500).send('<h1>Đã xảy ra lỗi trong quá trình xác thực.</h1>');
  }
});

router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ message: 'Vui lòng cung cấp email và mật khẩu.' });
    }

    const user = await User.findOne({ email, authProvider: 'email' }).select('+password');

    if (!user || !(await user.comparePassword(password))) {
      return res.status(401).json({ message: 'Email hoặc mật khẩu không chính xác.' });
    }

    if (!user.isVerified) {
      return res.status(403).json({ message: 'Tài khoản chưa được xác thực. Vui lòng kiểm tra email của bạn.' });
    }

    const token = jwt.sign(
      { userId: user._id },
      JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN || '30d' }
    );

    await user.addToken(token);

    res.json({ token });
  } catch (error) {
    console.error('Lỗi đăng nhập:', error);
    res.status(500).json({ message: 'Đã xảy ra lỗi trong quá trình đăng nhập.', error: error.message });
  }
});

router.post('/forgot-password', async (req, res) => {
  try {
    const { email } = req.body;
    const user = await User.findOne({ email, authProvider: 'email' });

    if (!user) {
      return res.status(200).json({ message: 'Nếu có người dùng với email đó, một mã đặt lại mật khẩu đã được gửi.' });
    }

    const resetCode = user.generatePasswordResetToken();
    await user.save({ validateBeforeSave: false });

    const message = `Bạn đã yêu cầu đặt lại mật khẩu. Vui lòng sử dụng mã 6 chữ số sau để đặt lại mật khẩu của bạn. Mã có hiệu lực trong 1 giờ.\n\nMã của bạn: ${resetCode}\n\nNếu bạn không yêu cầu điều này, vui lòng bỏ qua email.`;

    try {
      await sendEmail({
        email: user.email,
        subject: 'Mã Đặt Lại Mật Khẩu Của Bạn - Manga Reader',
        message,
      });
      res.status(200).json({ message: 'Nếu có người dùng với email đó, một mã đặt lại mật khẩu đã được gửi.' });
    } catch (emailError) {
      console.error('Lỗi email quên mật khẩu:', emailError);
      user.passwordResetToken = undefined;
      user.passwordResetTokenExpires = undefined;
      await user.save({ validateBeforeSave: false });
      res.status(500).json({ message: 'Không thể gửi email đặt lại mật khẩu. Vui lòng thử lại sau.' });
    }
  } catch (error) {
    console.error('Lỗi quên mật khẩu:', error);
    res.status(500).json({ message: 'Đã có lỗi xảy ra.' });
  }
});

router.post('/reset-password', async (req, res) => {
  try {
    const { token, newPassword } = req.body;

    if (!token || !newPassword) {
      return res.status(400).json({ message: 'Vui lòng cung cấp mã đặt lại và mật khẩu mới.' });
    }

    const hashedToken = crypto.createHash('sha256').update(token).digest('hex');

    const user = await User.findOne({
      passwordResetToken: hashedToken,
      passwordResetTokenExpires: { $gt: Date.now() },
    });

    if (!user) {
      return res.status(400).json({ message: 'Mã không hợp lệ hoặc đã hết hạn.' });
    }

    user.password = newPassword;
    user.passwordResetToken = undefined;
    user.passwordResetTokenExpires = undefined;
    await user.save();

    user.tokens = [];
    await user.save({ validateBeforeSave: false });

    res.status(200).json({ message: 'Mật khẩu đã được đặt lại thành công. Vui lòng đăng nhập bằng mật khẩu mới của bạn.' });
  } catch (error) {
    console.error('Lỗi đặt lại mật khẩu:', error);
    res.status(500).json({ message: 'Đã có lỗi xảy ra.' });
  }
});

// --- Google Authentication ---
router.post('/auth/google', async (req, res) => {
  const { idToken } = req.body;

  if (!idToken) {
    return res.status(400).json({ message: 'Không có idToken được cung cấp' });
  }

  try {
    const ticket = await client.verifyIdToken({
      idToken: idToken,
      audience: GOOGLE_CLIENT_ID,
    });

    const payload = ticket.getPayload();
    if (!payload) {
      throw new Error('Invalid ID token');
    }

    const { email, sub: googleId, name, picture } = payload;

    let user = await User.findOne({ googleId });
    if (!user) {
      user = new User({
        googleId,
        email: (email || '').toLowerCase(),
        displayName: name,
        photoURL: picture,
        authProvider: 'google',
        isVerified: true,
      });
      await user.save();
    } else {
      user.displayName = name;
      user.photoURL = picture;
      await user.save();
    }

    const token = jwt.sign(
      { userId: user._id },
      JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN || '30d' }
    );

    await user.addToken(token);

    res.json({ token });
  } catch (error) {
    console.error('Lỗi xác thực Google với idToken:', error);
    res.status(401).json({ message: 'Token không hợp lệ hoặc đã hết hạn' });
  }
});

// --- Shared Routes ---

const authenticateToken = async (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ message: 'Token không tìm thấy' });
  }

  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    const user = await User.findOne({ _id: decoded.userId, 'tokens.token': token });

    if (!user) {
      throw new Error('User not found or token is invalid');
    }

    req.user = user;
    req.token = token;
    next();
  } catch (err) {
    console.error('[AuthMiddleware] JWT Verification Error:', err.name, err.message);
    if (err.name === 'TokenExpiredError') {
      return res.status(401).json({ message: 'Token đã hết hạn' });
    }
    return res.status(403).json({ message: 'Token không hợp lệ' });
  }
};

router.get('/', authenticateToken, async (req, res) => {
  try {
    const userResponse = req.user.toObject();
    delete userResponse.tokens;
    delete userResponse.password;
    delete userResponse.verificationToken;
    delete userResponse.verificationTokenExpires;
    delete userResponse.passwordResetToken;
    delete userResponse.passwordResetTokenExpires;
    res.json(userResponse);
  } catch (error) {
    console.error('Lỗi lấy thông tin người dùng:', error);
    res.status(500).json({ message: error.message });
  }
});

router.post('/follow', authenticateToken, async (req, res) => {
  try {
    const { mangaId } = req.body;
    const user = req.user;

    if (!mangaId) {
      return res.status(400).json({ message: 'Thiếu mangaId' });
    }

    if (!user.followingManga.includes(mangaId)) {
      user.followingManga.push(mangaId);
      await user.save();
    }

    res.json(user);
  } catch (error) {
    console.error('Follow error:', error);
    res.status(500).json({ message: error.message });
  }
});

router.post('/unfollow', authenticateToken, async (req, res) => {
  try {
    const { mangaId } = req.body;
    const user = req.user;

    if (!mangaId) {
      return res.status(400).json({ message: 'Thiếu mangaId' });
    }

    user.followingManga = user.followingManga.filter(id => id !== mangaId);
    await user.save();

    res.json(user);
  } catch (error) {
    console.error('Unfollow error:', error);
    res.status(500).json({ message: error.message });
  }
});

router.post('/reading-progress', authenticateToken, async (req, res) => {
  try {
    const { mangaId, lastReadChapter } = req.body;
    const user = req.user;

    if (!mangaId || !lastReadChapter || !lastReadChapter.id || !lastReadChapter.translatedLanguage) {
      return res.status(400).json({ message: 'Thiếu thông tin cần thiết: mangaId và lastReadChapter (với id và translatedLanguage) là bắt buộc.' });
    }

    // Xóa mục cũ nếu có
    const updatedHistory = user.readingManga.filter(m => m.mangaId !== mangaId);

    // Thêm mục mới vào đầu danh sách
    updatedHistory.unshift({
      mangaId,
      lastReadChapter: {
        id: lastReadChapter.id,
        chapter: lastReadChapter.chapter,
        title: lastReadChapter.title,
        translatedLanguage: lastReadChapter.translatedLanguage,
      },
      lastReadAt: new Date()
    });

    // Giới hạn lịch sử chỉ 10 truyện gần nhất
    user.readingManga = updatedHistory.slice(0, 10);

    await user.save();
    res.json({ readingManga: user.readingManga });
  } catch (error) {
    console.error('Update reading progress error:', error);
    res.status(500).json({ message: error.message });
  }
});

router.post('/logout', authenticateToken, async (req, res) => {
  try {
    await req.user.removeToken(req.token);
    res.json({ message: 'Đăng xuất thành công' });
  } catch (error) {
    console.error('Logout error:', error);
    res.status(500).json({ message: 'Lỗi khi đăng xuất' });
  }
});

router.get('/user/following/:mangaId', authenticateToken, async (req, res) => {
  const { mangaId } = req.params;
  const user = req.user;
  
  try {
    const isFollowing = user.followingManga.includes(mangaId);
    res.json({ isFollowing });
  } catch (error) {
    console.error('Error checking following status:', error);
    res.status(500).json({ message: error.message });
  }
});

router.get('/reading-history', authenticateToken, async (req, res) => {
  try {
    const user = req.user;
    
    // Lịch sử đã được sắp xếp khi lưu, chỉ cần trả về
    res.json(user.readingManga);
  } catch (error) {
    console.error('Lỗi lấy lịch sử đọc:', error);
    res.status(500).json({ message: 'Lỗi máy chủ khi lấy lịch sử đọc' });
  }
});

module.exports = router;
```

### Bước 2: Cập nhật Frontend

Bây giờ chúng ta sẽ cập nhật ứng dụng Flutter để gửi và nhận cấu trúc dữ liệu mới.

#### 2.1. Cập nhật User Model

Mở file `MangaReaderFrontend\lib\data\models\user_model.dart` và thay thế toàn bộ nội dung của nó. Chúng ta sẽ định nghĩa một lớp `ChapterInfo` mới để lưu trữ chi tiết chapter và cập nhật `ReadingProgress`.

```dart
// MangaReaderFrontend/lib/data/models/user_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Mô hình dữ liệu người dùng.
@freezed
abstract class User with _$User {
  const factory User({
    @JsonKey(name: '_id') required String id,
    String? googleId,
    required String email,
    required String displayName,
    String? photoURL,
    required String authProvider,
    required bool isVerified,
    @JsonKey(name: 'followingManga') required List<String> following,
    @JsonKey(name: 'readingManga')
    required List<ReadingProgress> readingProgress,
    required DateTime createdAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

/// Tiến độ đọc của người dùng đối với một manga.
@freezed
abstract class ReadingProgress with _$ReadingProgress {
  const factory ReadingProgress({
    required String mangaId,
    required ChapterInfo lastReadChapter,
    required DateTime lastReadAt,
    @JsonKey(name: '_id') String? id,
  }) = _ReadingProgress;

  factory ReadingProgress.fromJson(Map<String, dynamic> json) =>
      _$ReadingProgressFromJson(json);
}

/// Thông tin chi tiết của một chapter được lưu trong lịch sử.
@freezed
abstract class ChapterInfo with _$ChapterInfo {
  const factory ChapterInfo({
    required String id,
    String? chapter,
    String? title,
    required String translatedLanguage,
  }) = _ChapterInfo;

  factory ChapterInfo.fromJson(Map<String, dynamic> json) =>
      _$ChapterInfoFromJson(json);
}
```

#### 2.2. Chạy Build Runner để tạo code

Sau khi thay đổi model, bạn **phải** chạy lệnh sau trong terminal tại thư mục gốc của dự án Flutter (`MangaReaderFrontend`) để cập nhật các file `.g.dart` và `.freezed.dart`:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 2.3. Cập nhật User API Service

Mở file `MangaReaderFrontend\lib\data\services\user_api_service.dart` và cập nhật phương thức `updateReadingProgress` để gửi đi object `ChapterInfo`.

```dart
// MangaReaderFrontend/lib/data/services/user_api_service.dart
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import '../../config/app_config.dart';
import '../../utils/logger.dart';
import '../models/user_model.dart';
import '../storage/secure_storage_service.dart';

/// Service tương tác với backend cho các nghiệp vụ người dùng.
///
/// - Đăng nhập Google và lưu token
/// - Đăng xuất
/// - Lấy thông tin người dùng
/// - Theo dõi/Bỏ theo dõi manga
/// - Kiểm tra trạng thái theo dõi
/// - Cập nhật tiến độ đọc
class UserApiService {
  final String baseUrl;
  final http.Client client;

  /// Khởi tạo với `AppConfig.baseUrl` làm mặc định nếu không chỉ định `baseUrl`.
  UserApiService({this.baseUrl = AppConfig.baseUrl, http.Client? client})
    : client = client ?? http.Client();

  // --- NEW: Email/Password Methods ---

  /// Đăng ký tài khoản mới bằng email.
  Future<String> register(String displayName, String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/api/users/register'),
      headers: _buildHeaders(null),
      body: jsonEncode({
        'displayName': displayName,
        'email': email,
        'password': password,
      }),
    );

    final dynamic body = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body['message'] as String;
    } else {
      throw HttpException((body['message'] as String?) ?? 'Đăng ký thất bại');
    }
  }

  /// Đăng nhập bằng email và mật khẩu.
  Future<void> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/api/users/login'),
      headers: _buildHeaders(null),
      body: jsonEncode({'email': email, 'password': password}),
    );

    final dynamic body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final String backendToken = body['token'] as String;
      await SecureStorageService.saveToken(backendToken);
      logger.i('Đăng nhập bằng email thành công.');
    } else {
      throw HttpException((body['message'] as String?) ?? 'Đăng nhập thất bại');
    }
  }

  /// Gửi yêu cầu quên mật khẩu.
  Future<String> forgotPassword(String email) async {
    final response = await client.post(
      Uri.parse('$baseUrl/api/users/forgot-password'),
      headers: _buildHeaders(null),
      body: jsonEncode({'email': email}),
    );
    
    final dynamic body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return body['message'] as String;
    } else {
      throw HttpException((body['message'] as String?) ?? 'Yêu cầu quên mật khẩu thất bại');
    }
  }

  /// Đặt lại mật khẩu bằng mã và mật khẩu mới.
  Future<String> resetPassword(String token, String newPassword) async {
    final response = await client.post(
      Uri.parse('$baseUrl/api/users/reset-password'),
      headers: _buildHeaders(null),
      body: jsonEncode({'token': token, 'newPassword': newPassword}),
    );

    final dynamic body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return body['message'] as String;
    } else {
      throw HttpException((body['message'] as String?) ?? 'Đặt lại mật khẩu thất bại');
    }
  }

  // --- Existing Methods ---

  /// Đăng nhập bằng Google và lưu token backend vào Secure Storage.
  Future<void> signInWithGoogle(GoogleSignInAccount googleUser) async {
    try {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      logger.d('Authenticating with Google...');

      final String? idToken = googleAuth.idToken;
      if (idToken == null) {
        throw Exception('Không lấy được idToken từ Google');
      }

      logger.d('idToken available, sending to backend...');

      final http.Response response = await client.post(
        Uri.parse('$baseUrl/api/users/auth/google'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{'idToken': idToken}),
      );

      logger.d('Response status: ${response.statusCode}');
      logger.t('Response body: ${response.body}'); // Use trace for full body

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(response.body) as Map<String, dynamic>;
        final String backendToken = data['token'] as String;
        await SecureStorageService.saveToken(backendToken);
        logger.i('Đăng nhập thành công. Token từ backend đã được lưu.');
      } else {
        // Ném ra HttpException để test case có thể bắt đúng loại lỗi
        throw HttpException(
          'Đăng nhập thất bại: ${response.statusCode} - ${response.body}',
        );
      }
    } on HttpException {
      // Bắt lại HttpException để không bị bao bọc bởi Exception chung chung
      rethrow;
    } catch (e, s) {
      logger.e('Lỗi trong signInWithGoogle', error: e, stackTrace: s);
      // Ném ra Exception chung cho các lỗi khác
      throw Exception('Lỗi đăng nhập: $e');
    }
  }

  /// Đăng xuất và xóa token lưu trữ khi thành công.
  Future<void> logout() async {
    try {
      final String? token = await SecureStorageService.getToken();
      if (token == null) {
        await SecureStorageService.clearAll();
        return;
      }

      final http.Response response = await client.post(
        Uri.parse('$baseUrl/api/users/logout'),
        headers: _buildHeaders(token),
      );

      await SecureStorageService.clearAll();
      if (response.statusCode == 200) {
        logger.i('Đăng xuất thành công.');
      } else {
        logger.w('Đăng xuất thất bại trên server, nhưng đã xoá token ở client.');
      }
    } catch (e, s) {
      logger.e('Lỗi khi đăng xuất, vẫn xoá token ở client', error: e, stackTrace: s);
      await SecureStorageService.clearAll();
      if (e is HttpException) {
        rethrow;
      }
      throw Exception('Lỗi khi đăng xuất: $e');
    }
  }

  /// Lấy thông tin người dùng hiện tại (yêu cầu token hợp lệ).
  Future<User> getUserData() async {
    final String token = await _getTokenOrThrow();
    logger.d('getUserData đang xử lý...');

    final http.Response response = await client.get(
      Uri.parse('$baseUrl/api/users'),
      headers: _buildHeaders(token),
    );

    if (response.statusCode == 200) {
      logger.i('Lấy dữ liệu người dùng thành công.');
      final Map<String, dynamic> userData =
          jsonDecode(response.body) as Map<String, dynamic>;
      return User.fromJson(userData);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      logger.w(
        'Lỗi ${response.statusCode} - Forbidden/Unauthorized. Token có thể đã hết hạn hoặc không hợp lệ.',
      );
      throw HttpException('${response.statusCode}');
    } else {
      logger.e(
        'Không thể lấy thông tin user. Mã lỗi: ${response.statusCode}',
        error: response.body,
      );
      throw HttpException(
        'Không thể lấy thông tin user. Mã lỗi: ${response.statusCode}',
      );
    }
  }

  /// Thêm một manga vào danh sách theo dõi.
  Future<void> addToFollowing(String mangaId) async {
    final String token = await _getTokenOrThrow();
    try {
      final http.Response response = await client.post(
        Uri.parse('$baseUrl/api/users/follow'),
        headers: _buildHeaders(token),
        body: jsonEncode(<String, String>{'mangaId': mangaId}),
      );
      if (response.statusCode != 200) {
        final Map<String, dynamic> error =
            jsonDecode(response.body) as Map<String, dynamic>;
        logger.w('Không thể thêm vào danh sách theo dõi', error: error);
        throw HttpException(
          (error['message'] as String?) ??
              'Không thể thêm vào danh sách theo dõi',
        );
      }
      logger.i('Đã thêm manga $mangaId vào danh sách theo dõi.');
    } catch (e, s) {
      logger.e('Lỗi trong addToFollowing', error: e, stackTrace: s);
      if (e is HttpException) {
        rethrow;
      }
      throw Exception('Lỗi khi thêm manga: $e');
    }
  }

  /// Bỏ theo dõi một manga khỏi danh sách theo dõi.
  Future<void> removeFromFollowing(String mangaId) async {
    final String token = await _getTokenOrThrow();
    try {
      final http.Response response = await client.post(
        Uri.parse('$baseUrl/api/users/unfollow'),
        headers: _buildHeaders(token),
        body: jsonEncode(<String, String>{'mangaId': mangaId}),
      );
      if (response.statusCode != 200) {
        final Map<String, dynamic> error =
            jsonDecode(response.body) as Map<String, dynamic>;
        logger.w('Không thể bỏ theo dõi truyện', error: error);
        throw HttpException(
          (error['message'] as String?) ?? 'Không thể bỏ theo dõi truyện',
        );
      }
      logger.i('Đã bỏ theo dõi manga $mangaId.');
    } catch (e, s) {
      logger.e('Lỗi trong removeFromFollowing', error: e, stackTrace: s);
      if (e is HttpException) {
        rethrow;
      }
      throw Exception('Lỗi khi bỏ theo dõi: $e');
    }
  }

  /// Kiểm tra xem người dùng có đang theo dõi `mangaId` hay không.
  Future<bool> checkIfUserIsFollowing(String mangaId) async {
    try {
      final String? token = await SecureStorageService.getToken();
      if (token == null) {
        return false;
      }
      final http.Response response = await client.get(
        Uri.parse('$baseUrl/api/users/user/following/$mangaId'),
        headers: _buildHeaders(token),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> body =
            jsonDecode(response.body) as Map<String, dynamic>;
        return body['isFollowing'] as bool? ?? false;
      } else {
        logger.w(
          'Lỗi khi kiểm tra theo dõi',
          error: 'Status: ${response.statusCode}, Body: ${response.body}',
        );
        return false;
      }
    } catch (e, s) {
      logger.e(
        'Lỗi nghiêm trọng khi kiểm tra trạng thái theo dõi',
        error: e,
        stackTrace: s,
      );
      return false; // Trả về false nếu có lỗi để tránh crash app
    }
  }

  /// Cập nhật tiến độ đọc cho `mangaId` với thông tin chi tiết của chapter.
  Future<void> updateReadingProgress(String mangaId, ChapterInfo lastReadChapter) async {
    final String token = await _getTokenOrThrow();
    try {
      final http.Response response = await client.post(
        Uri.parse('$baseUrl/api/users/reading-progress'),
        headers: _buildHeaders(token),
        body: jsonEncode({
          'mangaId': mangaId,
          'lastReadChapter': lastReadChapter.toJson(),
        }),
      );
      if (response.statusCode != 200) {
        final Map<String, dynamic> error =
            jsonDecode(response.body) as Map<String, dynamic>;
        logger.w('Không thể cập nhật tiến độ đọc', error: error);
        throw HttpException(
          (error['message'] as String?) ?? 'Không thể cập nhật tiến độ đọc',
        );
      }
      logger.i(
        'Đã cập nhật tiến độ đọc cho manga $mangaId, chapter ${lastReadChapter.id}',
      );
    } catch (e, s) {
      logger.e('Lỗi trong updateReadingProgress', error: e, stackTrace: s);
      if (e is HttpException) {
        rethrow;
      }
      throw Exception('Lỗi khi cập nhật tiến độ: $e');
    }
  }

  /// Xây dựng header kèm Bearer token cho các request yêu cầu xác thực.
  Map<String, String> _buildHeaders(String? token) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// Lấy token hoặc ném lỗi nếu không tồn tại trong Secure Storage.
  Future<String> _getTokenOrThrow() async {
    final String? token = await SecureStorageService.getToken();
    if (token == null) {
      logger.w('Không tìm thấy token. Yêu cầu đăng nhập.');
      throw const HttpException('Không tìm thấy token');
    }
    return token;
  }

  /// Đóng `http.Client` để giải phóng tài nguyên.
  void dispose() {
    client.close();
  }
}
```

#### 2.4. Cập nhật Chapter Reader Logic

Mở file `MangaReaderFrontend\lib\features\chapter_reader\logic\chapter_reader_logic.dart` và thay đổi `updateProgress` để gửi đi object `ChapterInfo`.

```dart
// MangaReaderFrontend/lib/features/chapter_reader/logic/chapter_reader_logic.dart
import 'package:flutter/material.dart';
import '../../../data/models/chapter_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/mangadex_api_service.dart';
import '../../../data/services/user_api_service.dart';
import '../../../data/storage/secure_storage_service.dart';
import '../../../utils/logger.dart';
import '../view/chapter_reader_screen.dart';

/// Nghiệp vụ cho màn hình đọc chapter.
///
/// Xử lý ẩn/hiện thanh điều hướng khi cuộn, điều hướng giữa các chapter,
/// theo dõi trạng thái theo dõi và cập nhật tiến độ đọc.
class ChapterReaderLogic {
  final Function(VoidCallback) setState;
  final UserApiService userService;
  final ScrollController scrollController;
  final MangaDexApiService mangaDexService = MangaDexApiService();

  bool areBarsVisible = true;
  double lastOffset = 0.0;
  double scrollThreshold = 50.0;

  ChapterReaderLogic({
    required this.setState,
    required this.userService,
    required this.scrollController,
  }) {
    scrollController.addListener(_onScroll);
  }

  /// Lắng nghe sự kiện cuộn để quyết định ẩn/hiện thanh điều hướng.
  void _onScroll() {
    final double currentOffset = scrollController.offset;
    final double delta = currentOffset - lastOffset;

    if (delta.abs() > scrollThreshold) {
      if (delta > 0 && areBarsVisible) {
        setState(() => areBarsVisible = false);
      } else if (delta < 0 && !areBarsVisible) {
        setState(() => areBarsVisible = true);
      }
      lastOffset = currentOffset;
    }
  }

  /// Vị trí index của chapter hiện tại trong `chapter.chapterList`.
  int getCurrentIndex(Chapter chapter) {
    return chapter.chapterList.indexWhere(
      (dynamic ch) => ch['id'] == chapter.chapterId,
    );
  }

  /// Lấy thông tin chi tiết của một chapter từ danh sách chapter.
  Map<String, dynamic> getChapterData(Chapter chapter, String chapterId) {
    return chapter.chapterList.firstWhere(
      (ch) => ch['id'] == chapterId,
      orElse: () => <String, dynamic>{},
    );
  }

  /// Tạo tên hiển thị cho chapter dựa trên số và tiêu đề.
  String getChapterDisplayName(Map<String, dynamic> chapterData) {
    if (chapterData.isEmpty || chapterData['attributes'] == null) {
      return 'Chapter không xác định';
    }
    final attributes = chapterData['attributes'] as Map<String, dynamic>;
    final String chapterNumber = attributes['chapter'] as String? ?? 'N/A';
    final String chapterTitle = attributes['title'] as String? ?? '';
    return chapterTitle.isEmpty || chapterTitle == chapterNumber
        ? 'Chương $chapterNumber'
        : 'Chương $chapterNumber: $chapterTitle';
  }

  /// Tải danh sách URL trang ảnh của chapter.
  Future<List<String>> fetchChapterPages(String chapterId) {
    return mangaDexService.fetchChapterPages(chapterId);
  }

  /// Điều hướng tới chapter kế tiếp (nếu có).
  void goToNextChapter(
    BuildContext context,
    Chapter chapter,
    int currentIndex,
  ) {
    if (currentIndex > 0) {
      final dynamic nextChapterData = chapter.chapterList[currentIndex - 1];
      _navigateToChapter(
        context,
        chapter,
        nextChapterData as Map<String, dynamic>,
      );
    }
  }

  /// Điều hướng tới chapter trước đó (nếu có).
  void goToPreviousChapter(
    BuildContext context,
    Chapter chapter,
    int currentIndex,
  ) {
    if (currentIndex < chapter.chapterList.length - 1) {
      final dynamic prevChapterData = chapter.chapterList[currentIndex + 1];
      _navigateToChapter(
        context,
        chapter,
        prevChapterData as Map<String, dynamic>,
      );
    }
  }

  /// Thay thế màn hình hiện tại bằng chapter mới.
  void _navigateToChapter(
    BuildContext context,
    Chapter currentChapter,
    Map<String, dynamic> newChapterData,
  ) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ChapterReaderScreen(
          chapter: Chapter(
            mangaId: currentChapter.mangaId,
            chapterId: newChapterData['id'] as String,
            chapterName: getChapterDisplayName(newChapterData),
            chapterList: currentChapter.chapterList,
          ),
        ),
      ),
    );
  }

  /// Thêm manga vào danh sách theo dõi nếu đã đăng nhập.
  Future<void> followManga(BuildContext context, String mangaId) async {
    try {
      final String? token = await SecureStorageService.getToken();
      if (token == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Vui lòng đăng nhập để theo dõi truyện.'),
            ),
          );
        }
        return;
      }
      await userService.addToFollowing(mangaId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã thêm truyện vào danh sách theo dõi.'),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi khi thêm truyện: $e')));
      }
    }
  }

  /// Bỏ theo dõi manga nếu đã đăng nhập.
  Future<void> removeFromFollowing(BuildContext context, String mangaId) async {
    try {
      final String? token = await SecureStorageService.getToken();
      if (token == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Vui lòng đăng nhập để bỏ theo dõi truyện.'),
            ),
          );
        }
        return;
      }
      await userService.removeFromFollowing(mangaId);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Đã bỏ theo dõi truyện.')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi bỏ theo dõi truyện: $e')),
        );
      }
    }
  }

  /// Kiểm tra trạng thái theo dõi.
  Future<bool> isFollowingManga(String mangaId) async {
    try {
      final String? token = await SecureStorageService.getToken();
      if (token == null) {
        return false;
      }
      return await userService.checkIfUserIsFollowing(mangaId);
    } catch (e, s) {
      logger.w('Lỗi khi kiểm tra theo dõi', error: e, stackTrace: s);
      return false;
    }
  }

  /// Cập nhật tiến độ đọc lên backend nếu có token.
  Future<void> updateProgress(Chapter chapter) async {
    try {
      final String? token = await SecureStorageService.getToken();
      if (token != null) {
        final chapterData = getChapterData(chapter, chapter.chapterId);
        if (chapterData.isNotEmpty) {
          final attributes = chapterData['attributes'] as Map<String, dynamic>;
          final chapterInfo = ChapterInfo(
            id: chapter.chapterId,
            chapter: attributes['chapter'] as String?,
            title: attributes['title'] as String?,
            translatedLanguage: attributes['translatedLanguage'] as String,
          );
          await userService.updateReadingProgress(chapter.mangaId, chapterInfo);
        }
      }
    } catch (e, s) {
      logger.w('Lỗi khi cập nhật tiến độ đọc', error: e, stackTrace: s);
    }
  }

  /// Hủy lắng nghe cuộn để tránh rò rỉ tài nguyên.
  void dispose() {
    scrollController.removeListener(_onScroll);
  }
}
```

#### 2.5. Cập nhật Chapter Reader Screen

Mở file `MangaReaderFrontend\lib\features\chapter_reader\view\chapter_reader_screen.dart` và điều chỉnh lại cách gọi hàm `updateProgress`.

```dart
// MangaReaderFrontend/lib/features/chapter_reader/view/chapter_reader_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../data/models/chapter_model.dart';
import '../../../data/services/user_api_service.dart';
import '../logic/chapter_reader_logic.dart';

/// Màn hình đọc chapter, hiển thị danh sách ảnh và các điều khiển.
class ChapterReaderScreen extends StatefulWidget {
  final Chapter chapter;
  const ChapterReaderScreen({super.key, required this.chapter});

  @override
  State<ChapterReaderScreen> createState() => _ChapterReaderScreenState();
}

class _ChapterReaderScreenState extends State<ChapterReaderScreen> {
  late ChapterReaderLogic _logic;
  late Future<List<String>> _chapterPages;
  final ScrollController _scrollController = ScrollController();
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _logic = ChapterReaderLogic(
      userService: UserApiService(),
      setState: (VoidCallback fn) {
        if (mounted) {
          setState(fn);
        }
      },
      scrollController: _scrollController,
    );

    _logic.updateProgress(widget.chapter);
    _chapterPages = _logic.fetchChapterPages(widget.chapter.chapterId);
    _checkFollowingStatus();
  }

  Future<void> _checkFollowingStatus() async {
    final bool followingStatus = await _logic.isFollowingManga(
      widget.chapter.mangaId,
    );
    if (mounted) {
      setState(() {
        _isFollowing = followingStatus;
      });
    }
  }

  @override
  void dispose() {
    _logic.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () =>
            setState(() => _logic.areBarsVisible = !_logic.areBarsVisible),
        child: Stack(
          children: <Widget>[
            FutureBuilder<List<String>>(
              future: _chapterPages,
              builder:
                  (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Lỗi:  ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Không có trang nào.'));
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CachedNetworkImage(
                          imageUrl: snapshot.data![index],
                          fit: BoxFit.fitWidth,
                          placeholder: (BuildContext context, String url) =>
                              const SizedBox(
                                height: 300,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          errorWidget:
                              (
                                BuildContext context,
                                String url,
                                Object error,
                              ) => const SizedBox(
                                height: 300,
                                child: Center(child: Icon(Icons.error)),
                              ),
                        );
                      },
                    );
                  },
            ),
            if (_logic.areBarsVisible) _buildOverlay(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final int currentIndex = _logic.getCurrentIndex(widget.chapter);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buildAppBar(context),
        _buildBottomNavBar(context, currentIndex),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: Colors.black54,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Center(
              child: Text(
                widget.chapter.chapterName,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(width: 48), // To balance the back button
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, int currentIndex) {
    return Container(
      color: Colors.black54,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => _logic.goToPreviousChapter(
              context,
              widget.chapter,
              currentIndex,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              '/',
              (Route<dynamic> route) => false,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.bookmark,
              color: _isFollowing ? Colors.green : Colors.white,
            ),
            onPressed: () async {
              if (_isFollowing) {
                await _logic.removeFromFollowing(
                  context,
                  widget.chapter.mangaId,
                );
              } else {
                await _logic.followManga(context, widget.chapter.mangaId);
              }
              _checkFollowingStatus();
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: () =>
                _logic.goToNextChapter(context, widget.chapter, currentIndex),
          ),
        ],
      ),
    );
  }
}
```

#### 2.6. Cập nhật Account Screen Logic

Cuối cùng, mở file `MangaReaderFrontend\lib\features\account\logic\account_logic.dart` và cập nhật hàm `_buildMangaListItem` để hiển thị thông tin chapter từ lịch sử mà không cần gọi API.

```dart
// MangaReaderFrontend/lib/features/account/logic/account_logic.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:manga_reader_app/core/services/language_service.dart';
import 'package:manga_reader_app/data/models/manga/manga.dart';
import 'package:manga_reader_app/data/models/manga/relationship.dart';
import '../../../config/google_signin_config.dart';
import '../../../data/models/chapter_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/mangadex_api_service.dart';
import '../../../data/services/user_api_service.dart';
import '../../../data/storage/secure_storage_service.dart';
import '../../../utils/logger.dart';
import '../../../utils/manga_helper.dart';
import '../../chapter_reader/view/chapter_reader_screen.dart';
import '../../detail_manga/view/manga_detail_screen.dart';

/// Lớp nghiệp vụ cho màn hình tài khoản.
///
/// Quản lý đăng nhập/đăng xuất, tải dữ liệu user, hiển thị danh sách theo dõi
/// và lịch sử đọc, cùng các tương tác liên quan.
class AccountScreenLogic {
  final MangaDexApiService _mangaDexService = MangaDexApiService();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>['email', 'profile'],
    serverClientId: GoogleSignInConfig.serverClientId,
  );
  final UserApiService _userService = UserApiService();
  final Map<String, Manga> _mangaCache = <String, Manga>{};

  User? user;
  bool isLoading = false;
  late BuildContext context;
  late VoidCallback refreshUI;

  /// Khởi tạo context và hàm cập nhật UI, sau đó tải dữ liệu người dùng.
  Future<void> init(BuildContext context, VoidCallback refreshUI) async {
    this.context = context;
    this.refreshUI = refreshUI;
    await _loadUser();
  }

  /// Tải thông tin người dùng từ backend nếu có token hợp lệ.
  Future<void> _loadUser() async {
    isLoading = true;
    refreshUI();
    try {
      final bool hasToken = await SecureStorageService.hasValidToken();
      if (hasToken) {
        user = await _fetchUserData();
      } else {
        user = null;
      }
    } catch (e, s) {
      user = null;
      if (e is HttpException && (e.message == '403' || e.message == '401')) {
          logger.w('Token không hợp lệ, buộc đăng xuất.');
          await handleSignOut();
      }
      logger.e('Lỗi khi tải người dùng', error: e, stackTrace: s);
    } finally {
      isLoading = false;
      refreshUI();
    }
  }

  /// Xử lý đăng nhập Google và đồng bộ dữ liệu người dùng.
  Future<void> handleGoogleSignIn() async {
    isLoading = true;
    refreshUI();
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        isLoading = false;
        refreshUI();
        return;
      }
      await _userService.signInWithGoogle(account);
      user = await _fetchUserData();
    } catch (error, s) {
      logger.e('Lỗi đăng nhập Google', error: error, stackTrace: s);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi đăng nhập Google: $error')));
      }
      user = null;
    } finally {
      isLoading = false;
      refreshUI();
    }
  }

  /// Xử lý đăng xuất và dọn dẹp token.
  Future<void> handleSignOut() async {
    try {
      await _googleSignIn.signOut();
      await _userService.logout();
      user = null;
      _mangaCache.clear();
      refreshUI();
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi đăng xuất: $error')));
      }
    }
  }

  /// Làm mới dữ liệu người dùng.
  Future<void> refreshUserData() async {
    await _loadUser();
  }

  /// Gọi service lấy dữ liệu người dùng.
  Future<User> _fetchUserData() async {
    return _userService.getUserData();
  }

  /// Bỏ theo dõi một manga và cập nhật giao diện.
  Future<void> handleUnfollow(String mangaId) async {
    try {
      if (user == null) {
        throw Exception('Người dùng chưa đăng nhập');
      }
      isLoading = true;
      refreshUI();
      await _userService.removeFromFollowing(mangaId);
      user = await _fetchUserData();
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Đã bỏ theo dõi truyện')));
      }
    } catch (e, s) {
      logger.e('Lỗi trong handleUnfollow', error: e, stackTrace: s);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi khi bỏ theo dõi: $e')));
      }
    } finally {
      isLoading = false;
      refreshUI();
    }
  }

  /// Lấy thông tin các manga dựa trên danh sách `mangaIds` và cache kết quả.
  Future<List<Manga>> _getMangaListInfo(List<String> mangaIds) async {
    try {
      final List<Manga> mangas = await _mangaDexService.fetchMangaByIds(
        mangaIds,
      );
      for (final Manga manga in mangas) {
        _mangaCache[manga.id] = manga;
      }
      return mangas;
    } catch (e, s) {
      logger.w(
        'Lỗi khi lấy thông tin danh sách manga',
        error: e,
        stackTrace: s,
      );
      return <Manga>[];
    }
  }

  /// Xây dựng danh sách manga theo tiêu đề và id.
  Widget buildMangaListView(
    String title,
    List<String> mangaIds, {
    bool isFollowing = false,
  }) {
    if (mangaIds.isEmpty) {
      return Card(
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text('Không có truyện nào.'),
            ],
          ),
        ),
      );
    }

    return FutureBuilder<List<Manga>>(
      future: _getMangaListInfo(mangaIds),
      builder: (BuildContext context, AsyncSnapshot<List<Manga>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && _mangaCache.keys.where((k) => mangaIds.contains(k)).isEmpty) {
          return Card(
            child: ListTile(
              title: Text(title),
              subtitle: const Center(child: CircularProgressIndicator()),
            ),
          );
        }
        if (snapshot.hasError) {
          return Card(
            child: ListTile(
              title: Text(title),
              subtitle: Text('Lỗi: ${snapshot.error}'),
            ),
          );
        }
        
        final List<Manga> mangasFromIds = mangaIds
            .map((id) => _mangaCache[id])
            .whereType<Manga>()
            .toList();
        return Card(
          margin: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: mangasFromIds.length,
                itemBuilder: (BuildContext context, int index) {
                  final Manga manga = mangasFromIds[index];
                  ChapterInfo? lastReadChapterInfo;
                  if (!isFollowing && user != null) {
                    try {
                      final ReadingProgress progress = user!.readingProgress.firstWhere(
                          (p) => p.mangaId == manga.id);
                      lastReadChapterInfo = progress.lastReadChapter;
                    } catch (e) {
                      lastReadChapterInfo = null;
                    }
                  }
                  return _buildMangaListItem(
                    manga,
                    isFollowing: isFollowing,
                    lastReadChapterInfo: lastReadChapterInfo,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Xây dựng một item hiển thị manga.
  Widget _buildMangaListItem(
    Manga manga, {
    required bool isFollowing,
    ChapterInfo? lastReadChapterInfo,
  }) {
    final String title = manga.getDisplayTitle();
    return Container(
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withAlpha(51),
            blurRadius: 6.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    MangaDetailScreen(mangaId: manga.id),
              ),
            ),
            child: SizedBox(
              width: 80,
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: _buildCoverImage(manga),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 8),
                isFollowing
                  ? _buildLatestChapterInfo(manga.id)
                  : _buildLastReadChapterInfo(manga.id, lastReadChapterInfo),
              ],
            ),
          ),
          if (isFollowing)
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
              onPressed: () => handleUnfollow(manga.id),
            ),
        ],
      ),
    );
  }

  Widget _buildLatestChapterInfo(String mangaId) {
    return FutureBuilder<List<dynamic>>(
      future: _mangaDexService.fetchChapters(
        mangaId,
        LanguageService.instance.preferredLanguages,
        maxChapters: 1,
      ),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 50,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError || snapshot.data!.isEmpty) {
          return const Text('Không thể tải chapter');
        }
        final dynamic chapterData = snapshot.data!.first;
        final attributes = chapterData['attributes'] as Map<String, dynamic>;
        final String chapterNumber = attributes['chapter'] as String? ?? 'N/A';
        final String chapterTitle = attributes['title'] as String? ?? '';
        final String displayTitle = chapterTitle.isEmpty
            ? 'Chương $chapterNumber'
            : 'Chương $chapterNumber: $chapterTitle';
            
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            displayTitle,
            style: const TextStyle(fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () async {
            // Cần tải lại toàn bộ danh sách chapter khi nhấn vào
            final fullChapterList = await _mangaDexService.fetchChapters(
                mangaId, LanguageService.instance.preferredLanguages);
            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => ChapterReaderScreen(
                    chapter: Chapter(
                      mangaId: mangaId,
                      chapterId: chapterData['id'] as String,
                      chapterName: displayTitle,
                      chapterList: fullChapterList,
                    ),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildLastReadChapterInfo(String mangaId, ChapterInfo? chapterInfo) {
    if (chapterInfo == null) {
      return const Text('Chưa đọc chapter nào', style: TextStyle(fontSize: 13));
    }

    final chapterNumber = chapterInfo.chapter ?? 'N/A';
    final chapterTitle = chapterInfo.title ?? '';
    final displayTitle = chapterTitle.isEmpty || chapterTitle == chapterNumber
        ? 'Đang đọc: Chương $chapterNumber'
        : 'Đang đọc: Chương $chapterNumber: $chapterTitle';
        
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        displayTitle,
        style: const TextStyle(fontSize: 13),
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () async {
        final fullChapterList = await _mangaDexService.fetchChapters(
            mangaId, LanguageService.instance.preferredLanguages);
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => ChapterReaderScreen(
                chapter: Chapter(
                  mangaId: mangaId,
                  chapterId: chapterInfo.id,
                  chapterName: displayTitle.replaceFirst('Đang đọc: ', ''),
                  chapterList: fullChapterList,
                ),
              ),
            ),
          );
        }
      },
    );
  }


  /// Dựng widget ảnh bìa cho manga.
  Widget _buildCoverImage(Manga manga) {
    String? coverFileName;
    try {
      final Relationship coverArtRelationship = manga.relationships.firstWhere(
        (rel) => rel.type == 'cover_art',
      );
      if (coverArtRelationship.attributes != null) {
        coverFileName = coverArtRelationship.attributes!['fileName'] as String?;
      }
    } catch (e) {
      coverFileName = null;
    }

    if (coverFileName != null) {
      final String imageUrl =
          'https://uploads.mangadex.org/covers/${manga.id}/$coverFileName.512.jpg';
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) =>
                const Icon(Icons.broken_image),
      );
    }
    return const Icon(Icons.broken_image);
  }

  /// Giải phóng tài nguyên nếu cần.
  void dispose() {
    _userService.dispose();
  }
}
```