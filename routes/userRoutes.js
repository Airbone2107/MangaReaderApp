const express = require('express');
const router = express.Router();
const User = require('../models/User');
const jwt = require('jsonwebtoken');
const { OAuth2Client } = require('google-auth-library');
const { JWT_SECRET, GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET, GOOGLE_REDIRECT_URI } = process.env;

// Khởi tạo client với đầy đủ thông tin
const client = new OAuth2Client(
  GOOGLE_CLIENT_ID,
  GOOGLE_CLIENT_SECRET,
  GOOGLE_REDIRECT_URI || 'https://manga-reader-app-backend.onrender.com/api/users/auth/google/callback'
);

// Các route cho OAuth Web application
// Tạo URL xác thực Google
router.get('/auth/google/url', (req, res) => {
  const authUrl = client.generateAuthUrl({
    access_type: 'offline',
    scope: [
      'https://www.googleapis.com/auth/userinfo.profile',
      'https://www.googleapis.com/auth/userinfo.email'
    ]
  });
  
  res.json({ authUrl });
});

// Xử lý callback từ Google
router.get('/auth/google/callback', async (req, res) => {
  const { code } = req.query;
  
  if (!code) {
    return res.status(400).json({ message: 'Không có mã xác thực' });
  }
  
  try {
    const { tokens } = await client.getToken({ code });
    
    const ticket = await client.verifyIdToken({
      idToken: tokens.id_token,
      audience: GOOGLE_CLIENT_ID
    });
    
    const payload = ticket.getPayload();
    const { email, sub: googleId, name, picture } = payload;
    
    // Tìm hoặc tạo user
    let user = await User.findOne({ email });
    if (!user) {
      user = new User({
        googleId,
        email,
        displayName: name,
        photoURL: picture,
      });
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
    // Chuyển hướng đến frontend với token
    const frontendUrl = process.env.FRONTEND_URL || 'http://localhost:5074';
    res.redirect(`${frontendUrl}/auth/callback?token=${token}`);
  } catch (error) {
    console.error('Lỗi xác thực Google:', error);
    if (error.response && error.response.data) {
      console.error('Google API Error:', error.response.data);
      res.status(400).json({ message: `Lỗi từ Google: ${error.response.data.error_description || error.response.data.error}` });
    } else {
      res.status(500).json({ message: 'Lỗi máy chủ khi xác thực Google' });
    }
  }
});

// Route đăng nhập Google cho Android
router.post('/auth/google', async (req, res) => {
  const { accessToken } = req.body;

  if (!accessToken) {
    return res.status(400).json({ message: 'Không có token xác thực' });
  }

  try {
    // Xác thực accessToken và lấy thông tin người dùng từ Google
    const response = await fetch('https://www.googleapis.com/oauth2/v2/userinfo', {
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
    });

    if (!response.ok) {
      throw new Error('Failed to verify Google token');
    }

    const userData = await response.json();
    const { email, id, name, picture } = userData;

    // Tìm hoặc tạo user
    let user = await User.findOne({ email });
    if (!user) {
      user = new User({
        googleId: id,
        email,
        displayName: name,
        photoURL: picture,
      });
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
    console.error('Lỗi xác thực Google:', error);
    res.status(401).json({ message: 'Token không hợp lệ' });
  }
});

// Middleware xác thực JWT
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  console.log('[AuthMiddleware] Received Token:', token);
  console.log('[AuthMiddleware] JWT_SECRET Exists:', !!JWT_SECRET);

  if (!token) return res.status(401).json({ message: 'Token không tìm thấy' });

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      console.error('[AuthMiddleware] JWT Verification Error:', err.name, err.message);
      if (err.name === 'TokenExpiredError') {
        return res.status(401).json({ message: 'Token đã hết hạn' });
      }
      return res.status(403).json({ message: 'Token không hợp lệ' });
    }
    req.user = user;
    next();
  });
};

// Thêm manga vào danh sách theo dõi
router.post('/follow', authenticateToken, async (req, res) => {
  try {
    const { mangaId } = req.body;
    const user = await User.findById(req.user.userId);

    if (!user) {
      return res.status(404).json({ message: 'Không tìm thấy người dùng' });
    }

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
    const user = await User.findById(req.user.userId);

    if (!user) {
      return res.status(404).json({ message: 'Không tìm thấy người dùng' });
    }

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
    const user = await User.findById(req.user.userId);
    if (!user) {
      return res.status(404).json({ message: 'Không tìm thấy người dùng' });
    }

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
    const user = await User.findById(req.user.userId).select('-tokens');

    if (!user) {
      return res.status(404).json({ message: 'Không tìm thấy người dùng' });
    }
    
    res.json(user);
  } catch (error) {
    console.error('Lỗi lấy thông tin người dùng:', error);
    res.status(500).json({ message: error.message });
  }
});

// Route đăng xuất
router.post('/logout', authenticateToken, async (req, res) => {
  try {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    const user = await User.findById(req.user.userId);

    if (user && token) {
      await user.removeToken(token);
    }
    res.json({ message: 'Đăng xuất thành công' });
  } catch (error) {
    console.error('Logout error:', error);
    res.status(500).json({ message: 'Lỗi khi đăng xuất' });
  }
});

// API kiểm tra xem người dùng có theo dõi manga không
router.get('/user/following/:mangaId', authenticateToken, async (req, res) => {
  const { mangaId } = req.params;

  try {
    const user = await User.findById(req.user.userId);

    if (!user) {
      return res.status(404).json({ message: 'Không tìm thấy người dùng' });
    }

    // Kiểm tra xem mangaId có trong danh sách manga đang theo dõi của người dùng không
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
    const user = await User.findById(req.user.userId).select('readingManga'); // Chỉ lấy trường readingManga

    if (!user) {
      return res.status(404).json({ message: 'Không tìm thấy người dùng' });
    }

    // Sắp xếp lịch sử theo thời gian đọc gần nhất (giảm dần)
    const sortedHistory = user.readingManga.sort((a, b) => b.lastReadAt - a.lastReadAt);

    // Trả về danh sách lịch sử đọc (chỉ gồm mangaId, chapterId, lastReadAt)
    // Backend trả về đúng cấu trúc mà ReadingHistoryService.cs mong đợi
    const historyResponse = sortedHistory.map(item => ({
        mangaId: item.mangaId,
        chapterId: item.lastChapter, // Đảm bảo tên trường khớp
        lastReadAt: item.lastReadAt
    }));


    res.json(historyResponse); // Trả về mảng lịch sử đã sắp xếp

  } catch (error) {
    console.error('Lỗi lấy lịch sử đọc:', error);
    res.status(500).json({ message: 'Lỗi máy chủ khi lấy lịch sử đọc' });
  }
});

module.exports = router;