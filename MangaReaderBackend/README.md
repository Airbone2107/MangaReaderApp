# Manga Reader Backend

Backend cho ứng dụng đọc truyện Manga, hỗ trợ xác thực người dùng thông qua Google OAuth cho cả Android và Web.

## Triển khai

Backend được triển khai trên Render tại: https://manga-reader-app-backend.onrender.com

## Cài đặt (Cho môi trường phát triển)

1. Clone repository:
```bash
git clone <repository-url>
cd manga_reader_app_backend
```

2. Cài đặt dependencies:
```bash
npm install
```

3. Tạo file `.env` và cấu hình các biến môi trường:
```
# Các biến môi trường cơ bản
JWT_SECRET=your_jwt_secret_key
GOOGLE_CLIENT_ID=your_google_client_id
DB_URI=mongodb://localhost:27017/NhatDex_UserDB
PORT=3000

# Các biến môi trường cho OAuth Web
GOOGLE_REDIRECT_URI=https://manga-reader-app-backend.onrender.com/api/users/auth/google/callback
FRONTEND_URL=https://manga-reader-app-backend.onrender.com
JWT_EXPIRES_IN=30d
```

4. Khởi động server:
```bash
npm start
```

## Cấu hình Google OAuth

### Cho Android
1. Truy cập [Google Cloud Console](https://console.cloud.google.com/)
2. Tạo một dự án mới hoặc chọn dự án hiện có
3. Bật Google Sign-In API
4. Tạo thông tin xác thực OAuth 2.0 cho Android
5. Cấu hình SHA-1 fingerprint của ứng dụng Android
6. Cập nhật `GOOGLE_CLIENT_ID` trong file `.env`

### Cho Web
1. Truy cập [Google Cloud Console](https://console.cloud.google.com/)
2. Tạo một dự án mới hoặc chọn dự án hiện có
3. Bật Google Sign-In API
4. Tạo thông tin xác thực OAuth 2.0 cho Web
5. Cấu hình URI chuyển hướng được phép: `https://manga-reader-app-backend.onrender.com/api/users/auth/google/callback`
6. Cập nhật `GOOGLE_CLIENT_ID` và `GOOGLE_REDIRECT_URI` trong file `.env`

## API Endpoints

### Xác thực người dùng

#### Android
- `POST /api/users/auth/google`: Đăng nhập bằng Google (Android)
  - Request body: `{ "accessToken": "google_access_token" }`
  - Response: `{ "token": "jwt_token" }`

#### Web
- `GET /api/users/auth/google/url`: Lấy URL xác thực Google
  - Response: `{ "authUrl": "google_auth_url" }`
- `GET /api/users/auth/google/callback`: Callback từ Google sau khi xác thực
  - Redirects to: `FRONTEND_URL/auth/callback?token=jwt_token`

### Người dùng
- `GET /api/users`: Lấy thông tin người dùng hiện tại
- `POST /api/users/follow`: Thêm manga vào danh sách theo dõi
- `POST /api/users/unfollow`: Xóa manga khỏi danh sách theo dõi
- `POST /api/users/reading-progress`: Cập nhật tiến độ đọc
- `GET /api/users/user/following/:mangaId`: Kiểm tra xem người dùng có theo dõi manga không
- `POST /api/users/logout`: Đăng xuất

## Luồng xác thực Web

1. Frontend gọi API `GET /api/users/auth/google/url` để lấy URL xác thực Google
2. Frontend chuyển hướng người dùng đến URL xác thực Google
3. Người dùng đăng nhập và cấp quyền cho ứng dụng
4. Google chuyển hướng người dùng về `GOOGLE_REDIRECT_URI` với mã xác thực
5. Backend xác thực mã và tạo JWT token
6. Backend chuyển hướng người dùng về frontend với JWT token
7. Frontend lưu JWT token và sử dụng nó cho các request tiếp theo

## Bảo mật

- JWT token được lưu trữ trong cơ sở dữ liệu và tự động hết hạn sau 30 ngày
- Tất cả các request API (trừ xác thực) đều yêu cầu JWT token trong header `Authorization: Bearer <token>`
- CORS được cấu hình để chỉ cho phép các request từ frontend được chỉ định 