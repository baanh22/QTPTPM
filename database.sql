-- SQL Script to create the QuanLyNhaSach Database
-- Target Database: MySQL / MariaDB (XAMPP)

CREATE DATABASE IF NOT EXISTS QuanLyNhaSach DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE QuanLyNhaSach;

-- Drop tables in reverse dependency order to avoid foreign key check issues
DROP TABLE IF EXISTS CHITIETPHIEUHOADON;
DROP TABLE IF EXISTS CHITIETPHIEUNHAP;
DROP TABLE IF EXISTS PHIEUTHUTIEN;
DROP TABLE IF EXISTS PHIEUHOADON;
DROP TABLE IF EXISTS PHIEUNHAP;
DROP TABLE IF EXISTS SACH;
DROP TABLE IF EXISTS KHACHHANG;
DROP TABLE IF EXISTS TAIKHOAN;
DROP TABLE IF EXISTS THAMSO;

-- 1. Table TAIKHOAN (Accounts)
CREATE TABLE IF NOT EXISTS TAIKHOAN (
                                        Username VARCHAR(50) NOT NULL,
    Password VARCHAR(32) NOT NULL,
    FullName VARCHAR(100) NOT NULL,
    Role VARCHAR(20) NOT NULL DEFAULT 'User',
    PRIMARY KEY (Username)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Table THAMSO (Rules / Parameters)
CREATE TABLE IF NOT EXISTS THAMSO (
                                      SoLuongNhapItNhat INT NOT NULL DEFAULT 150,
                                      SoLuongTonToiDaTruocNhap INT NOT NULL DEFAULT 300,
                                      SoTienNoToiDa DECIMAL(15, 2) NOT NULL DEFAULT 20000.00,
    SoLuongTonSauToiThieu INT NOT NULL DEFAULT 20,
    DonGiaBanYeuCau DECIMAL(5, 2) NOT NULL DEFAULT 1.05,
    QuyDinh INT NOT NULL DEFAULT 1
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Table SACH (Books)
CREATE TABLE IF NOT EXISTS SACH (
                                    MaSach VARCHAR(50) NOT NULL,
    TenSach VARCHAR(255) NOT NULL,
    TheLoai VARCHAR(100) DEFAULT NULL,
    TacGia VARCHAR(100) DEFAULT NULL,
    SoLuongTon INT NOT NULL DEFAULT 0,
    DonGia DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (MaSach)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. Table KHACHHANG (Customers)
CREATE TABLE IF NOT EXISTS KHACHHANG (
                                         MaKhachHang VARCHAR(50) NOT NULL,
    HoTenKhachHang VARCHAR(255) NOT NULL,
    DiaChi VARCHAR(255) DEFAULT NULL,
    DienThoai VARCHAR(20) DEFAULT NULL,
    Email VARCHAR(100) DEFAULT NULL,
    SoTienNo DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (MaKhachHang)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. Table PHIEUHOADON (Invoices)
CREATE TABLE IF NOT EXISTS PHIEUHOADON (
                                           MaPhieuHoaDon INT AUTO_INCREMENT,
                                           NgayLapHoaDon DATETIME NOT NULL,
                                           MaKhachHang VARCHAR(50) NOT NULL,
    PRIMARY KEY (MaPhieuHoaDon),
    FOREIGN KEY (MaKhachHang) REFERENCES KHACHHANG (MaKhachHang) ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. Table CHITIETPHIEUHOADON (Invoice Details)
CREATE TABLE IF NOT EXISTS CHITIETPHIEUHOADON (
                                                  MaPhieuHoaDon INT NOT NULL,
                                                  MaSach VARCHAR(50) NOT NULL,
    PRIMARY KEY (MaPhieuHoaDon, MaSach),
    SoLuongBan INT NOT NULL,
    FOREIGN KEY (MaPhieuHoaDon) REFERENCES PHIEUHOADON (MaPhieuHoaDon) ON DELETE CASCADE,
    FOREIGN KEY (MaSach) REFERENCES SACH (MaSach) ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 7. Table PHIEUNHAP (Imports)
CREATE TABLE IF NOT EXISTS PHIEUNHAP (
                                         MaPhieuNhap INT AUTO_INCREMENT,
                                         NgayNhap DATETIME NOT NULL,
                                         PRIMARY KEY (MaPhieuNhap)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 8. Table CHITIETPHIEUNHAP (Import Details)
CREATE TABLE IF NOT EXISTS CHITIETPHIEUNHAP (
                                                MaPhieuNhap INT NOT NULL,
                                                MaSach VARCHAR(50) NOT NULL,
    SoLuongNhap INT NOT NULL,
    DonGiaNhap DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (MaPhieuNhap, MaSach),
    FOREIGN KEY (MaPhieuNhap) REFERENCES PHIEUNHAP (MaPhieuNhap) ON DELETE CASCADE,
    FOREIGN KEY (MaSach) REFERENCES SACH (MaSach) ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 9. Table PHIEUTHUTIEN (Debt Receipts)
CREATE TABLE IF NOT EXISTS PHIEUTHUTIEN (
                                            MaPhieuThu INT AUTO_INCREMENT,
                                            MaKhachHang VARCHAR(50) NOT NULL,
    NgayThuTien DATETIME NOT NULL,
    SoTienThu DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (MaPhieuThu),
    FOREIGN KEY (MaKhachHang) REFERENCES KHACHHANG (MaKhachHang) ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ==========================================
-- SEED INITIAL DATA
-- ==========================================

-- Seed TAIKHOAN:
-- 1. admin / admin -> MD5: 21232f297a57a5a743894a0e4a801fc3
-- 2. nhanvien / nhanvien -> MD5: 22e96d99723ec428543f07a72d3f25c7
INSERT INTO TAIKHOAN (Username, Password, FullName, Role) VALUES
                                                              ('admin', '21232f297a57a5a743894a0e4a801fc3', 'Quản trị viên', 'Admin'),
                                                              ('nhanvien', '22e96d99723ec428543f07a72d3f25c7', 'Nhân viên bán hàng', 'User');

-- Seed THAMSO:
-- Default rules: Nhập ít nhất 150, Tồn tối đa trước nhập 300, Nợ tối đa 20.000, Tồn tối thiểu sau bán 20, Hệ số bán 1.05, Có áp dụng quy định thu ko vượt nợ (=1)
INSERT INTO THAMSO (SoLuongNhapItNhat, SoLuongTonToiDaTruocNhap, SoTienNoToiDa, SoLuongTonSauToiThieu, DonGiaBanYeuCau, QuyDinh) VALUES
    (150, 300, 20000.00, 20, 1.05, 1);

-- Seed SACH:
INSERT INTO SACH (MaSach, TenSach, TheLoai, TacGia, SoLuongTon, DonGia) VALUES
                                                                            ('S001', 'Đắc Nhân Tâm', 'Kỹ năng sống', 'Dale Carnegie', 120, 50000.00),
                                                                            ('S002', 'Nhà Giả Kim', 'Tiểu thuyết', 'Paulo Coelho', 80, 60000.00),
                                                                            ('S003', 'Cha Giàu Cha Nghèo', 'Tài chính', 'Robert Kiyosaki', 150, 75000.00),
                                                                            ('S004', 'Lược Sử Thời Gian', 'Khoa học', 'Stephen Hawking', 95, 90000.00);

-- Seed KHACHHANG:
INSERT INTO KHACHHANG (MaKhachHang, HoTenKhachHang, DiaChi, DienThoai, Email, SoTienNo) VALUES
                                                                                            ('KH001', 'Nguyễn Văn Nam', 'Quận 1, TP.HCM', '0901234567', 'namnv@gmail.com', 0.00),
                                                                                            ('KH002', 'Trần Thị Hồng', 'Quận 3, TP.HCM', '0918765432', 'hongtt@gmail.com', 5000.00),
                                                                                            ('KH003', 'Phạm Minh Hải', 'Quận Bình Thạnh, TP.HCM', '0987654321', 'haipm@gmail.com', 15000.00);

-- Seed transactions (Optional, to populate charts/history)
-- 1. Phiếu nhập
INSERT INTO PHIEUNHAP (MaPhieuNhap, NgayNhap) VALUES (1, '2026-06-01 10:00:00');
INSERT INTO CHITIETPHIEUNHAP (MaPhieuNhap, MaSach, SoLuongNhap, DonGiaNhap) VALUES (1, 'S001', 150, 50000.00);

-- 2. Hóa đơn bán hàng
INSERT INTO PHIEUHOADON (MaPhieuHoaDon, NgayLapHoaDon, MaKhachHang) VALUES
                                                                        (1, '2026-06-10 14:30:00', 'KH002'),
                                                                        (2, '2026-06-12 16:00:00', 'KH003');

INSERT INTO CHITIETPHIEUHOADON (MaPhieuHoaDon, MaSach, SoLuongBan) VALUES
                                                                       (1, 'S001', 10),
                                                                       (2, 'S002', 5);

-- 3. Phiếu thu tiền
INSERT INTO PHIEUTHUTIEN (MaPhieuThu, MaKhachHang, NgayThuTien, SoTienThu) VALUES
                                                                               (1, 'KH002', '2026-06-15 09:00:00', 520000.00),
                                                                               (2, 'KH003', '2026-06-16 11:30:00', 300000.00);
-- SQL Script to create the QuanLyNhaSach Database
-- Target Database: MySQL / MariaDB (XAMPP)

CREATE DATABASE IF NOT EXISTS QuanLyNhaSach DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE QuanLyNhaSach;

-- Drop tables in reverse dependency order to avoid foreign key check issues
DROP TABLE IF EXISTS CHITIETPHIEUHOADON;
DROP TABLE IF EXISTS CHITIETPHIEUNHAP;
DROP TABLE IF EXISTS PHIEUTHUTIEN;
DROP TABLE IF EXISTS PHIEUHOADON;
DROP TABLE IF EXISTS PHIEUNHAP;
DROP TABLE IF EXISTS SACH;
DROP TABLE IF EXISTS KHACHHANG;
DROP TABLE IF EXISTS TAIKHOAN;
DROP TABLE IF EXISTS THAMSO;

-- 1. Table TAIKHOAN (Accounts)
CREATE TABLE IF NOT EXISTS TAIKHOAN (
                                        Username VARCHAR(50) NOT NULL,
    Password VARCHAR(32) NOT NULL,
    FullName VARCHAR(100) NOT NULL,
    Role VARCHAR(20) NOT NULL DEFAULT 'User',
    PRIMARY KEY (Username)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Table THAMSO (Rules / Parameters)
CREATE TABLE IF NOT EXISTS THAMSO (
                                      SoLuongNhapItNhat INT NOT NULL DEFAULT 150,
                                      SoLuongTonToiDaTruocNhap INT NOT NULL DEFAULT 300,
                                      SoTienNoToiDa DECIMAL(15, 2) NOT NULL DEFAULT 20000.00,
    SoLuongTonSauToiThieu INT NOT NULL DEFAULT 20,
    DonGiaBanYeuCau DECIMAL(5, 2) NOT NULL DEFAULT 1.05,
    QuyDinh INT NOT NULL DEFAULT 1
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Table SACH (Books)
CREATE TABLE IF NOT EXISTS SACH (
                                    MaSach VARCHAR(50) NOT NULL,
    TenSach VARCHAR(255) NOT NULL,
    TheLoai VARCHAR(100) DEFAULT NULL,
    TacGia VARCHAR(100) DEFAULT NULL,
    SoLuongTon INT NOT NULL DEFAULT 0,
    DonGia DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (MaSach)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. Table KHACHHANG (Customers)
CREATE TABLE IF NOT EXISTS KHACHHANG (
                                         MaKhachHang VARCHAR(50) NOT NULL,
    HoTenKhachHang VARCHAR(255) NOT NULL,
    DiaChi VARCHAR(255) DEFAULT NULL,
    DienThoai VARCHAR(20) DEFAULT NULL,
    Email VARCHAR(100) DEFAULT NULL,
    SoTienNo DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (MaKhachHang)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. Table PHIEUHOADON (Invoices)
CREATE TABLE IF NOT EXISTS PHIEUHOADON (
                                           MaPhieuHoaDon INT AUTO_INCREMENT,
                                           NgayLapHoaDon DATETIME NOT NULL,
                                           MaKhachHang VARCHAR(50) NOT NULL,
    PRIMARY KEY (MaPhieuHoaDon),
    FOREIGN KEY (MaKhachHang) REFERENCES KHACHHANG (MaKhachHang) ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. Table CHITIETPHIEUHOADON (Invoice Details)
CREATE TABLE IF NOT EXISTS CHITIETPHIEUHOADON (
                                                  MaPhieuHoaDon INT NOT NULL,
                                                  MaSach VARCHAR(50) NOT NULL,
    PRIMARY KEY (MaPhieuHoaDon, MaSach),
    SoLuongBan INT NOT NULL,
    FOREIGN KEY (MaPhieuHoaDon) REFERENCES PHIEUHOADON (MaPhieuHoaDon) ON DELETE CASCADE,
    FOREIGN KEY (MaSach) REFERENCES SACH (MaSach) ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 7. Table PHIEUNHAP (Imports)
CREATE TABLE IF NOT EXISTS PHIEUNHAP (
                                         MaPhieuNhap INT AUTO_INCREMENT,
                                         NgayNhap DATETIME NOT NULL,
                                         PRIMARY KEY (MaPhieuNhap)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 8. Table CHITIETPHIEUNHAP (Import Details)
CREATE TABLE IF NOT EXISTS CHITIETPHIEUNHAP (
                                                MaPhieuNhap INT NOT NULL,
                                                MaSach VARCHAR(50) NOT NULL,
    SoLuongNhap INT NOT NULL,
    DonGiaNhap DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (MaPhieuNhap, MaSach),
    FOREIGN KEY (MaPhieuNhap) REFERENCES PHIEUNHAP (MaPhieuNhap) ON DELETE CASCADE,
    FOREIGN KEY (MaSach) REFERENCES SACH (MaSach) ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 9. Table PHIEUTHUTIEN (Debt Receipts)
CREATE TABLE IF NOT EXISTS PHIEUTHUTIEN (
                                            MaPhieuThu INT AUTO_INCREMENT,
                                            MaKhachHang VARCHAR(50) NOT NULL,
    NgayThuTien DATETIME NOT NULL,
    SoTienThu DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (MaPhieuThu),
    FOREIGN KEY (MaKhachHang) REFERENCES KHACHHANG (MaKhachHang) ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ==========================================
-- SEED INITIAL DATA
-- ==========================================

-- Seed TAIKHOAN:
-- 1. admin / admin -> MD5: 21232f297a57a5a743894a0e4a801fc3
-- 2. nhanvien / nhanvien -> MD5: 22e96d99723ec428543f07a72d3f25c7
INSERT INTO TAIKHOAN (Username, Password, FullName, Role) VALUES
                                                              ('admin', '21232f297a57a5a743894a0e4a801fc3', 'Quản trị viên', 'Admin'),
                                                              ('nhanvien', '22e96d99723ec428543f07a72d3f25c7', 'Nhân viên bán hàng', 'User');

-- Seed THAMSO:
-- Default rules: Nhập ít nhất 150, Tồn tối đa trước nhập 300, Nợ tối đa 20.000, Tồn tối thiểu sau bán 20, Hệ số bán 1.05, Có áp dụng quy định thu ko vượt nợ (=1)
INSERT INTO THAMSO (SoLuongNhapItNhat, SoLuongTonToiDaTruocNhap, SoTienNoToiDa, SoLuongTonSauToiThieu, DonGiaBanYeuCau, QuyDinh) VALUES
    (150, 300, 20000.00, 20, 1.05, 1);

-- Seed SACH:
INSERT INTO SACH (MaSach, TenSach, TheLoai, TacGia, SoLuongTon, DonGia) VALUES
                                                                            ('S001', 'Đắc Nhân Tâm', 'Kỹ năng sống', 'Dale Carnegie', 120, 50000.00),
                                                                            ('S002', 'Nhà Giả Kim', 'Tiểu thuyết', 'Paulo Coelho', 80, 60000.00),
                                                                            ('S003', 'Cha Giàu Cha Nghèo', 'Tài chính', 'Robert Kiyosaki', 150, 75000.00),
                                                                            ('S004', 'Lược Sử Thời Gian', 'Khoa học', 'Stephen Hawking', 95, 90000.00);

-- Seed KHACHHANG:
INSERT INTO KHACHHANG (MaKhachHang, HoTenKhachHang, DiaChi, DienThoai, Email, SoTienNo) VALUES
                                                                                            ('KH001', 'Nguyễn Văn Nam', 'Quận 1, TP.HCM', '0901234567', 'namnv@gmail.com', 0.00),
                                                                                            ('KH002', 'Trần Thị Hồng', 'Quận 3, TP.HCM', '0918765432', 'hongtt@gmail.com', 5000.00),
                                                                                            ('KH003', 'Phạm Minh Hải', 'Quận Bình Thạnh, TP.HCM', '0987654321', 'haipm@gmail.com', 15000.00);

-- Seed transactions (Optional, to populate charts/history)
-- 1. Phiếu nhập
INSERT INTO PHIEUNHAP (MaPhieuNhap, NgayNhap) VALUES (1, '2026-06-01 10:00:00');
INSERT INTO CHITIETPHIEUNHAP (MaPhieuNhap, MaSach, SoLuongNhap, DonGiaNhap) VALUES (1, 'S001', 150, 50000.00);

-- 2. Hóa đơn bán hàng
INSERT INTO PHIEUHOADON (MaPhieuHoaDon, NgayLapHoaDon, MaKhachHang) VALUES
                                                                        (1, '2026-06-10 14:30:00', 'KH002'),
                                                                        (2, '2026-06-12 16:00:00', 'KH003');

INSERT INTO CHITIETPHIEUHOADON (MaPhieuHoaDon, MaSach, SoLuongBan) VALUES
                                                                       (1, 'S001', 10),
                                                                       (2, 'S002', 5);

-- 3. Phiếu thu tiền
INSERT INTO PHIEUTHUTIEN (MaPhieuThu, MaKhachHang, NgayThuTien, SoTienThu) VALUES
                                                                               (1, 'KH002', '2026-06-15 09:00:00', 520000.00),
                                                                               (2, 'KH003', '2026-06-16 11:30:00', 300000.00);