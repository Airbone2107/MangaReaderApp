const express = require('express');
const router = express.Router();
const User = require('../models/User');
const jwt = require('jsonwebtoken');
const { OAuth2Client } = require('google-auth-library');
const crypto = require('crypto');
const sendEmail = require('../utils/emailService');
const { JWT_SECRET, GOOGLE_CLIENT_ID } = process.env;

const client = new OAuth2Client(GOOGLE_CLIENT_ID);

// --- NEW: Email + Password Authentication ---

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

    const verificationURL = `http://localhost:3000/api/users/verify/${verificationToken}`;
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
    res.status(500).json({ message: 'Đã xảy ra lỗi trong quá trình đăng ký.', error: error.message });
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
        email,
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
    
    const sortedHistory = user.readingManga.sort((a, b) => b.lastReadAt - a.lastReadAt);

    const historyResponse = sortedHistory.map(item => ({
      mangaId: item.mangaId,
      chapterId: item.lastChapter,
      lastReadAt: item.lastReadAt,
    }));

    res.json(historyResponse);
  } catch (error) {
    console.error('Lỗi lấy lịch sử đọc:', error);
    res.status(500).json({ message: 'Lỗi máy chủ khi lấy lịch sử đọc' });
  }
});

module.exports = router;