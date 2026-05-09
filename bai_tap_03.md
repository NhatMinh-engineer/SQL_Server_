* Tên : Nguyễn Hữu Nhật Minh

* Mssv : K235480106097

* Lớp : K59KMT.K01


* Sau đây là phần bài làm của em


# Phần 1 : Thiết kế CSDL
```

-- 1. Tạo Database mới
CREATE DATABASE QuanLyCamDo;
GO
USE QuanLyCamDo;
GO

-- 2. Bảng Khách hàng (KhachHang)
CREATE TABLE KhachHang (
    MaKH INT PRIMARY KEY IDENTITY(1,1), -- Khóa chính tự tăng
    HoTen NVARCHAR(100) NOT NULL,
    SoDienThoai VARCHAR(15),
    CCCD VARCHAR(12) UNIQUE,
    DiaChi NVARCHAR(255)
);

-- 3. Bảng Nhân viên (NhanVien) - Để ghi nhận người thu tiền trong Log
CREATE TABLE NhanVien (
    MaNV INT PRIMARY KEY IDENTITY(1,1),
    HoTen NVARCHAR(100) NOT NULL,
    ChucVu NVARCHAR(50)
);

-- 4. Bảng Hợp đồng (HopDong)
CREATE TABLE HopDong (
    MaHD INT PRIMARY KEY IDENTITY(1,1),
    MaKH INT NOT NULL, -- Khóa ngoại nối tới KhachHang
    NgayVay DATETIME DEFAULT GETDATE(),
    SoTienGoc DECIMAL(18,2) NOT NULL,
    Deadline1 DATE NOT NULL, -- Mốc tính lãi kép
    Deadline2 DATE NOT NULL, -- Mốc thanh lý tài sản
    TrangThai NVARCHAR(50) DEFAULT N'Đang vay',
    CONSTRAINT FK_HopDong_KhachHang FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);

-- 5. Bảng Tài sản (TaiSan)
CREATE TABLE TaiSan (
    MaTS INT PRIMARY KEY IDENTITY(1,1),
    MaHD INT NOT NULL, -- Khóa ngoại nối tới HopDong
    TenTaiSan NVARCHAR(100) NOT NULL,
    GiaTriDinhGia DECIMAL(18,2),
    TrangThaiTS NVARCHAR(50) DEFAULT N'Đang cầm cố',
    CONSTRAINT FK_TaiSan_HopDong FOREIGN KEY (MaHD) REFERENCES HopDong(MaHD)
);

-- 6. Bảng Nhật ký (LogBienDong)
CREATE TABLE LogBienDong (
    MaLog INT PRIMARY KEY IDENTITY(1,1),
    MaHD INT NOT NULL, -- Khóa ngoại nối tới HopDong
    MaNV INT NOT NULL, -- Khóa ngoại nối tới NhanVien
    NgayGiaoDich DATETIME DEFAULT GETDATE(),
    SoTienTra DECIMAL(18,2),
    NoiDung NVARCHAR(255),
    CONSTRAINT FK_Log_HopDong FOREIGN KEY (MaHD) REFERENCES HopDong(MaHD),
    CONSTRAINT FK_Log_NhanVien FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);
```

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/9e5ee8c6-977d-43f0-a69b-e880467bfdc9" />
<img width="1919" height="1078" alt="image" src="https://github.com/user-attachments/assets/e99ced70-dc4a-4c01-92c8-05f48d4c9bd0" />

*Để thực hiện Nhiệm vụ 1, em đã khởi tạo cơ sở dữ liệu QuanLyCamDo và thiết lập 5 bảng dữ liệu chuẩn hóa 3NF gồm: Khách hàng, Nhân viên, Hợp đồng, Tài sản và Log biến động. Các bảng được kết nối chặt chẽ bằng khóa ngoại để quản lý chi tiết từ thông tin người vay đến lịch sử dòng tiền và trạng thái tài sản thế chấp theo đúng yêu cầu nghiệp vụ.*

 * Tiếp theo em sẽ tạo 1 Database Diagrams
   
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/bcbf9470-8596-469d-9c3a-edeaf617c087" />

*Dựa trên cấu trúc bảng đã cài đặt, em đã tiến hành thiết lập các mối quan hệ (Relationships) trực quan thông qua công cụ Database Diagram để hiện thực hóa quy trình nghiệp vụ. Trong đó, bảng HopDong đóng vai trò trung tâm, được kết nối với bảng KhachHang để xác định chủ khoản vay và bảng TaiSan để quản lý danh mục đồ cầm cố của từng hợp đồng. Đồng thời, các bảng NhanVien và LogBienDong cũng được liên kết chặt chẽ nhằm đảm bảo mọi biến động về dòng tiền và người thực hiện giao dịch đều được lưu vết đầy đủ, phục vụ cho việc kiểm soát nợ thời gian thực.*



