# Kế hoạch phát triển giao diện trang chủ mới cho MangaReader App

## 1. Tầm nhìn & Trải nghiệm người dùng tổng thể (UX Vision)

Mục tiêu là xây dựng lại hoàn toàn trang chủ để mang lại một trải nghiệm hiện đại, năng động, và khuyến khích người dùng khám phá nội dung. Giao diện sẽ được chia thành 3 phần chính theo chiều dọc, với cơ chế chuyển tiếp đặc biệt giữa các phần.

- **Cấu trúc chính:** Màn hình trang chủ sẽ là một `PageView` cuộn dọc, gồm 2 "trang":
    - **Trang 1:** Chứa **Phần 1 (Hero Section)**.
    - **Trang 2:** Chứa **Phần 2 (Khu vực Tab)** và **Phần 3 (Danh sách cập nhật)**.
- **Tương tác cuộn chính:** Khi người dùng cuộn dọc, màn hình sẽ "bắt dính" (snap) để chuyển đổi mượt mà giữa Trang 1 và Trang 2. Sẽ không có trạng thái cuộn nửa chừng giữa hai phần chính này.
- **Thanh điều hướng dưới (Bottom Navigation Bar):** Phải luôn được hiển thị, không bị ảnh hưởng bởi các hiệu ứng cuộn của trang chủ.

## 2. Phân tích chi tiết từng phần

### Phần 1: Hero Section (Fullscreen)

Đây là phần đầu tiên người dùng nhìn thấy, được thiết kế để gây ấn tượng mạnh và nổi bật.

- **Bố cục (Layout):**
    - Phải luôn lấp đầy toàn bộ màn hình của thiết bị (fullscreen).
    - Nội dung bao gồm 3 hàng cuộn ngang (carousels) riêng biệt, tương ứng với 3 mục:
        1.  10 truyện nổi bật nhất tuần.
        2.  10 truyện nổi bật nhất tháng.
        3.  10 truyện mới được cập nhật.

- **Tương tác & Hiệu ứng (Interaction & Effects):**
    - **Nhấn mạnh item:** Đối với mỗi carousel, khi người dùng cuộn ngang, item truyện đang ở vị trí trung tâm phải được nhấn mạnh (ví dụ: phóng to nhẹ, nổi bật hơn các item khác).
    - **Hiển thị thông tin:** Đồng thời với hiệu ứng nhấn mạnh, thông tin chi tiết của item đó (bao gồm **Tên truyện, Mô tả ngắn, và các Tags liên quan**) phải được hiển thị ở phía **bên phải** của ảnh bìa.
    - **Điều hướng:** Người dùng phải có thể **bấm trực tiếp** vào item truyện đang được nhấn mạnh để điều hướng đến màn hình chi tiết của truyện đó (`MangaDetailScreen`).

- **Chuyển tiếp (Transition):**
    - Khi người dùng đang ở Phần 1 và thực hiện thao tác cuộn dọc, ứng dụng phải tự động chuyển trang (snap) hoàn toàn sang Phần 2.

### Phần 2: Khu vực khám phá theo Tab

Phần này nằm ở đầu của "Trang 2", ngay sau khi người dùng cuộn qua Phần 1.

- **Bố cục & Tương tác:**
    - **Thanh Tab dính (Sticky TabBar):** Phải có một thanh `TabBar` chứa các danh mục (ví dụ: "Nhiều theo dõi nhất", "Manga", "Manhwa",...). Thanh Tab này phải **"dính" (stick)** ở cạnh trên của màn hình khi người dùng cuộn xuống.
    - **Hành vi khi bấm Tab:** Khi người dùng bấm vào một tab, màn hình phải tự động cuộn lên vị trí bắt đầu của Phần 2 (đưa `TabBar` về lại vị trí gốc của nó ở đầu màn hình).
    - **Nội dung Tab:**
        - Mỗi tab sẽ hiển thị một danh sách giới hạn **20 truyện**.
        - Ở cuối danh sách 20 truyện này, phải có một nút **"Xem tất cả"**.
    - **Điều hướng "Xem tất cả":** Khi bấm nút "Xem tất cả", ứng dụng phải điều hướng người dùng đến màn hình `AdvancedSearchScreen` và **tự động áp dụng các bộ lọc** tương ứng với tab mà họ vừa bấm (ví dụ: tab "Manhwa" sẽ mở trang tìm kiếm đã lọc sẵn truyện Manhwa).

- **Chuyển tiếp (Transition):**
    - Người dùng sẽ **cuộn dọc qua khỏi khu vực chứa nội dung của các tab** để di chuyển một cách liền mạch xuống Phần 3.

### Phần 3: Danh sách cập nhật (Cuộn vô hạn)

Đây là phần cuối cùng của trang chủ, cung cấp một danh sách truyện liên tục cập nhật.

- **Chức năng:**
    - Phải giữ nguyên logic **cuộn vô hạn (infinite scroll)** như trang chủ hiện tại, liên tục tải thêm truyện khi người dùng cuộn xuống cuối danh sách.

- **Bố cục & Tương tác:**
    - **Nút chuyển đổi View:** Ngay tại đầu của Phần 3 (bên dưới Phần 2), phải có một nút bấm cho phép người dùng **chuyển đổi qua lại giữa giao diện Lưới (Grid) và Danh sách (List)**.
    - **Thiết kế Card:** Áp dụng thiết kế đặc biệt cho các item trong phần này (cả Grid và List view):
        - Tên truyện sẽ nằm **đè lên phần dưới** của ảnh bìa.
        - Phần nền chứa tên truyện phải được **làm mờ nhẹ bằng gradient** (ví dụ: từ trong suốt ở trên xuống màu đen mờ ở dưới) để đảm bảo tên truyện luôn dễ đọc trên mọi ảnh bìa.

## 3. Yêu cầu về API & Dữ liệu (Sử dụng `GET /manga` của MangaDex)

- **Phần 1 - Hero Section:**
    - **Top 10 Tuần:** `limit=10`, `order[followedCount]=desc`, `updatedAtSince=<ngày cách đây 7 ngày>`.
    - **Top 10 Tháng:** `limit=10`, `order[followedCount]=desc`, `updatedAtSince=<ngày cách đây 30 ngày>`.
    - **10 Mới cập nhật:** `limit=10`, `order[latestUploadedChapter]=desc`.

- **Phần 2 - Tab Section:** Mỗi tab sẽ có một lệnh gọi API riêng với `limit=20`.
    - **Nhiều theo dõi nhất:** `order[followedCount]=desc`.
    - **Manga nổi bật:** `originalLanguage[]=ja`, `order[rating]=desc`.
    - **Manhwa nổi bật:** `originalLanguage[]=ko`, `order[rating]=desc`.
    - **Manhua nổi bật:** `originalLanguage[]=zh`, `order[rating]=desc`.
    - *(Tương tự cho các tab khác như "Đã hoàn thành" (`status[]=completed`)).*

- **Phần 3 - Infinite Scroll:**
    - **Logic tải:** Sử dụng `limit` và `offset` để phân trang.
    - **Sắp xếp:** `order[latestUploadedChapter]=desc`.

- **Yêu cầu chung:** Mọi lệnh gọi API lấy danh sách manga phải bao gồm `includes[]='cover_art'` để có dữ liệu ảnh bìa. Các lệnh gọi cho Phần 1 nên bao gồm thêm `includes[]='tag'` để hiển thị tag trong phần thông tin.
```