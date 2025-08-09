### **Phần 1: Hướng dẫn Cấu hình Dịch vụ Gửi Email (Gmail SMTP)**

Để gửi email xác thực và reset mật khẩu, chúng ta sẽ dùng `Nodemailer` với tài khoản Gmail. Vì lý do bảo mật, Google không cho phép dùng mật khẩu tài khoản thông thường để đăng nhập từ ứng dụng bên ngoài. Thay vào đó, bạn cần tạo một **"Mật khẩu ứng dụng" (App Password)**.

**Các bước thực hiện:**

1.  **Bật Xác minh 2 bước:**
    *   Truy cập vào trang quản lý Tài khoản Google của bạn: [https://myaccount.google.com/](https://myaccount.google.com/)
    *   Vào mục **Bảo mật** (Security) ở menu bên trái.
    *   Trong phần "Cách bạn đăng nhập vào Google", tìm và nhấp vào **Xác minh 2 bước** (2-Step Verification).
    *   Nếu chưa bật, hãy làm theo hướng dẫn để bật tính năng này. **Đây là bước bắt buộc** để tạo Mật khẩu ứng dụng.

2.  **Tạo Mật khẩu ứng dụng:**
    *   Sau khi bật Xác minh 2 bước, quay lại trang **Bảo mật**.
    *   Trong phần "Cách bạn đăng nhập vào Google", bây giờ bạn sẽ thấy mục **Mật khẩu ứng dụng** (App passwords). Nhấp vào đó.
    *   Bạn có thể được yêu cầu đăng nhập lại.
    *   Trong màn hình Mật khẩu ứng dụng:
        *   Ở phần "Chọn ứng dụng", chọn **Khác (*Tên tùy chỉnh*)**.
        *   Nhập một tên gợi nhớ, ví dụ: `MangaReaderBackend`.
        *   Nhấp vào nút **TẠO** (GENERATE).
    *   Một cửa sổ sẽ hiện ra với mật khẩu gồm 16 ký tự. **Hãy sao chép ngay mật khẩu này và lưu lại cẩn thận.** Bạn sẽ không thể xem lại nó sau khi đóng cửa sổ.

3.  **Cấu hình Biến môi trường:**
    *   Trong thư mục gốc `MangaReaderBackend`, tạo một file tên là `.env` (nếu chưa có).
    *   Thêm các biến sau vào file `.env` của bạn. Thay thế các giá trị tương ứng:

    ```env
    # .env file
    
    # JWT
    JWT_SECRET=your_super_secret_jwt_key
    JWT_EXPIRES_IN=30d
    
    # Google Auth
    GOOGLE_CLIENT_ID=963474228375-u2rdskg9cc9q9m3k9bc5v6407598mf5r.apps.googleusercontent.com
    
    # MongoDB
    DB_URI=your_mongodb_connection_string
    
    # Email Configuration (NEW)
    EMAIL_HOST=smtp.gmail.com
    EMAIL_PORT=587
    EMAIL_USER=your-email@gmail.com
    EMAIL_PASS=your_16_character_app_password
    EMAIL_FROM="Manga Reader App <your-email@gmail.com>"
    ```

    *   `EMAIL_USER`: Địa chỉ email Gmail của bạn.
    *   `EMAIL_PASS`: Mật khẩu ứng dụng 16 ký tự bạn vừa tạo.
    *   `EMAIL_FROM`: Tên và địa chỉ email sẽ hiển thị ở người nhận.

---

### **Phần 2: Cài đặt Dependencies**

**Backend:**
Bạn cần thêm `bcryptjs` và `nodemailer`. Chạy lệnh sau trong thư mục `MangaReaderBackend`:

```bash
npm install bcryptjs nodemailer
```
Thư viện `crypto` đã được tích hợp sẵn trong Node.js, không cần cài đặt.

**Frontend:**
Không cần thêm thư viện mới ở bước này.

---

### **Phần 3: Thay đổi Mã nguồn**

Bây giờ, tôi sẽ cung cấp mã nguồn cho các file cần thay đổi và tạo mới.

#### **Backend**

**1. Tạo file tiện ích gửi email:**

*   `MangaReaderBackend/utils/emailService.js`

**2. Cập nhật Model:**

*   `MangaReaderBackend/models/User.js`: Cập nhật schema để hỗ trợ đăng nhập bằng email, thêm các trường và phương thức cần thiết.

**3. Cập nhật Routes:**

*   `MangaReaderBackend/routes/userRoutes.js`: Bổ sung các API cho đăng ký, đăng nhập, xác thực, và quên mật khẩu.

**4. Cập nhật file chính:**

*   `MangaReaderBackend/index.js`: Kiểm tra các biến môi trường mới liên quan đến email.

#### **Frontend**

**1. Cập nhật Model và Service:**

*   `MangaReaderFrontend/lib/data/models/user_model.dart`: Cập nhật để đồng bộ với backend schema.
*   `MangaReaderFrontend/lib/data/services/user_api_service.dart`: Thêm các phương thức gọi API mới.

**2. Tạo các màn hình và logic cho luồng xác thực mới:**

*   Tạo thư mục mới `MangaReaderFrontend/lib/features/auth`
*   `MangaReaderFrontend/lib/features/auth/view/login_screen.dart`
*   `MangaReaderFrontend/lib/features/auth/view/register_screen.dart`
*   `MangaReaderFrontend/lib/features/auth/view/forgot_password_screen.dart`

**3. Cập nhật màn hình tài khoản:**

*   `MangaReaderFrontend/lib/features/account/logic/account_logic.dart`: Đổi tên hàm `handleSignIn` thành `handleGoogleSignIn` cho rõ ràng.
*   `MangaReaderFrontend/lib/features/account/view/account_screen.dart`: Cập nhật để hiển thị các tùy chọn đăng nhập và điều hướng đến các màn hình mới.

---

### **Phần 4: Chạy và Kiểm tra**

1.  **Chạy lại Backend:** Khởi động lại server backend của bạn để áp dụng các thay đổi về mã nguồn và biến môi trường.
2.  **Cập nhật Frontend:**
    *   Sao chép các file frontend đã thay đổi và tạo mới.
    *   Chạy `flutter pub get` trong thư mục `MangaReaderFrontend`.
    *   Chạy lại build runner để tạo các file `.freezed.dart` và `.g.dart` mới cho `user_model.dart`:
        ```bash
        flutter pub run build_runner build --delete-conflicting-outputs
        ```
3.  **Kiểm tra luồng:**
    *   Thử đăng ký tài khoản mới bằng email.
    *   Kiểm tra email và nhấp vào link xác thực.
    *   Đăng nhập bằng tài khoản vừa tạo.
    *   Thử chức năng quên mật khẩu.
    *   Đăng nhập bằng Google để đảm bảo luồng cũ vẫn hoạt động.

Hãy xem lại các thay đổi và cho tôi biết nếu bạn có bất kỳ câu hỏi nào.
```

### **Mã nguồn cập nhật**

Dưới đây là toàn bộ mã nguồn của các file đã thay đổi hoặc được tạo mới.

#### **Backend**

```javascript
// MangaReaderBackend/utils/emailService.js
const nodemailer = require('nodemailer');

const sendEmail = async (options) => {
  // 1. Tạo một transporter
  const transporter = nodemailer.createTransport({
    host: process.env.EMAIL_HOST,
    port: process.env.EMAIL_PORT,
    secure: false, // true cho port 465, false cho các port khác
    auth: {
      user: process.env.EMAIL_USER,
      pass: process.env.EMAIL_PASS,
    },
    // Nếu dùng Gmail, bạn có thể cần tắt các tùy chọn bảo mật ít hơn
    // hoặc sử dụng "Mật khẩu ứng dụng"
  });

  // 2. Định nghĩa các tùy chọn email
  const mailOptions = {
    from: process.env.EMAIL_FROM,
    to: options.email,
    subject: options.subject,
    text: options.message,
    // html: tùy chọn nếu muốn gửi email dạng HTML
  };

  // 3. Gửi email
  await transporter.sendMail(mailOptions);
};

module.exports = sendEmail;
```

```javascript
// MangaReaderBackend/models/User.js
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const crypto = require('crypto');

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
    sparse: true // Cho phép nhiều document có giá trị null cho trường này
  },
  email: {
    type: String,
    required: [true, 'Vui lòng cung cấp email của bạn'],
    unique: true,
    lowercase: true,
  },
  password: {
    type: String,
    select: false // Ẩn mật khẩu theo mặc định khi truy vấn
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
    type: String // Manga IDs
  }],
  readingManga: [{
    mangaId: {
      type: String,
      required: true
    },
    lastChapter: {
      type: String,
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
      expires: '30d' // Tự động xóa token sau 30 ngày
    }
  }],
  createdAt: {
    type: Date,
    default: Date.now
  }
});

