const express = require('express');
const router = express.Router();
const User = require('../models/User');
const jwt = require('jsonwebtoken');
const { OAuth2Client } = require('google-auth-library');
const { JWT_SECRET, GOOGLE_CLIENT_ID } = process.env;

// Khởi tạo client chỉ với Client ID cho việc xác thực idToken
const client = new OAuth2Client(GOOGLE_CLIENT_ID);

// Route đăng nhập Google cho Android (sử dụng idToken)
router.post('/auth/google', async (req, res) => {
  const { idToken } = req.body;

  if (!idToken) {
    return res.status(400).json({ message: 'Không có idToken được cung cấp' });
  }

  try {
    // Sử dụng google-auth-library để xác thực idToken
    const ticket = await client.verifyIdToken({
      idToken: idToken,
      audience: GOOGLE_CLIENT_ID,
    });

    const payload = ticket.getPayload();
    if (!payload) {
        throw new Error('Invalid ID token');
    }

    // Lấy thông tin người dùng từ payload
    const { email, sub: googleId, name, picture } = payload;
    
    // Tìm hoặc tạo user
    let user = await User.findOne({ email });
    if (!user) {
      user = new User({
        googleId: googleId,
        email,
        displayName: name,
        photoURL: picture,
      });
      await user.save();
    } else {
      // Cập nhật thông tin nếu người dùng đã tồn tại
      user.displayName = name;
      user.photoURL = picture;
      await user.save();
    }

    // Tạo JWT token
    const token = jwt.sign(
      { userId: user._id }, 
      JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN || '30d' }
    );

    // Lưu token vào cơ sở dữ liệu
    await user.addToken(token);

    res.json({ token });
  } catch (error) {
    console.error('Lỗi xác thực Google với idToken:', error);
    res.status(401).json({ message: 'Token không hợp lệ hoặc đã hết hạn' });
  }
});

// Middleware xác thực JWT
const authenticateToken = async (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1]; // Lấy token từ header 'Bearer <token>'

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

// Route lấy thông tin người dùng từ token
router.get('/', authenticateToken, async (req, res) => {
  try {
    // req.user đã được gán từ middleware
    const userResponse = req.user.toObject();
    delete userResponse.tokens; // Không trả về danh sách token
    res.json(userResponse);
  } catch (error) {
    console.error('Lỗi lấy thông tin người dùng:', error);
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