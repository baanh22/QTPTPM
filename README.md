# QTPTPM

## Chạy dự án bằng Docker Desktop

Dự án gồm ba container được định nghĩa trong `docker-compose.yml`:

- `db`: MySQL 8.0, lưu cơ sở dữ liệu `QuanLyNhaSach`.
- `app`: PHP 8.2 và Apache, chạy API cùng frontend.
- `phpmyadmin`: giao diện quản trị MySQL.

### Khởi động

Mở PowerShell tại thư mục dự án:

```powershell
cd E:\QTPTPM
docker compose up -d --build
```

Sau khi khởi động:

- Ứng dụng: http://localhost:8088
- phpMyAdmin: http://localhost:8081
- MySQL từ máy host: `localhost:3307`

Đăng nhập phpMyAdmin bằng:

```text
Server: db
Username: root
Password: rootpassword
```

### Kiểm tra và dừng hệ thống

```powershell
docker compose ps
docker compose logs -f app
docker compose down
```

Lệnh `docker compose down` chỉ dừng và xóa container, không xóa dữ liệu MySQL vì dữ liệu nằm trong volume `db_data`.

### Cách hai file Docker hoạt động

`Dockerfile` tạo image cho ứng dụng PHP:

1. Dùng PHP 8.2 tích hợp Apache.
2. Cài extension `pdo_mysql` để PHP kết nối MySQL.
3. Bật Apache `mod_rewrite`.
4. Copy mã nguồn vào `/var/www/html/Quanlymuontrasach`.
5. Cấp quyền cho Apache và tạo chuyển hướng từ trang gốc đến frontend đăng nhập.

`docker-compose.yml` tạo và kết nối các service. Các service dùng chung network `quanly_net`, nên PHP kết nối MySQL bằng hostname `db`, không dùng `localhost`:

```text
Host: db
Database: QuanLyNhaSach
Username: root
Password: rootpassword
```

File `database.sql` được MySQL chạy tự động khi volume database được tạo lần đầu. Nếu volume `db_data` đã tồn tại, thay đổi trong `database.sql` sẽ không tự chạy lại.

Thư mục `api` và `frontend` được mount trực tiếp vào container, nên chỉnh sửa mã nguồn sẽ được cập nhật ngay mà thường không cần build lại image.

### Khởi tạo lại database từ đầu

Cảnh báo: lệnh sau xóa toàn bộ dữ liệu hiện có trong volume MySQL:

```powershell
docker compose down -v
docker compose up -d --build
```

Chỉ dùng lệnh này khi muốn tạo lại database từ file `database.sql`.