// Middleware để mã hóa mật khẩu trước khi lưu
userSchema.pre('save', async function(next) {
  // Chỉ chạy hàm này nếu mật khẩu đã được sửa đổi
  if (!this.isModified('password')) return next();

  // Mã hóa mật khẩu với cost là 12
  this.password = await bcrypt.hash(this.password, 12);

  next();
});

// Method để so sánh mật khẩu ứng viên với mật khẩu của người dùng
userSchema.methods.comparePassword = async function(candidatePassword) {
  if (!this.password) return false;
  return await bcrypt.compare(candidatePassword, this.password);
};

// Method để tạo token xác thực (dạng link)
userSchema.methods.generateVerificationToken = function() {
  const token = crypto.randomBytes(32).toString('hex');

  this.verificationToken = crypto
    .createHash('sha256')
    .update(token)
    .digest('hex');
  
  // Đặt token hết hạn sau 24 giờ
  this.verificationTokenExpires = Date.now() + 24 * 60 * 60 * 1000; 

  return token; // Trả về token chưa hash để gửi qua email
};

// Method để tạo token reset mật khẩu (mã 6 số)
userSchema.methods.generatePasswordResetToken = function() {
  const resetToken = Math.floor(100000 + Math.random() * 900000).toString();

  this.passwordResetToken = crypto
    .createHash('sha256')
    .update(resetToken)
    .digest('hex');

  // Đặt token hết hạn sau 1 giờ
  this.passwordResetTokenExpires = Date.now() + 60 * 60 * 1000;

  return resetToken; // Trả về mã 6 số chưa hash
};


// Thêm method để quản lý token
userSchema.methods.addToken = async function(token) {
  this.tokens = this.tokens || [];
  this.tokens.push({ token });
  await this.save({ validateBeforeSave: false }); // Bỏ qua validation khi chỉ quản lý token
  return token;
};

userSchema.methods.removeToken = async function(token) {
  this.tokens = this.tokens.filter(t => t.token !== token);
  await this.save({ validateBeforeSave: false }); // Bỏ qua validation khi chỉ quản lý token
};

