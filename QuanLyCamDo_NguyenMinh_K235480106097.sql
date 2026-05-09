-- ==========================================================
-- Sinh viên: Nguyễn Minh (MSSV: K235480106097)
-- Giảng viên hướng dẫn: Đỗ Duy Cốp
-- ==========================================================

USE master;
GO
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'QuanLyCamDo')
    DROP DATABASE QuanLyCamDo;
GO
CREATE DATABASE QuanLyCamDo;
GO
USE QuanLyCamDo;
GO

-- 1. TẠO CẤU TRÚC BẢNG (Audit Log & Business Tables)
CREATE TABLE KhachHang (
    MaKH INT PRIMARY KEY IDENTITY(1,1),
    HoTen NVARCHAR(100) NOT NULL,
    SoDienThoai VARCHAR(15),
    CCCD VARCHAR(12) UNIQUE
);

CREATE TABLE NhanVien (
    MaNV INT PRIMARY KEY IDENTITY(1,1),
    HoTen NVARCHAR(100) NOT NULL,
    ChucVu NVARCHAR(50)
);

CREATE TABLE HopDong (
    MaHD INT PRIMARY KEY IDENTITY(1,1),
    MaKH INT FOREIGN KEY REFERENCES KhachHang(MaKH),
    NgayVay DATETIME DEFAULT GETDATE(),
    SoTienGoc DECIMAL(18,2),
    Deadline1 DATE, -- Mốc tính lãi kép
    Deadline2 DATE, -- Mốc thanh lý tài sản
    TrangThai NVARCHAR(50) DEFAULT N'Đang vay'
);

CREATE TABLE TaiSan (
    MaTS INT PRIMARY KEY IDENTITY(1,1),
    MaHD INT FOREIGN KEY REFERENCES HopDong(MaHD),
    TenTaiSan NVARCHAR(100),
    GiaTriDinhGia DECIMAL(18,2),
    TrangThaiTS NVARCHAR(50) DEFAULT N'Đang cầm cố'
);

CREATE TABLE LogBienDong (
    MaLog INT PRIMARY KEY IDENTITY(1,1),
    MaHD INT FOREIGN KEY REFERENCES HopDong(MaHD),
    MaNV INT FOREIGN KEY REFERENCES NhanVien(MaNV),
    NgayGiaoDich DATETIME DEFAULT GETDATE(),
    SoTienTra DECIMAL(18,2),
    NoiDung NVARCHAR(MAX)
);
GO

-- 2. HÀM TÍNH TOÁN CÔNG NỢ (Hỗ trợ lãi kép POWER)
CREATE FUNCTION fn_CalcMoneyContract (@MaHD INT, @TargetDate DATETIME)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @Goc DECIMAL(18,2), @NgayVay DATETIME, @DL1 DATE;
    DECLARE @TongNo DECIMAL(18,2);
    DECLARE @r FLOAT = 0.005; -- Lãi suất 0.5%/ngày

    SELECT @Goc = SoTienGoc, @NgayVay = NgayVay, @DL1 = Deadline1 
    FROM HopDong WHERE MaHD = @MaHD;

    IF @TargetDate <= @DL1
    BEGIN
        DECLARE @t1 INT = DATEDIFF(DAY, @NgayVay, @TargetDate);
        SET @TongNo = @Goc * (1 + @r * (CASE WHEN @t1 < 0 THEN 0 ELSE @t1 END));
    END
    ELSE
    BEGIN
        DECLARE @t_don INT = DATEDIFF(DAY, @NgayVay, @DL1);
        DECLARE @P_at_DL1 DECIMAL(18,2) = @Goc * (1 + @r * @t_don);
        DECLARE @n INT = DATEDIFF(DAY, @DL1, @TargetDate);
        SET @TongNo = @P_at_DL1 * CAST(POWER(1 + @r, @n) AS DECIMAL(18,2));
    END
    RETURN @TongNo;
END;
GO

-- 3. STORED PROCEDURES (Quản lý nghiệp vụ)
CREATE PROCEDURE sp_DangKyHopDong
    @HoTen NVARCHAR(100), @SDT VARCHAR(15), @CCCD VARCHAR(12),
    @SoTienVay DECIMAL(18,2), @DL1 DATE, @DL2 DATE,
    @TenTS NVARCHAR(100), @DinhGia DECIMAL(18,2)
AS
BEGIN
    DECLARE @MaKH INT;
    SELECT @MaKH = MaKH FROM KhachHang WHERE CCCD = @CCCD;
    IF @MaKH IS NULL
    BEGIN
        INSERT INTO KhachHang (HoTen, SoDienThoai, CCCD) VALUES (@HoTen, @SDT, @CCCD);
        SET @MaKH = SCOPE_IDENTITY();
    END
    INSERT INTO HopDong (MaKH, SoTienGoc, Deadline1, Deadline2) VALUES (@MaKH, @SoTienVay, @DL1, @DL2);
    INSERT INTO TaiSan (MaHD, TenTaiSan, GiaTriDinhGia) VALUES (SCOPE_IDENTITY(), @TenTS, @DinhGia);
END;
GO

CREATE PROCEDURE sp_XuLyTraNo
    @MaHD INT, @MaNV INT, @SoTienTra DECIMAL(18,2)
AS
BEGIN
    DECLARE @TongNo DECIMAL(18,2) = dbo.fn_CalcMoneyContract(@MaHD, GETDATE());
    INSERT INTO LogBienDong (MaHD, MaNV, SoTienTra, NoiDung) 
    VALUES (@MaHD, @MaNV, @SoTienTra, N'Khách trả tiền. Tổng nợ lúc trả: ' + CAST(@TongNo AS NVARCHAR(20)));
    
    IF @SoTienTra >= @TongNo UPDATE HopDong SET TrangThai = N'Đã thanh toán đủ' WHERE MaHD = @MaHD;
    ELSE UPDATE HopDong SET TrangThai = N'Đang trả góp' WHERE MaHD = @MaHD;
END;
GO

-- 4. DỮ LIỆU MẪU (SAMPLE DATA)
INSERT INTO NhanVien (HoTen, ChucVu) VALUES (N'Lê Thu Ngân', N'Kế toán');

-- Tạo dữ liệu cho Nguyễn Văn A (Quá hạn để test nợ xấu)
EXEC sp_DangKyHopDong 
    N'Nguyễn Văn A', '0912345678', '123456789', 
    10000000, '2026-04-01', '2026-05-01', 
    N'Xe máy Honda Vision', 35000000;

-- Tạo dữ liệu cho Nguyễn Minh
EXEC sp_DangKyHopDong 
    N'Nguyễn Minh', '0988888888', 'K235480106097', 
    5000000, '2026-06-01', '2026-07-01', 
    N'Laptop Asus', 15000000;

-- Giả lập giao dịch để tạo Log (Audit Log)
EXEC sp_XuLyTraNo @MaHD = 1, @MaNV = 1, @SoTienTra = 2000000;
GO

-- 5. TRUY VẤN KIỂM TRA (Audit Log & Nợ Xấu)
SELECT * FROM KhachHang;
SELECT h.*, dbo.fn_CalcMoneyContract(h.MaHD, GETDATE()) AS NoHienTai FROM HopDong h;
SELECT * FROM LogBienDong;