# Phần 2 : Cài đặt SQL (Yêu cầu viết Scripts)

 * Event 1 : Đăng ký hợp đồng mới (Vay tiền)

```
CREATE PROCEDURE sp_DangKyHopDong
    @HoTen NVARCHAR(100), @SDT VARCHAR(15), @CCCD VARCHAR(12),
    @SoTienVay DECIMAL(18,2), @DL1 DATE, @DL2 DATE,
    @TenTS NVARCHAR(100), @DinhGia DECIMAL(18,2)
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE @MaKH INT;
        SELECT @MaKH = MaKH FROM KhachHang WHERE CCCD = @CCCD;
        IF @MaKH IS NULL
        BEGIN
            INSERT INTO KhachHang (HoTen, SoDienThoai, CCCD) VALUES (@HoTen, @SDT, @CCCD);
            SET @MaKH = SCOPE_IDENTITY();
        END

        INSERT INTO HopDong (MaKH, SoTienGoc, Deadline1, Deadline2, TrangThai)
        VALUES (@MaKH, @SoTienVay, @DL1, @DL2, N'Đang vay');
        DECLARE @MaHD INT = SCOPE_IDENTITY();

        INSERT INTO TaiSan (MaHD, TenTaiSan, GiaTriDinhGia, TrangThaiTS)
        VALUES (@MaHD, @TenTS, @DinhGia, N'Đang cầm cố');

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END;
```
   <img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/5217c123-47b8-4b28-bf41-f32e796e60c2" />

*Em đã xây dựng Store Procedure tiếp nhận hợp đồng để tự động hóa việc lưu trữ thông tin khách hàng, khởi tạo khoản vay với hai mốc Deadline và đồng bộ danh sách tài sản thế chấp vào hệ thống.*

* Event 2 : Tính toán công nợ thời gian thực

```
CREATE FUNCTION fn_CalcMoneyContract (@MaHD INT, @TargetDate DATETIME)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @Goc DECIMAL(18,2), @NgayVay DATETIME, @DL1 DATE;
    DECLARE @TongNo DECIMAL(18,2);
    DECLARE @r FLOAT = 0.005; 

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
```

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/ee44793a-e48a-424a-a647-11d2902fd481" />

*Em đã cài đặt Function tính toán công nợ sử dụng hàm lũy thừa POWER để xử lý chính xác cơ chế chuyển đổi từ lãi đơn sang lãi kép ngay khi hợp đồng vượt quá mốc*

* Event 3: Xử lý trả nợ và hoàn trả tài sản
```
CREATE PROCEDURE sp_XuLyTraNo
    @MaHD INT, @MaNV INT, @SoTienTra DECIMAL(18,2)
AS
BEGIN
    DECLARE @TongNo DECIMAL(18,2) = dbo.fn_CalcMoneyContract(@MaHD, GETDATE());
    IF EXISTS (SELECT 1 FROM HopDong WHERE MaHD = @MaHD AND TrangThai = N'Đã thanh lý')
    BEGIN
        PRINT N'Tài sản đã bán thanh lý, không thu tiền.';
        RETURN;
    END

    INSERT INTO LogBienDong (MaHD, MaNV, SoTienTra, NgayGiaoDich, NoiDung)
    VALUES (@MaHD, @MaNV, @SoTienTra, GETDATE(), N'Khách trả nợ');

    IF @SoTienTra >= @TongNo
        UPDATE HopDong SET TrangThai = N'Đã thanh toán đủ' WHERE MaHD = @MaHD;
    ELSE
        UPDATE HopDong SET TrangThai = N'Đang trả góp' WHERE MaHD = @MaHD;

    SELECT MaTS, TenTaiSan FROM TaiSan 
    WHERE MaHD = @MaHD AND GiaTriDinhGia >= (@TongNo - @SoTienTra);
END;
```

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/ca8069bc-e9c9-4c2d-83f8-20981c7a4021" />

*Store Procedure này cho phép xử lý trả nợ từng phần, cập nhật trạng thái hợp đồng và tự động gợi ý danh sách tài sản có thể hoàn trả dựa trên điều kiện giá trị tài sản còn lại bao phủ được dư nợ.*

* Event 4 : Truy vấn danh sách nợ xấu (Nợ khó đòi)