module.exports = mongoose.model('User', userSchema);
```

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

// Khởi tạo client chỉ với Client ID cho việc xác thực idToken
const client = new OAuth2Client(GOOGLE_CLIENT_ID);

// --- NEW: Email + Password Authentication ---

// 1. Đăng ký người dùng mới
router.post('/register', async (req, res) => {
  try {
    const { displayName, email, password } = req.body;

    if (!displayName || !email || !password) {
      return res.status(400).json({ message: 'Vui lòng cung cấp tên hiển thị, email và mật khẩu.' });
    }

    const existingUser = await User.findOne({ email, authProvider: 'email' });
    if (existingUser) {
      return res.status(409).json({ message: 'Một tài khoản với email này đã tồn tại.' });
    }

    const newUser = new User({
      displayName,
      email,
      password,
      authProvider: 'email',
    });

    const verificationToken = newUser.generateVerificationToken();
    await newUser.save();

    // Gửi email xác thực
    // Lưu ý: Trong môi trường production, URL này nên trỏ tới frontend của bạn
    const verificationURL = `http://localhost:3000/api/users/verify/${verificationToken}`; 
    const message = `Chào mừng bạn đến với Manga Reader! Để hoàn tất đăng ký, vui lòng sử dụng liên kết sau để xác minh địa chỉ email của bạn. Liên kết này có hiệu lực trong 24 giờ.\n\n${verificationURL}\n\nNếu bạn không tạo tài khoản, vui lòng bỏ qua email này.`;

    try {
      await sendEmail({
        email: newUser.email,
        subject: 'Xác thực Email - Manga Reader',
        message
      });
      res.status(201).json({ message: 'Đăng ký thành công! Vui lòng kiểm tra email để xác minh tài khoản của bạn.' });
    } catch (emailError) {
      console.error('Lỗi gửi email:', emailError);
      // Xóa người dùng nếu gửi email thất bại để tránh tồn tại người dùng không thể xác minh
      await User.findByIdAndDelete(newUser._id);
      return res.status(500).json({ message: 'Không thể gửi email xác thực. Vui lòng thử lại sau.' });
    }
  } catch (error) {
    console.error('Lỗi đăng ký:', error);
    res.status(500).json({ message: 'Đã xảy ra lỗi trong quá trình đăng ký.', error: error.message });
  }
});

// 2. Xác thực Email
router.get('/verify/:token', async (req, res) => {
    try {
        const hashedToken = crypto.createHash('sha256').update(req.params.token).digest('hex');

        const user = await User.findOne({
            verificationToken: hashedToken,
            verificationTokenExpires: { $gt: Date.now() }
        });

        if (!user) {
            return res.status(400).send('<h1>Token không hợp lệ hoặc đã hết hạn.</h1><p>Vui lòng thử đăng ký lại.</p>');
        }

        user.isVerified = true;
        user.verificationToken = undefined;
        user.verificationTokenExpires = undefined;
        await user.save();
        
        // TODO: Redirect đến trang thành công trên frontend
        res.status(200).send('<h1>Email đã được xác thực thành công!</h1><p>Bây giờ bạn có thể đóng cửa sổ này và đăng nhập vào ứng dụng.</p>');

    } catch (error) {
        console.error('Lỗi xác thực:', error);
        res.status(500).send('<h1>Đã xảy ra lỗi trong quá trình xác thực.</h1>');
    }
});


// 3. Đăng nhập bằng Email/Password
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
    
    // Tạo JWT token
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

