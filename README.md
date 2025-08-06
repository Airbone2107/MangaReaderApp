# README.md
# Manga Reader - Ứng dụng đọc truyện tranh Fullstack

Đây là repository chứa mã nguồn cho cả Frontend và Backend của ứng dụng Manga Reader.

## Cấu trúc thư mục

-   `/MangaReaderBackend`: Chứa mã nguồn cho máy chủ backend, được xây dựng bằng Node.js và Express.
-   `/MangaReaderFrontend`: Chứa mã nguồn cho ứng dụng di động, được xây dựng bằng Flutter.

## Hướng dẫn cài đặt và chạy

### Backend

1.  Di chuyển vào thư mục backend:
    ```bash
    cd MangaReaderBackend
    ```
2.  Cài đặt các gói phụ thuộc:
    ```bash
    npm install
    ```
3.  Tạo file `.env` và cấu hình các biến môi trường cần thiết (tham khảo file `MangaReaderBackend/README.md`).
4.  Chạy server ở chế độ phát triển:
    ```bash
    npm run dev
    ```

### Frontend

1.  Di chuyển vào thư mục frontend:
    ```bash
    cd MangaReaderFrontend
    ```
2.  Tải các gói phụ thuộc của Flutter:
    ```bash
    flutter pub get
    ```
3.  Chạy ứng dụng trên máy ảo hoặc thiết bị thật:
    ```bash
    flutter run
    ```