```
SELECT k.HoTen, k.SoDienThoai, h.SoTienGoc, 
       DATEDIFF(DAY, h.Deadline1, GETDATE()) AS SoNgayQuaHan,
       dbo.fn_CalcMoneyContract(h.MaHD, GETDATE()) AS TongNoHienTai,
       dbo.fn_CalcMoneyContract(h.MaHD, DATEADD(MONTH, 1, GETDATE())) AS NoDuKienSau1Thang
FROM HopDong h JOIN KhachHang k ON h.MaKH = k.MaKH
WHERE GETDATE() > h.Deadline1 AND h.TrangThai <> N'Đã thanh toán đủ';
```

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/dd8ea5ae-9413-40c7-bf74-7ccf9f406a5e" />

*Bảng này em đã thiết lập câu lệnh truy vấn nợ xấu nhằm chiết xuất danh sách khách hàng quá hạn, kèm theo dự báo số tiền phải trả sau một tháng để phục vụ công tác quản trị rủi ro , tuy nhiên em chưa nạp dữ liệu nên phần này còn trống*

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/a8f9bbb9-3164-4b9a-b4c9-7bad46c979ac" />

*Để kiểm chứng tính chính xác của thuật toán lãi kép, em đã tiến hành nạp dữ liệu mẫu cho hai trường hợp đối lập: một khách hàng đang trong hạn vay và một khách hàng đã quá mốc Deadline1 hơn một tháng. Kết quả thực thi cho thấy hệ thống đã tự động lọc chính xác danh sách nợ khó đòi và áp dụng đúng công thức lũy thừa để tính toán dư nợ hiện tại cũng như dự báo công nợ tương lai, đảm bảo tính minh bạch trong quản lý dòng tiền*

* Event 5 : Quản lý thanh lý tài sản (Trigger)

```
CREATE TRIGGER trg_AutoStatus ON HopDong AFTER UPDATE AS
BEGIN
    UPDATE HopDong SET TrangThai = N'Quá hạn (nợ xấu)' 
    FROM HopDong h JOIN inserted i ON h.MaHD = i.MaHD 
    WHERE h.TrangThai = N'Đang vay' AND GETDATE() > h.Deadline1;

    UPDATE TaiSan SET TrangThaiTS = N'Sẵn sàng thanh lý' 
    FROM TaiSan t JOIN HopDong h ON t.MaHD = h.MaHD 
    WHERE h.TrangThai = N'Quá hạn (nợ xấu)' AND GETDATE() > h.Deadline2;
END;
```

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/2f11e5ba-9609-4636-92ca-ba571c84aa99" />

*Cuối cùng, em sử dụng các Trigger tự động để kiểm soát vòng đời hợp đồng, từ việc chuyển trạng thái nợ xấu đến việc đánh dấu tài sản sẵn sàng thanh lý khi khách hàng vi phạm các mốc Deadline.* 

# Phần 4 : Các sự kiện bổ sung

* Sự kiện Gia hạn hợp đồng: Khách đến trả toàn bộ tiền lãi tính đến thời điểm hiện tại để dời Deadline 1 và Deadline 2 sang một kỳ hạn mới để tránh bị tính lãi kép

```
CREATE PROCEDURE sp_GiaHanHopDong
    @MaHD INT,
    @MaNV INT,
    @SoThangGiaHan INT
AS
BEGIN
    DECLARE @TongNo DECIMAL(18,2) = dbo.fn_CalcMoneyContract(@MaHD, GETDATE());
    DECLARE @Goc DECIMAL(18,2);
    SELECT @Goc = SoTienGoc FROM HopDong WHERE MaHD = @MaHD;

    DECLARE @LaiHienTai DECIMAL(18,2) = @TongNo - @Goc;

    -- Khách phải trả đủ phần lãi mới được gia hạn
    INSERT INTO LogBienDong (MaHD, MaNV, SoTienTra, NoiDung)
    VALUES (@MaHD, @MaNV, @LaiHienTai, N'Khách trả lãi để gia hạn thêm ' + CAST(@SoThangGiaHan AS NVARCHAR(5)) + N' tháng');

    -- Cập nhật Deadline mới
    UPDATE HopDong
    SET Deadline1 = DATEADD(MONTH, @SoThangGiaHan, Deadline1),
        Deadline2 = DATEADD(MONTH, @SoThangGiaHan, Deadline2),
        TrangThai = N'Đang vay' -- Đưa về trạng thái bình thường nếu đang nợ xấu
    WHERE MaHD = @MaHD;
END;
```

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/79de464f-11a8-4d95-b30d-90953c7d07a1" />

*Em đã thiết lập cơ chế gia hạn hợp đồng, cho phép khách hàng thanh toán toàn bộ lãi tích lũy để dời mốc Deadline, giúp đưa hợp đồng trở về trạng thái an toàn và tránh gánh nặng lãi kép.*