// 4. Quên mật khẩu
router.post('/forgot-password', async (req, res) => {
    try {
        const { email } = req.body;
        const user = await User.findOne({ email, authProvider: 'email' });

        if (!user) {
            // Gửi thông báo chung để tránh bị dò email
            return res.status(200).json({ message: 'Nếu có người dùng với email đó, một mã đặt lại mật khẩu đã được gửi.' });
        }

        const resetCode = user.generatePasswordResetToken();
        await user.save({ validateBeforeSave: false });

        const message = `Bạn đã yêu cầu đặt lại mật khẩu. Vui lòng sử dụng mã 6 chữ số sau để đặt lại mật khẩu của bạn. Mã có hiệu lực trong 1 giờ.\n\nMã của bạn: ${resetCode}\n\nNếu bạn không yêu cầu điều này, vui lòng bỏ qua email.`;

        try {
            await sendEmail({
                email: user.email,
                subject: 'Mã Đặt Lại Mật Khẩu Của Bạn - Manga Reader',
                message
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

// 5. Đặt lại mật khẩu
router.post('/reset-password', async (req, res) => {
    try {
        const { token, newPassword } = req.body;
        
        if (!token || !newPassword) {
            return res.status(400).json({ message: 'Vui lòng cung cấp mã đặt lại và mật khẩu mới.' });
        }

        const hashedToken = crypto.createHash('sha256').update(token).digest('hex');

        const user = await User.findOne({
            passwordResetToken: hashedToken,
            passwordResetTokenExpires: { $gt: Date.now() }
        });

        if (!user) {
            return res.status(400).json({ message: 'Mã không hợp lệ hoặc đã hết hạn.' });
        }

        user.password = newPassword;
        user.passwordResetToken = undefined;
        user.passwordResetTokenExpires = undefined;
        await user.save();

        // Tùy chọn: Đăng xuất người dùng khỏi tất cả các thiết bị bằng cách xóa token
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
    
    // Tìm user bằng googleId
    let user = await User.findOne({ googleId });
    if (!user) {
      // Nếu không tìm thấy, tạo user mới
      user = new User({
        googleId,
        email, // Email từ Google
        displayName: name,
        photoURL: picture,
        authProvider: 'google',
        isVerified: true, // Tài khoản Google được coi là đã xác thực
      });
      await user.save();
    } else {
      // Nếu tìm thấy, cập nhật thông tin
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

// Middleware xác thực JWT
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

// Route lấy thông tin người dùng từ token
router.get('/', authenticateToken, async (req, res) => {
  try {
    const userResponse = req.user.toObject();
    // Xóa các trường nhạy cảm trước khi gửi về client
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

// Thêm manga vào danh sách theo dõi
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

// Xóa manga khỏi danh sách theo dõi
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

// Cập nhật tiến độ đọc
router.post('/reading-progress', authenticateToken, async (req, res) => {
  try {
    const { mangaId, lastChapter } = req.body;
    const user = req.user;

    if (!mangaId || !lastChapter) {
      return res.status(400).json({ message: 'Thiếu thông tin cần thiết' });
    }

    const readingIndex = user.readingManga.findIndex(m => m.mangaId === mangaId);

    if (readingIndex > -1) {
      user.readingManga[readingIndex].lastChapter = lastChapter;
      user.readingManga[readingIndex].lastReadAt = new Date();
    } else {
      user.readingManga.push({
        mangaId,
        lastChapter: lastChapter,
        lastReadAt: new Date()
      });
    }

    await user.save();
    res.json({ readingManga: user.readingManga });
  } catch (error) {
    console.error('Update reading progress error:', error);
    res.status(500).json({ message: error.message });
  }
});

// Route đăng xuất
router.post('/logout', authenticateToken, async (req, res) => {
  try {
    await req.user.removeToken(req.token);
    res.json({ message: 'Đăng xuất thành công' });
  } catch (error) {
    console.error('Logout error:', error);
    res.status(500).json({ message: 'Lỗi khi đăng xuất' });
  }
});

// API kiểm tra xem người dùng có theo dõi manga không
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

// Route lấy lịch sử đọc của người dùng
router.get('/reading-history', authenticateToken, async (req, res) => {
  try {
    const user = req.user;
    
    const sortedHistory = user.readingManga.sort((a, b) => b.lastReadAt - a.lastReadAt);

    const historyResponse = sortedHistory.map(item => ({
        mangaId: item.mangaId,
        chapterId: item.lastChapter,
        lastReadAt: item.lastReadAt
    }));

    res.json(historyResponse);
  } catch (error) {
    console.error('Lỗi lấy lịch sử đọc:', error);
    res.status(500).json({ message: 'Lỗi máy chủ khi lấy lịch sử đọc' });
  }
});

module.exports = router;
```

```javascript
// MangaReaderBackend/index.js
const express = require('express');
const cors = require('cors');
require('dotenv').config();
const mongoose = require('mongoose');
const userRoutes = require('./routes/userRoutes');
const fs = require('fs');
const path = require('path');

// Kiểm tra các biến môi trường bắt buộc
const requiredEnvVars = [
  'JWT_SECRET', 
  'GOOGLE_CLIENT_ID', 
  'DB_URI',
  'EMAIL_HOST',
  'EMAIL_PORT',
  'EMAIL_USER',
  'EMAIL_PASS',
  'EMAIL_FROM'
];
requiredEnvVars.forEach(envVar => {
  if (!process.env[envVar]) {
    console.error(`Error: ${envVar} is not defined in environment variables`);
    process.exit(1);
  }
});

// Khởi tạo thư mục logs nếu chưa tồn tại
const logDir = path.join(__dirname, 'logs');
if (!fs.existsSync(logDir)) fs.mkdirSync(logDir);

const app = express();
const port = process.env.PORT || 3000;

// Middlewares
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));
app.use(express.json());

// Middleware để log request
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.originalUrl}`);
  next();
});

// Kết nối MongoDB
mongoose.connect(process.env.DB_URI, { dbName: 'NhatDex_UserDB' })
  .then(() => console.log('Đã kết nối với MongoDB - Database: NhatDex_UserDB'))
  .catch(error => console.error('Lỗi kết nối MongoDB:', error));

// Routes
app.use('/api/users', userRoutes);

// Routes chính
app.get('/', (req, res) => res.send('Manga Reader Backend đang chạy!'));
app.get('/ping', (req, res) => res.json({ status: 'success', message: 'Pong! Server đang hoạt động', timestamp: new Date() }));
app.get('/status', (req, res) => res.json({
  status: 'online',
  version: require('./package.json').version,
  uptime: process.uptime(),
  serverTime: new Date().toISOString(),
  environment: process.env.NODE_ENV || 'development'
}));

// Middleware xử lý lỗi
app.use((err, req, res, next) => {
  const timestamp = new Date().toISOString();
  const logMessage = `${timestamp} - ERROR: ${err.stack}`;
  console.error(logMessage);
  fs.appendFile(path.join(logDir, 'error.log'), logMessage + '\n', err => {
    if (err) console.error('Không thể ghi log vào file:', err);
  });
  res.status(500).json({ message: 'Internal Server Error', error: err.message, timestamp });
});

// Middleware cho route không tồn tại
app.use((req, res) => {
  const message = `Route không tồn tại: ${req.originalUrl}`;
  console.log(message);
  res.status(404).json({ message });
});

// Khởi động server
app.listen(port, '0.0.0.0', () => console.log(`Server đang chạy tại cổng ${port}`));
```

#### **Frontend**

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
    required String lastChapter,
    required DateTime lastReadAt,
    @JsonKey(name: '_id') String? id,
  }) = _ReadingProgress;

  factory ReadingProgress.fromJson(Map<String, dynamic> json) =>
      _$ReadingProgressFromJson(json);
}
```

```dart
// MangaReaderFrontend/lib/data/models/user_model.freezed.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$User {

@JsonKey(name: '_id') String get id; String? get googleId; String get email; String get displayName; String? get photoURL; String get authProvider; bool get isVerified;@JsonKey(name: 'followingManga') List<String> get following;@JsonKey(name: 'readingManga') List<ReadingProgress> get readingProgress; DateTime get createdAt;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, id) || other.id == id)&&(identical(other.googleId, googleId) || other.googleId == googleId)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.photoURL, photoURL) || other.photoURL == photoURL)&&(identical(other.authProvider, authProvider) || other.authProvider == authProvider)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&const DeepCollectionEquality().equals(other.following, following)&&const DeepCollectionEquality().equals(other.readingProgress, readingProgress)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,googleId,email,displayName,photoURL,authProvider,isVerified,const DeepCollectionEquality().hash(following),const DeepCollectionEquality().hash(readingProgress),createdAt);

@override
String toString() {
  return 'User(id: $id, googleId: $googleId, email: $email, displayName: $displayName, photoURL: $photoURL, authProvider: $authProvider, isVerified: $isVerified, following: $following, readingProgress: $readingProgress, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_id') String id, String? googleId, String email, String displayName, String? photoURL, String authProvider, bool isVerified,@JsonKey(name: 'followingManga') List<String> following,@JsonKey(name: 'readingManga') List<ReadingProgress> readingProgress, DateTime createdAt
});




}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? googleId = freezed,Object? email = null,Object? displayName = null,Object? photoURL = freezed,Object? authProvider = null,Object? isVerified = null,Object? following = null,Object? readingProgress = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,googleId: freezed == googleId ? _self.googleId : googleId // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,photoURL: freezed == photoURL ? _self.photoURL : photoURL // ignore: cast_nullable_to_non_nullable
as String?,authProvider: null == authProvider ? _self.authProvider : authProvider // ignore: cast_nullable_to_non_nullable
as String,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,following: null == following ? _self.following : following // ignore: cast_nullable_to_non_nullable
as List<String>,readingProgress: null == readingProgress ? _self.readingProgress : readingProgress // ignore: cast_nullable_to_non_nullable
as List<ReadingProgress>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String? googleId,  String email,  String displayName,  String? photoURL,  String authProvider,  bool isVerified, @JsonKey(name: 'followingManga')  List<String> following, @JsonKey(name: 'readingManga')  List<ReadingProgress> readingProgress,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.googleId,_that.email,_that.displayName,_that.photoURL,_that.authProvider,_that.isVerified,_that.following,_that.readingProgress,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String id,  String? googleId,  String email,  String displayName,  String? photoURL,  String authProvider,  bool isVerified, @JsonKey(name: 'followingManga')  List<String> following, @JsonKey(name: 'readingManga')  List<ReadingProgress> readingProgress,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.googleId,_that.email,_that.displayName,_that.photoURL,_that.authProvider,_that.isVerified,_that.following,_that.readingProgress,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '_id')  String id,  String? googleId,  String email,  String displayName,  String? photoURL,  String authProvider,  bool isVerified, @JsonKey(name: 'followingManga')  List<String> following, @JsonKey(name: 'readingManga')  List<ReadingProgress> readingProgress,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.googleId,_that.email,_that.displayName,_that.photoURL,_that.authProvider,_that.isVerified,_that.following,_that.readingProgress,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _User implements User {
  const _User({@JsonKey(name: '_id') required this.id, this.googleId, required this.email, required this.displayName, this.photoURL, required this.authProvider, required this.isVerified, @JsonKey(name: 'followingManga') required final  List<String> following, @JsonKey(name: 'readingManga') required final  List<ReadingProgress> readingProgress, required this.createdAt}): _following = following,_readingProgress = readingProgress;
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override@JsonKey(name: '_id') final  String id;
@override final  String? googleId;
@override final  String email;
@override final  String displayName;
@override final  String? photoURL;
@override final  String authProvider;
@override final  bool isVerified;
 final  List<String> _following;
@override@JsonKey(name: 'followingManga') List<String> get following {
  if (_following is EqualUnmodifiableListView) return _following;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_following);
}

 final  List<ReadingProgress> _readingProgress;
@override@JsonKey(name: 'readingManga') List<ReadingProgress> get readingProgress {
  if (_readingProgress is EqualUnmodifiableListView) return _readingProgress;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_readingProgress);
}

@override final  DateTime createdAt;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.googleId, googleId) || other.googleId == googleId)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.photoURL, photoURL) || other.photoURL == photoURL)&&(identical(other.authProvider, authProvider) || other.authProvider == authProvider)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&const DeepCollectionEquality().equals(other._following, _following)&&const DeepCollectionEquality().equals(other._readingProgress, _readingProgress)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,googleId,email,displayName,photoURL,authProvider,isVerified,const DeepCollectionEquality().hash(_following),const DeepCollectionEquality().hash(_readingProgress),createdAt);

@override
String toString() {
  return 'User(id: $id, googleId: $googleId, email: $email, displayName: $displayName, photoURL: $photoURL, authProvider: $authProvider, isVerified: $isVerified, following: $following, readingProgress: $readingProgress, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_id') String id, String? googleId, String email, String displayName, String? photoURL, String authProvider, bool isVerified,@JsonKey(name: 'followingManga') List<String> following,@JsonKey(name: 'readingManga') List<ReadingProgress> readingProgress, DateTime createdAt
});




}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? googleId = freezed,Object? email = null,Object? displayName = null,Object? photoURL = freezed,Object? authProvider = null,Object? isVerified = null,Object? following = null,Object? readingProgress = null,Object? createdAt = null,}) {
  return _then(_User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,googleId: freezed == googleId ? _self.googleId : googleId // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,photoURL: freezed == photoURL ? _self.photoURL : photoURL // ignore: cast_nullable_to_non_nullable
as String?,authProvider: null == authProvider ? _self.authProvider : authProvider // ignore: cast_nullable_to_non_nullable
as String,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,following: null == following ? _self._following : following // ignore: cast_nullable_to_non_nullable
as List<String>,readingProgress: null == readingProgress ? _self._readingProgress : readingProgress // ignore: cast_nullable_to_non_nullable
as List<ReadingProgress>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ReadingProgress {

 String get mangaId; String get lastChapter; DateTime get lastReadAt;@JsonKey(name: '_id') String? get id;
/// Create a copy of ReadingProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReadingProgressCopyWith<ReadingProgress> get copyWith => _$ReadingProgressCopyWithImpl<ReadingProgress>(this as ReadingProgress, _$identity);

  /// Serializes this ReadingProgress to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReadingProgress&&(identical(other.mangaId, mangaId) || other.mangaId == mangaId)&&(identical(other.lastChapter, lastChapter) || other.lastChapter == lastChapter)&&(identical(other.lastReadAt, lastReadAt) || other.lastReadAt == lastReadAt)&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mangaId,lastChapter,lastReadAt,id);

@override
String toString() {
  return 'ReadingProgress(mangaId: $mangaId, lastChapter: $lastChapter, lastReadAt: $lastReadAt, id: $id)';
}


}

/// @nodoc
abstract mixin class $ReadingProgressCopyWith<$Res>  {
  factory $ReadingProgressCopyWith(ReadingProgress value, $Res Function(ReadingProgress) _then) = _$ReadingProgressCopyWithImpl;
@useResult
$Res call({
 String mangaId, String lastChapter, DateTime lastReadAt,@JsonKey(name: '_id') String? id
});




}
/// @nodoc
class _$ReadingProgressCopyWithImpl<$Res>
    implements $ReadingProgressCopyWith<$Res> {
  _$ReadingProgressCopyWithImpl(this._self, this._then);

  final ReadingProgress _self;
  final $Res Function(ReadingProgress) _then;

/// Create a copy of ReadingProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mangaId = null,Object? lastChapter = null,Object? lastReadAt = null,Object? id = freezed,}) {
  return _then(_self.copyWith(
mangaId: null == mangaId ? _self.mangaId : mangaId // ignore: cast_nullable_to_non_nullable
as String,lastChapter: null == lastChapter ? _self.lastChapter : lastChapter // ignore: cast_nullable_to_non_nullable
as String,lastReadAt: null == lastReadAt ? _self.lastReadAt : lastReadAt // ignore: cast_nullable_to_non_nullable
as DateTime,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReadingProgress].
extension ReadingProgressPatterns on ReadingProgress {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReadingProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReadingProgress() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReadingProgress value)  $default,){
final _that = this;
switch (_that) {
case _ReadingProgress():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReadingProgress value)?  $default,){
final _that = this;
switch (_that) {
case _ReadingProgress() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String mangaId,  String lastChapter,  DateTime lastReadAt, @JsonKey(name: '_id')  String? id)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReadingProgress() when $default != null:
return $default(_that.mangaId,_that.lastChapter,_that.lastReadAt,_that.id);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String mangaId,  String lastChapter,  DateTime lastReadAt, @JsonKey(name: '_id')  String? id)  $default,) {final _that = this;
switch (_that) {
case _ReadingProgress():
return $default(_that.mangaId,_that.lastChapter,_that.lastReadAt,_that.id);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String mangaId,  String lastChapter,  DateTime lastReadAt, @JsonKey(name: '_id')  String? id)?  $default,) {final _that = this;
switch (_that) {
case _ReadingProgress() when $default != null:
return $default(_that.mangaId,_that.lastChapter,_that.lastReadAt,_that.id);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReadingProgress implements ReadingProgress {
  const _ReadingProgress({required this.mangaId, required this.lastChapter, required this.lastReadAt, @JsonKey(name: '_id') this.id});
  factory _ReadingProgress.fromJson(Map<String, dynamic> json) => _$ReadingProgressFromJson(json);

@override final  String mangaId;
@override final  String lastChapter;
@override final  DateTime lastReadAt;
@override@JsonKey(name: '_id') final  String? id;

/// Create a copy of ReadingProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReadingProgressCopyWith<_ReadingProgress> get copyWith => __$ReadingProgressCopyWithImpl<_ReadingProgress>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReadingProgressToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReadingProgress&&(identical(other.mangaId, mangaId) || other.mangaId == mangaId)&&(identical(other.lastChapter, lastChapter) || other.lastChapter == lastChapter)&&(identical(other.lastReadAt, lastReadAt) || other.lastReadAt == lastReadAt)&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mangaId,lastChapter,lastReadAt,id);

@override
String toString() {
  return 'ReadingProgress(mangaId: $mangaId, lastChapter: $lastChapter, lastReadAt: $lastReadAt, id: $id)';
}


}

/// @nodoc
abstract mixin class _$ReadingProgressCopyWith<$Res> implements $ReadingProgressCopyWith<$Res> {
  factory _$ReadingProgressCopyWith(_ReadingProgress value, $Res Function(_ReadingProgress) _then) = __$ReadingProgressCopyWithImpl;
@override @useResult
$Res call({
 String mangaId, String lastChapter, DateTime lastReadAt,@JsonKey(name: '_id') String? id
});




}
/// @nodoc
class __$ReadingProgressCopyWithImpl<$Res>
    implements _$ReadingProgressCopyWith<$Res> {
  __$ReadingProgressCopyWithImpl(this._self, this._then);

  final _ReadingProgress _self;
  final $Res Function(_ReadingProgress) _then;

/// Create a copy of ReadingProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mangaId = null,Object? lastChapter = null,Object? lastReadAt = null,Object? id = freezed,}) {
  return _then(_ReadingProgress(
mangaId: null == mangaId ? _self.mangaId : mangaId // ignore: cast_nullable_to_non_nullable
as String,lastChapter: null == lastChapter ? _self.lastChapter : lastChapter // ignore: cast_nullable_to_non_nullable
as String,lastReadAt: null == lastReadAt ? _self.lastReadAt : lastReadAt // ignore: cast_nullable_to_non_nullable
as DateTime,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}
```

```dart
// MangaReaderFrontend/lib/data/models/user_model.g.dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['_id'] as String,
  googleId: json['googleId'] as String?,
  email: json['email'] as String,
  displayName: json['displayName'] as String,
  photoURL: json['photoURL'] as String?,
  authProvider: json['authProvider'] as String,
  isVerified: json['isVerified'] as bool,
  following: (json['followingManga'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  readingProgress: (json['readingManga'] as List<dynamic>)
      .map((e) => ReadingProgress.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  '_id': instance.id,
  'googleId': instance.googleId,
  'email': instance.email,
  'displayName': instance.displayName,
  'photoURL': instance.photoURL,
  'authProvider': instance.authProvider,
  'isVerified': instance.isVerified,
  'followingManga': instance.following,
  'readingManga': instance.readingProgress.map((e) => e.toJson()).toList(),
  'createdAt': instance.createdAt.toIso8601String(),
};

_ReadingProgress _$ReadingProgressFromJson(Map<String, dynamic> json) =>
    _ReadingProgress(
      mangaId: json['mangaId'] as String,
      lastChapter: json['lastChapter'] as String,
      lastReadAt: DateTime.parse(json['lastReadAt'] as String),
      id: json['_id'] as String?,
    );

Map<String, dynamic> _$ReadingProgressToJson(_ReadingProgress instance) =>
    <String, dynamic>{
      'mangaId': instance.mangaId,
      'lastChapter': instance.lastChapter,
      'lastReadAt': instance.lastReadAt.toIso8601String(),
      '_id': instance.id,
    };
```

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
class UserApiService {
  final String baseUrl;
  final http.Client client;

  UserApiService({this.baseUrl = AppConfig.baseUrl, http.Client? client})
    : client = client ?? http.Client();

  // --- NEW: Email/Password Methods ---

  /// Đăng ký tài khoản mới bằng email.
  Future<String> register(String displayName, String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/api/users/register'),
      headers: _buildHeaders(null), // Không cần token
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
      headers: _buildHeaders(null), // Không cần token
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
      logger.t('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(response.body) as Map<String, dynamic>;
        final String backendToken = data['token'] as String;
        await SecureStorageService.saveToken(backendToken);
        logger.i('Đăng nhập thành công. Token từ backend đã được lưu.');
      } else {
        throw HttpException(
          'Đăng nhập thất bại: ${response.statusCode} - ${response.body}',
        );
      }
    } on HttpException {
      rethrow;
    } catch (e, s) {
      logger.e('Lỗi trong signInWithGoogle', error: e, stackTrace: s);
      throw Exception('Lỗi đăng nhập: $e');
    }
  }

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
      return false;
    }
  }

  Future<void> updateReadingProgress(String mangaId, String lastChapter) async {
    final String? token = await SecureStorageService.getToken();
    if (token == null) return;
    try {
      final http.Response response = await client.post(
        Uri.parse('$baseUrl/api/users/reading-progress'),
        headers: _buildHeaders(token),
        body: jsonEncode(<String, String>{
          'mangaId': mangaId,
          'lastChapter': lastChapter,
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
        'Đã cập nhật tiến độ đọc cho manga $mangaId, chapter $lastChapter',
      );
    } catch (e, s) {
      logger.e('Lỗi trong updateReadingProgress', error: e, stackTrace: s);
      if (e is HttpException) {
        rethrow;
      }
      throw Exception('Lỗi khi cập nhật tiến độ: $e');
    }
  }

  Map<String, String> _buildHeaders(String? token) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<String> _getTokenOrThrow() async {
    final String? token = await SecureStorageService.getToken();
    if (token == null) {
      logger.w('Không tìm thấy token. Yêu cầu đăng nhập.');
      throw const HttpException('Không tìm thấy token');
    }
    return token;
  }

  void dispose() {
    client.close();
  }
}
```

```dart
// MangaReaderFrontend/lib/features/account/logic/account_logic.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:manga_reader_app/config/language_config.dart';
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
        // Người dùng đã hủy đăng nhập
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
                  String? lastReadChapter;
                  if (!isFollowing && user != null) {
                    final ReadingProgress progress = user!.readingProgress
                        .firstWhere(
                          (ReadingProgress p) => p.mangaId == manga.id,
                           orElse: () => ReadingProgress(
                            mangaId: manga.id,
                            lastChapter: '',
                            lastReadAt: DateTime.fromMicrosecondsSinceEpoch(0),
                          ),
                        );
                    lastReadChapter = progress.lastChapter;
                  }
                  return _buildMangaListItem(
                    manga,
                    isFollowing: isFollowing,
                    lastReadChapter: lastReadChapter,
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
    String? lastReadChapter,
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
                FutureBuilder<List<dynamic>>(
                  future: _mangaDexService.fetchChapters(
                    manga.id,
                    LanguageConfig.preferredLanguages,
                  ),
                  builder:
                      (
                        BuildContext context,
                        AsyncSnapshot<List<dynamic>> snapshot,
                      ) {
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const SizedBox(
                            height: 50,
                            child: Center(child: Text('Chưa có chương mới')),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Text('Không thể tải chapter');
                        }
                        final dynamic chapter = snapshot.data!.first;
                        final String chapterNumber =
                            (chapter['attributes']
                                    as Map<String, dynamic>)['chapter']
                                as String? ??
                            'N/A';
                        final String chapterTitle =
                            (chapter['attributes']
                                    as Map<String, dynamic>)['title']
                                as String? ??
                            '';
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
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ChapterReaderScreen(
                                    chapter: Chapter(
                                      mangaId: manga.id,
                                      chapterId: chapter['id'] as String,
                                      chapterName: displayTitle,
                                      chapterList: snapshot.data!,
                                    ),
                                  ),
                            ),
                          ),
                        );
                      },
                ),
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

```dart
// MangaReaderFrontend/lib/features/account/view/account_screen.dart
import 'package:flutter/material.dart';
import 'package:manga_reader_app/features/auth/view/login_screen.dart';
import 'package:manga_reader_app/features/auth/view/register_screen.dart';
import '../../../data/models/user_model.dart';
import '../logic/account_logic.dart';

/// Màn hình quản lý tài khoản người dùng.
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final AccountScreenLogic _logic = AccountScreenLogic();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _logic.init(context, () {
        if (mounted) {
          setState(() {});
        }
      });
    });
  }

  @override
  void dispose() {
    _logic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tài khoản của bạn')),
      body: _buildBody(),
    );
  }

  /// Xây dựng phần thân theo trạng thái đăng nhập và tải dữ liệu.
  Widget _buildBody() {
    if (_logic.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_logic.user == null) {
      return _buildLoginOptions();
    }

    return RefreshIndicator(
      onRefresh: _logic.refreshUserData,
      child: _buildUserContent(),
    );
  }

  /// Hiển thị các lựa chọn đăng nhập/đăng ký.
  Widget _buildLoginOptions() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () async {
                final bool? success = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
                if (success == true) {
                  _logic.refreshUserData();
                }
              },
              child: const Text('Đăng nhập bằng Email'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                );
              },
              child: const Text('Đăng ký tài khoản mới'),
            ),
            const SizedBox(height: 20),
            const Row(
              children: <Widget>[
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('HOẶC'),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Image.asset('assets/google_logo.png', height: 24.0),
              label: const Text('Đăng nhập bằng Google'),
              onPressed: _logic.handleGoogleSignIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Nội dung khi người dùng đã đăng nhập.
  Widget _buildUserContent() {
    return Column(
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text(_logic.user!.displayName),
          accountEmail: Text(_logic.user!.email),
          currentAccountPicture:
              _logic.user!.photoURL != null && _logic.user!.photoURL!.isNotEmpty
              ? CircleAvatar(
                  backgroundImage: NetworkImage(_logic.user!.photoURL!),
                )
              : CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: Text(
                    _logic.user!.displayName.isNotEmpty
                        ? _logic.user!.displayName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children: <Widget>[
              if (_logic.user != null)
                _logic.buildMangaListView(
                  'Truyện Theo Dõi',
                  _logic.user!.following,
                  isFollowing: true,
                ),
              const SizedBox(height: 16),
              if (_logic.user != null)
              _logic.buildMangaListView(
                'Lịch Sử Đọc Truyện',
                _logic.user!.readingProgress
                    .map((ReadingProgress p) => p.mangaId)
                    .toList(),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: _logic.handleSignOut,
                  child: const Text('Đăng xuất'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
```

```dart
// MangaReaderFrontend/lib/features/auth/view/login_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:manga_reader_app/data/services/user_api_service.dart';
import 'package:manga_reader_app/features/auth/view/forgot_password_screen.dart';
import 'package:manga_reader_app/features/auth/view/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userApiService = UserApiService();
  bool _isLoading = false;
  bool _obscureText = true;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isLoading = true);

    try {
      await _userApiService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng nhập thành công!')),
        );
        Navigator.of(context).pop(true); // Trả về true để báo thành công
      }
    } on HttpException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${e.message}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã xảy ra lỗi không xác định.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _userApiService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng nhập')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Chào mừng trở lại!',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Vui lòng nhập email hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ForgotPasswordScreen()),
                    );
                  },
                  child: const Text('Quên mật khẩu?'),
                ),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('ĐĂNG NHẬP'),
                    ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
                child: const Text('Chưa có tài khoản? Đăng ký ngay'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

```dart
// MangaReaderFrontend/lib/features/auth/view/register_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:manga_reader_app/data/services/user_api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userApiService = UserApiService();
  bool _isLoading = false;
  bool _obscureText = true;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isLoading = true);

    try {
      final message = await _userApiService.register(
        _displayNameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Đăng ký thành công'),
            content: Text('$message\nVui lòng kiểm tra hộp thư của bạn để hoàn tất.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(); // Close dialog
                  Navigator.of(context).pop(); // Go back from register screen
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } on HttpException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${e.message}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã xảy ra lỗi không xác định.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _userApiService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng ký')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Tạo tài khoản mới',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _displayNameController,
                decoration: const InputDecoration(labelText: 'Tên hiển thị'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tên hiển thị';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Vui lòng nhập email hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Mật khẩu phải có ít nhất 6 ký tự';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('ĐĂNG KÝ'),
                    ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Đã có tài khoản? Đăng nhập'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

```dart
// MangaReaderFrontend/lib/features/auth/view/forgot_password_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:manga_reader_app/data/services/user_api_service.dart';

enum ForgotPasswordStage { enterEmail, enterCode, success }

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _userApiService = UserApiService();
  
  bool _isLoading = false;
  ForgotPasswordStage _stage = ForgotPasswordStage.enterEmail;

  Future<void> _sendCode() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    
    try {
      final message = await _userApiService.forgotPassword(_emailController.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        setState(() {
          _stage = ForgotPasswordStage.enterCode;
        });
      }
    } on HttpException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: ${e.message}')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final message = await _userApiService.resetPassword(
        _codeController.text.trim(),
        _newPasswordController.text.trim(),
      );
      if (mounted) {
        setState(() => _stage = ForgotPasswordStage.success);
      }
    } on HttpException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: ${e.message}')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    _userApiService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quên Mật Khẩu')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: _buildStageContent(),
        ),
      ),
    );
  }

  Widget _buildStageContent() {
    switch (_stage) {
      case ForgotPasswordStage.enterEmail:
        return _buildEnterEmailStage();
      case ForgotPasswordStage.enterCode:
        return _buildEnterCodeStage();
      case ForgotPasswordStage.success:
        return _buildSuccessStage();
    }
  }

  Widget _buildEnterEmailStage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Nhập email của bạn để nhận mã đặt lại mật khẩu.'),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
          validator: (value) => (value == null || !value.contains('@')) ? 'Email không hợp lệ' : null,
        ),
        const SizedBox(height: 24),
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(onPressed: _sendCode, child: const Text('GỬI MÃ')),
      ],
    );
  }

  Widget _buildEnterCodeStage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Một mã 6 chữ số đã được gửi đến ${_emailController.text}. Vui lòng nhập mã và mật khẩu mới của bạn.'),
        const SizedBox(height: 16),
        TextFormField(
          controller: _codeController,
          decoration: const InputDecoration(labelText: 'Mã 6 chữ số'),
          keyboardType: TextInputType.number,
          validator: (value) => (value == null || value.length != 6) ? 'Mã phải có 6 chữ số' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _newPasswordController,
          decoration: const InputDecoration(labelText: 'Mật khẩu mới'),
          obscureText: true,
          validator: (value) => (value == null || value.length < 6) ? 'Mật khẩu phải có ít nhất 6 ký tự' : null,
        ),
        const SizedBox(height: 24),
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(onPressed: _resetPassword, child: const Text('ĐẶT LẠI MẬT KHẨU')),
      ],
    );
  }

  Widget _buildSuccessStage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 80),
        const SizedBox(height: 16),
        Text(
          'Thành công!',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'Mật khẩu của bạn đã được đặt lại. Vui lòng đăng nhập lại.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('TRỞ VỀ ĐĂNG NHẬP'),
        ),
      ],
    );
  }
}
```

Cuối cùng, hãy tạo file ảnh logo Google nhỏ để dùng trong nút bấm. Bạn có thể tải một ảnh logo Google và đặt vào thư mục `assets`. Đảm bảo `pubspec.yaml` của bạn đã khai báo thư mục assets:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/
```

-   Tạo thư mục `assets` ở thư mục gốc của dự án `MangaReaderFrontend`.
-   Lưu một ảnh tên là `google_logo.png` vào đó.

Sau khi thực hiện các bước trên, ứng dụng của bạn sẽ có đầy đủ luồng xác thực bằng Email/Password song song với Google.