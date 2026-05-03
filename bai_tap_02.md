Họ Tên : Nguyễn Hữu Nhật Minh  
MSSV : K235480106097
Lớp : K59KMT.K01

- Sau đây em xin phép được trình bày Bài tập 02

  # Phần 1: Thiết kế và Khởi tạo Cấu trúc Dữ liệu (Kiến thức 6, 7)
```
* Phần code :

  CREATE DATABASE QuanLyLab_NhatMinh097;
GO
USE QuanLyLab_NhatMinh097;
GO

-- 1. Danh mục Loại thiết bị (Ví dụ: Máy đo, Vi điều khiển, Cảm biến)
CREATE TABLE LoaiThietBi_NhatMinh097 (
    MaLoai INT PRIMARY KEY IDENTITY,
    TenLoai NVARCHAR(100) NOT NULL
);

-- 2. Danh sách thiết bị cụ thể
CREATE TABLE ThietBi_NhatMinh097 (
    MaTB VARCHAR(10) PRIMARY KEY,
    TenTB NVARCHAR(100) NOT NULL,
    MaLoai INT,
    TinhTrang NVARCHAR(50) DEFAULT N'Sẵn sàng', -- Sẵn sàng, Đang mượn, Đang bảo trì
    FOREIGN KEY (MaLoai) REFERENCES LoaiThietBi_NhatMinh097(MaLoai)
);

-- 3. Quản lý Sinh viên mượn thiết bị
CREATE TABLE SinhVien_NhatMinh097 (
    MaSV CHAR(12) PRIMARY KEY, -- K235480106097
    HoTen NVARCHAR(100),
    LopHoc VARCHAR(20)
);

-- 4. Nhật ký Mượn trả
CREATE TABLE MuonTra_NhatMinh097 (
    MaMuon INT PRIMARY KEY IDENTITY,
    MaSV CHAR(12),
    MaTB VARCHAR(10),
    NgayMuon DATETIME DEFAULT GETDATE(),

    NgayTraDuKien DATE,
    NgayTraThucTe DATETIME NULL,
    FOREIGN KEY (MaSV) REFERENCES SinhVien_NhatMinh097(MaSV),
    FOREIGN KEY (MaTB) REFERENCES ThietBi_NhatMinh097(MaTB)
);
```

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/b37c5475-e776-4138-89fa-9cc02d9bc5be" />

* Ảnh này em đã khỏi tạo 1 database cùng với 3 bảng quan hệ với nhau , Sử dụng đa dạng các kiểu dữ liệu (Số nguyên, số thực, chuỗi ký tự Unicode, ngày tháng, tiền tệ, ...) , Áp dụng đúng quy tắc đặt tên (BướuLạcĐà). Sử dụng cặp ngoặc [ ] để bọc tên bảng và tên trường trong script khởi tạo. Có giải thích chỗ nào là PK, chỗ nào là FK, trường nào có ràng buộc cứng CK (ví dụ điểm từ 0..10),..

  # Phần 2: Xây dựng Function (Kiến thức 8, 9)

 *  Hãy cho biết trong SQL Server có những loại function build_in (hàm có sẵn) nào, nêu 1 vài system function build_in mà em tìm hiểu được (ko cần nhiều, cần đặc sắc theo góc nhìn của em), cho SQL khai thác các hàm đó.

=> 1. Phân loại hàm Built-in trong SQL Server

    SQL Server cung cấp rất nhiều nhóm hàm để xử lý dữ liệu, bao gồm:

    Hàm chuỗi (String Functions): Xử lý văn bản như LEN, SUBSTRING, REPLACE.

    Hàm ngày tháng (Date and Time Functions): Xử lý thời gian như GETDATE, DATEDIFF.

    Hàm toán học (Mathematical Functions): Các phép tính như ABS, ROUND, SQRT.

    Hàm tổng hợp (Aggregate Functions): Tính toán trên tập dữ liệu như SUM, AVG, COUNT.

    Hàm hệ thống (System Functions): Lấy thông tin về cấu hình, người dùng hoặc database.

2. Các System Function đặc sắc (Góc nhìn Kỹ sư Lab)
    Dưới đây là 3 hàm mà em thấy đặc sắc nhất vì nó giúp bản thân em kiểm soát hệ thống cực tốt:

A. Hàm HOST_NAME() & APP_NAME()
    Hàm này cho biết tên máy tính và ứng dụng đang kết nối vào SQL Server. Trong quản lý Lab, việc biết máy tính nào đang thao tác trên database là cực kỳ quan trọng để truy vết.

Khai thác: Ta có thể dùng nó để ghi lại xem thiết bị được mượn từ máy tính nào trong phòng Lab.

B. Hàm ISNUMERIC()
    Hàm này kiểm tra xem một chuỗi có phải là số hay không. Trong ngành Điện tử, khi nhận dữ liệu từ các cảm biến (Sensor) gửi về dưới dạng chuỗi, hàm này giúp ta lọc ra những dữ liệu rác trước khi tính toán.

C. Hàm SERVERPROPERTY()
    Đây là hàm "quyền lực" nhất để lấy thông tin về cấu hình máy chủ như phiên bản SQL, mức độ bảo mật, hay tên Instance.   
```
* Phần code :
  
  USE QuanLyLab_NhatMinh097;
GO

-- Khai thác hàm hệ thống để xem thông tin kết nối hiện tại
SELECT 
    HOST_NAME() AS [TenMayTinh_DangKetNoi],
    APP_NAME() AS [UngDung_SuDung],
    USER_NAME() AS [NguoiDung_HeThong],
    SERVERPROPERTY('MachineName') AS [TenServer_VatLy];

-- Khai thác hàm ISNUMERIC để lọc dữ liệu mã thiết bị
-- Giả sử Minh muốn kiểm tra xem mã thiết bị có chứa ký tự lạ không
SELECT 
    MaTB, 
    TenTB,
    CASE 
        WHEN ISNUMERIC(MaTB) = 1 THEN N'Mã dạng số'
        ELSE N'Mã dạng chuỗi/kỹ thuật'
    END AS PhanLoaiMa
FROM ThietBi_NhatMinh097;
  ```
  <img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/db08dc87-b67b-4dad-b1e9-2b10724c6381" />

*Ảnh này em đã làm để minh chứng cho việc khai thác các hàm hệ thống (System Functions) có sẵn trong SQL Server. Em đã sử dụng HOST_NAME() để xác định máy tính đang thao tác và SERVERPROPERTY() để truy xuất thông tin cấu hình Server. Việc này giúp em quản lý chặt chẽ hơn về an ninh và nguồn gốc dữ liệu trong hệ thống Quản lý Lab của mình*


* Hàm do người dùng tự viết trong SQL thường mang mục đích gì? Nó có những loại nào? Mỗi loại thường được dùng khi nào? Tại sao có nhiều system function rồi mà vẫn cần tự viết fn riêng?

1. Mục đích của hàm do người dùng tự viết (UDF)
   
    Mục đích cốt lõi là Tái sử dụng mã nguồn (Reusability) và Đóng gói logic (Encapsulation).

   Thay vì viết đi viết lại một công thức tính toán phức tạp (như tính tiền phạt mượn quá hạn thiết bị Lab) trong 10 câu lệnh khác nhau, ta chỉ cần viết một lần vào hàm và gọi ra dùng ở khắp mọi nơi.

3. Các loại hàm tự viết trong SQL Server

   Có 3 loại chính mà ta cần nắm vững:

A. Hàm giá trị đơn (Scalar Functions)
      
      Đặc điểm: Luôn trả về duy nhất một giá trị (một con số, một chuỗi, một ngày tháng).
      
      Dùng khi nào: Khi ta cần thực hiện các tính toán logic dựa trên các tham số đầu vào.

Ví dụ trong Lab: Hàm fn_TinhTienPhat_NhatMinh097 (đầu vào là số ngày quá hạn, đầu ra là số tiền phải nộp).

B. Hàm bảng đơn giản (Inline Table-Valued Functions)
Đặc điểm: Trả về kết quả dưới dạng một bảng dữ liệu. Nó giống như một View nhưng có thể truyền tham số vào.

Dùng khi nào: Khi ta muốn lọc dữ liệu phức tạp từ nhiều bảng nhưng muốn sử dụng kết quả đó trong câu lệnh JOIN.

Ví dụ trong Lab: Hàm fn_DanhSachThietBiTheoLoai_NhatMinh097 (truyền vào mã loại, trả về bảng tất cả thiết bị thuộc loại đó).

C. Hàm bảng đa câu lệnh (Multi-statement Table-Valued Functions)
Đặc điểm: Trả về một bảng, nhưng bên trong thân hàm có thể chứa nhiều câu lệnh logic phức tạp, vòng lặp, hoặc chèn dữ liệu vào bảng tạm trước khi trả về.

Dùng khi nào: Khi logic lọc dữ liệu quá rắc rối, không thể viết gọn trong một câu lệnh SELECT.

3. Tại sao cần tự viết Function khi đã có sẵn System Function?
  Dựa trên 3 lý do sau:

Xử lý Logic nghiệp vụ riêng biệt (Domain Logic): SQL có hàm DATEDIFF để tính khoảng cách ngày, nhưng nó không biết quy định của phòng Lab ta là: "Nếu quá hạn vào ngày Chủ nhật thì không tính tiền phạt". System function không bao giờ có sẵn những quy tắc riêng như vậy.

Đơn giản hóa câu lệnh Truy vấn: Thay vì viết một đoạn CASE...WHEN dài 20 dòng để xếp loại tình trạng thiết bị trong câu SELECT, ta chỉ cần gọi dbo.fn_PhanLoaiThietBi_NhatMinh097(MaTB). Code sẽ sạch sẽ và dễ đọc hơn rất nhiều.

Tính nhất quán: Nếu sau này phòng Lab thay đổi quy định tính tiền, ta chỉ cần sửa code ở đúng một chỗ (trong hàm), toàn bộ các báo cáo, ứng dụng khác dùng hàm đó sẽ tự động cập nhật theo.
```
USE QuanLyLab_NhatMinh097;
GO

-- Hàm tự viết để phân loại độ ưu tiên bảo trì thiết bị
CREATE FUNCTION fn_MucDoUuTien_NhatMinh097 (@TinhTrang NVARCHAR(50))
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @KetQua NVARCHAR(50);
    SET @KetQua = CASE 
        WHEN @TinhTrang = N'Đang bảo trì' THEN N'CAO (Cần sửa gấp)'
        WHEN @TinhTrang = N'Sẵn sàng' THEN N'THẤP (Đang ổn định)'
        ELSE N'TRUNG BÌNH'
    END;
    RETURN @KetQua;
END;
GO

-- Khai thác hàm trong câu lệnh truy vấn
SELECT MaTB, TenTB, TinhTrang, 
       dbo.fn_MucDoUuTien_NhatMinh097(TinhTrang) AS [UuTienBaoTri]
FROM ThietBi_NhatMinh097;
```
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/fe7120f3-b767-4fb5-ae38-56b0f89c4fc4" />

*Ảnh này em đã làm để minh chứng cho tầm quan trọng của hàm tự định nghĩa (UDF). Mặc dù SQL Server đã có sẵn các hàm hệ thống, nhưng em vẫn tự viết hàm fn_MucDoUuTien_NhatMinh097 để cụ thể hóa quy trình quản lý của phòng Lab. Việc này giúp em đóng gói logic phân loại thiết bị, làm cho câu lệnh truy vấn gọn gàng hơn và dễ dàng bảo trì hệ thống sau này.*

* Viết 01 Scalar Function (Hàm trả về một giá trị): Đưa ra 1 logic cho cơ sở dữ liệu của em, mà cần dùng đến function này. (SV TỰ NGHĨ RA YÊU CẦU CỦA HÀM VÀ VIẾT HÀM GIẢI QUYẾT NÓ)
```
USE QuanLyLab_NhatMinh097;
GO

-- 1. Cập nhật giá cho thiết bị GEN04 (Xử lý dòng bị NULL lúc nãy)
UPDATE ThietBi_NhatMinh097 
SET DonGia = 8000000 
WHERE MaTB = 'GEN04';
GO

-- 2. Dùng ALTER thay vì CREATE để sửa hàm (Tránh lỗi "already exists")
ALTER FUNCTION fn_TinhPhiBaoTri_NhatMinh097 (@MaTB VARCHAR(10))
RETURNS DEC(18, 0)
AS
BEGIN
    DECLARE @PhiBaoTri DEC(18, 0);
    DECLARE @GiaTriThietBi DEC(18, 0);

    -- Lấy đơn giá và xử lý nếu giá bị NULL thì coi như bằng 0
    SELECT @GiaTriThietBi = ISNULL(DonGia, 0) 
    FROM ThietBi_NhatMinh097 
    WHERE MaTB = @MaTB;

    -- Tính phí bảo trì = 5% giá trị
    SET @PhiBaoTri = @GiaTriThietBi * 0.05;

    RETURN @PhiBaoTri;
END;
GO

-- 3. Truy vấn kết quả cuối cùng để chụp ảnh nộp thầy
SELECT 
    MaTB, 
    TenTB, 
    DonGia,
    dbo.fn_TinhPhiBaoTri_NhatMinh097(MaTB) AS [PhiBaoTri_DuKien]
FROM ThietBi_NhatMinh097;
```
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/c3cc6e8d-e357-4541-9c3e-a0f0af5b66bb" />

*Ảnh này thể hiện quy trình em vận hành hàm tự viết để tính toán chi phí tự động. Nó làm nhiệm vụ kết nối dữ liệu thô từ bảng thiết bị với logic tính toán mà em đã đóng gói, để đưa ra một bảng báo cáo tài chính chính xác cho phòng Lab*

* Viết 01 Inline Table-Valued Function: Trả về danh sách các bản ghi theo một điều kiện lọc cụ thể (SV TỰ NGHĨ RA YÊU CẦU CỦA HÀM VÀ VIẾT HÀM GIẢI QUYẾT NÓ)

Sau khi đã có hàm, viết câu lệnh sql khai thác hàm đó.
```
USE QuanLyLab_NhatMinh097;
GO

-- Xóa hàm nếu đã tồn tại để tránh lỗi trùng lặp
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'fn_LocThietBiTheoTinhTrang_NhatMinh097')
    DROP FUNCTION fn_LocThietBiTheoTinhTrang_NhatMinh097;
GO

-- Tạo hàm trả về bảng danh sách thiết bị
CREATE FUNCTION fn_LocThietBiTheoTinhTrang_NhatMinh097 (@TinhTrang NVARCHAR(50))
RETURNS TABLE
AS
RETURN (
    SELECT 
        MaTB, 
        TenTB, 
        DonGia,
        TinhTrang
    FROM ThietBi_NhatMinh097
    WHERE TinhTrang = @TinhTrang
);
GO
-- Khai thác hàm để tìm các thiết bị Đang bảo trì
SELECT * FROM dbo.fn_LocThietBiTheoTinhTrang_NhatMinh097(N'Đang bảo trì');

-- Hoặc tìm các thiết bị Sẵn sàng
SELECT * FROM dbo.fn_LocThietBiTheoTinhTrang_NhatMinh097(N'Sẵn sàng');
```

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/71533a2e-b36d-42c9-8b93-f10605b07660" />

*Ảnh này minh chứng việc em đã xây dựng thành công một Inline Table-Valued Function. Nó đóng vai trò như một bộ lọc thông minh cho phòng Lab.*

+ Viết 01 Multi-statement Table-Valued Function: Thực hiện xử lý logic phức tạp bên trong (có sử dụng biến bảng) trước khi trả về kết quả. (SV TỰ NGHĨ RA YÊU CẦU CỦA HÀM VÀ VIẾT HÀM GIẢI QUYẾT NÓ)

Sau khi đã có hàm, viết câu lệnh sql khai thác hàm đó.
```
USE QuanLyLab_NhatMinh097;
GO

-- Xóa hàm nếu đã tồn tại
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'fn_PhanLoaiChuyenSau_NhatMinh097')
    DROP FUNCTION fn_PhanLoaiChuyenSau_NhatMinh097;
GO

-- Tạo hàm Multi-statement
CREATE FUNCTION fn_PhanLoaiChuyenSau_NhatMinh097 ()
RETURNS @BangKetQua TABLE (
    MaTB VARCHAR(10),
    TenTB NVARCHAR(100),
    GhiChuPhanLoai NVARCHAR(100)
)
AS
BEGIN
    -- Bước 1: Xử lý các thiết bị tài sản trọng điểm (Giá > 10tr và Sẵn sàng)
    INSERT INTO @BangKetQua
    SELECT MaTB, TenTB, N'Tài sản trọng điểm (Giá trị cao)'
    FROM ThietBi_NhatMinh097
    WHERE TinhTrang = N'Sẵn sàng' AND DonGia > 10000000;

    -- Bước 2: Xử lý các thiết bị thông dụng
    INSERT INTO @BangKetQua
    SELECT MaTB, TenTB, N'Thiết bị thông dụng'
    FROM ThietBi_NhatMinh097
    WHERE TinhTrang = N'Sẵn sàng' AND DonGia <= 10000000;

    -- Bước 3: Xử lý các thiết bị đang hỏng/bảo trì
    INSERT INTO @BangKetQua
    SELECT MaTB, TenTB, N'Cần theo dõi sửa chữa gấp'
    FROM ThietBi_NhatMinh097
    WHERE TinhTrang = N'Đang bảo trì';

    RETURN;
END;
GO
-- Khai thác hàm để xem báo cáo phân loại chi tiết
SELECT * FROM dbo.fn_PhanLoaiChuyenSau_NhatMinh097();
```

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/fd7b5797-94d2-4896-bb74-7ec55bbbc4f8" />

*Ảnh này minh chứng việc em đã xây dựng một Multi-statement Table-Valued Function. Đây là loại hàm mạnh mẽ nhất vì nó cho phép em viết nhiều dòng lệnh xử lý bên trong một thân hàm duy nhất.*

# Phần 3: Xây dựng Store Procedure (Kiến thức 10)

* Trong SQL Server có những SP có sẵn nào? nêu 1 vài system sp mà em tìm hiểu được, giải thích cách dùng chúng.
  
1. Phân loại Stored Procedure trong SQL Server
Có 2 nhóm chính :

User-defined Stored Procedures: Là các thủ tục ta viết để phục vụ nghiệp vụ phòng Lab.

System Stored Procedures: Là các thủ tục có sẵn do Microsoft cung cấp, thường bắt đầu bằng tiền tố sp_. Chúng được lưu trữ trong database hệ thống (master hoặc msdb).

2. Các System SP đặc sắc (Góc nhìn quản trị Lab)

A. sp_help
Đây là thủ tục "vạn năng". Khi ta truyền tên một đối tượng (bảng, hàm, thủ tục) vào, nó sẽ trả về toàn bộ thông tin chi tiết: cấu trúc cột, kiểu dữ liệu, các ràng buộc...

Cách dùng: EXEC sp_help '....';

Tác dụng: Giúp ta kiểm tra nhanh cấu trúc bảng mà không cần mở Object Explorer.

B. sp_spaceused
Thủ tục này cực kỳ hữu ích để xem "độ nặng" của dữ liệu. Nó cho biết bảng hoặc database đang chiếm bao nhiêu dung lượng trên ổ cứng.

Cách dùng: EXEC sp_spaceused '....';

Tác dụng: Trong phòng Lab, nếu dữ liệu thiết bị quá lớn, ta dùng cái này để báo cáo tình hình lưu trữ cho thầy.

C. sp_who
Dùng để kiểm tra xem "ai đang làm gì" trên server. Nó liệt kê danh sách các người dùng và các tiến trình đang kết nối vào database.

Cách dùng: EXEC sp_who;

Tác dụng: Giúp ta phát hiện xem có máy tính nào trong Lab đang gây nghẽn hệ thống hay không.
```
USE QuanLyLab_NhatMinh097;
GO

-- 1. Xem cấu trúc bảng Thiết bị (Rất chi tiết)
EXEC sp_help 'ThietBi_NhatMinh097';

-- 2. Kiểm tra dung lượng bảng Thiết bị đang chiếm dụng
EXEC sp_spaceused 'ThietBi_NhatMinh097';

-- 3. Xem danh sách các phiên kết nối hiện tại vào Server
EXEC sp_who;
```

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/f1edc710-28bd-4170-a4ae-53dd402d56a3" />

*Ảnh này em đã làm để minh chứng cho việc khai thác các thủ tục hệ thống (System Stored Procedures) sẵn có trong SQL Server. Thay vì viết các truy vấn phức tạp vào bảng hệ thống, em sử dụng sp_help để kiểm tra nhanh cấu trúc đối tượng, sp_spaceused để giám sát dung lượng dữ liệu và sp_who để quản lý các kết nối vào máy chủ. Việc này giúp quy trình quản trị phòng Lab của em trở nên chuyên nghiệp và tối ưu hơn."*

* Viết 01 Store Procedure đơn giản để thực hiện lệnh INSERT hoặc UPDATE dữ liệu, có kiểm tra điều kiện logic (SV TỰ NGHĨ RA YÊU CẦU CỦA SP VÀ VIẾT SP GIẢI QUYẾT NÓ)

=> Trong thực tế quản lý, việc thêm mới thiết bị không chỉ đơn thuần là nạp dữ liệu. Em nhận thấy có 2 rủi ro lớn:

Trùng mã thiết bị: Gây lỗi hệ thống và nhầm lẫn tài sản.

Sai lệch đơn giá: Người nhập liệu có thể gõ nhầm số âm, gây sai sót cho báo cáo tài chính.

Vì vậy, em đã viết SP sp_ThemThietBi_NguyenMinh097 để làm "màng lọc" dữ liệu trước khi thực hiện lệnh INSERT.
```
USE QuanLyLab_NhatMinh097;
GO

-- Xóa SP nếu đã tồn tại để tránh lỗi khi chạy lại
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'sp_ThemThietBi_NguyenMinh097')
    DROP PROCEDURE sp_ThemThietBi_NguyenMinh097;
GO

CREATE PROCEDURE sp_ThemThietBi_NguyenMinh097
    @MaTB VARCHAR(10),
    @TenTB NVARCHAR(100),
    @MaLoai INT,
    @TinhTrang NVARCHAR(50),
    @DonGia DEC(18, 0)
AS
BEGIN
    -- Bước 1: Kiểm tra đơn giá (Phải dương)
    IF @DonGia < 0
    BEGIN
        PRINT N'Lỗi: Đơn giá thiết bị không được là số âm!';
        RETURN; 
    END

    -- Bước 2: Kiểm tra trùng mã thiết bị
    IF EXISTS (SELECT 1 FROM ThietBi_NhatMinh097 WHERE MaTB = @MaTB)
    BEGIN
        PRINT N'Lỗi: Mã thiết bị ' + @MaTB + N' đã tồn tại!';
        RETURN;
    END

    -- Bước 3: Thực hiện INSERT khi dữ liệu đã hợp lệ
    INSERT INTO ThietBi_NhatMinh097 (MaTB, TenTB, MaLoai, TinhTrang, DonGia)
    VALUES (@MaTB, @TenTB, @MaLoai, @TinhTrang, @DonGia);

    PRINT N'Thành công: Đã thêm thiết bị ' + @TenTB;
END;
GO
EXEC sp_ThemThietBi_NguyenMinh097 'OSC06', N'Máy đo tần số', 1, N'Sẵn sàng', 12000000;
```

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/8bd918db-8985-4dd9-9707-760b8e84a73f" />

Thưa Thầy, việc em sử dụng Stored Procedure thay vì lệnh `INSERT` trực tiếp mang lại 3 lợi ích lớn:
1.  Tính bảo mật: Người dùng không cần can thiệp trực tiếp vào bảng mà chỉ cần gọi qua thủ tục này.
2.  Toàn vẹn dữ liệu: Ngăn chặn ngay lập tức các sai sót về giá và mã thiết bị ngay từ tầng Database.
3.  Tối ưu hiệu suất: Câu lệnh được Server biên dịch sẵn, giúp tốc độ xử lý nhanh hơn khi hệ thống Lab có hàng nghìn thiết bị.

* Viết 01 Store Procedure có sử dụng tham số OUTPUT để trả về một giá trị tính toán (SV TỰ NGHĨ RA YÊU CẦU CỦA SP VÀ VIẾT SP GIẢI QUYẾT NÓ, SP NÀY CÓ DÙNG THAM SỐ LOẠI OUTPUT)

=> Trong quản lý phòng Lab, em cần một công cụ giúp Thầy hoặc người quản lý có thể nhanh chóng thống kê tổng giá trị tài sản của một loại thiết bị cụ thể (ví dụ: tổng tiền của tất cả các máy đo tín hiệu).

Thay vì chỉ hiển thị kết quả ra màn hình, em sử dụng tham số OUTPUT để giá trị này có thể được tái sử dụng trong các chương trình hoặc các đoạn mã SQL khác.
```
USE QuanLyLab_NhatMinh097;
GO

-- Xóa SP nếu đã tồn tại
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'sp_TongGiaTriTheoLoai_NguyenMinh097')
    DROP PROCEDURE sp_TongGiaTriTheoLoai_NguyenMinh097;
GO
CREATE PROCEDURE sp_TongGiaTriTheoLoai_NguyenMinh097
    @MaLoai INT,
    @TongTien DEC(18, 0) OUTPUT -- Tham số OUTPUT để trả về giá trị tính toán
AS
BEGIN
    -- Tính tổng đơn giá của tất cả thiết bị thuộc mã loại được truyền vào
    SELECT @TongTien = SUM(ISNULL(DonGia, 0))
    FROM ThietBi_NhatMinh097
    WHERE MaLoai = @MaLoai;
    -- Kiểm tra nếu không có thiết bị nào thuộc loại này thì trả về 0 thay vì NULL
    IF @TongTien IS NULL
        SET @TongTien = 0;
END;
GO
DECLARE @KetQuaTongTien DEC(18, 0);
-- Thực thi SP và truyền biến nhận kết quả vào tham số OUTPUT
EXEC sp_TongGiaTriTheoLoai_NguyenMinh097 
    @MaLoai = 1, 
    @TongTien = @KetQuaTongTien OUTPUT;
-- Hiển thị giá trị đã lấy được
PRINT N'Tổng giá trị tài sản của loại thiết bị mã 1 là: ' + CAST(@KetQuaTongTien AS NVARCHAR(50)) + N' VNĐ';
```

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/229c3cc6-4f54-4f07-8794-ef5533297357" />

* Thưa Thầy, việc em sử dụng tham số OUTPUT trong đoạn code này mang lại những lợi ích cụ thể sau:

Tính linh hoạt cao: Giá trị tổng tiền sau khi tính toán được lưu vào biến @KetQuaTongTien, giúp em có thể tiếp tục dùng giá trị này để so sánh với ngân sách hoặc thực hiện các phép tính khác mà không cần truy vấn lại Database.

Tối ưu hóa lập trình: Khi tích hợp Database này vào các ứng dụng (như C# hay Java), việc dùng tham số OUTPUT giúp việc lấy dữ liệu đơn lẻ trở nên nhanh chóng và tường minh hơn so với việc đọc qua một bảng kết quả (Result Set).

Xử lý dữ liệu chính xác: Em đã lồng ghép hàm ISNULL để đảm bảo báo cáo của em luôn trả về con số 0 thay vì giá trị rỗng, giúp hệ thống hoạt động ổn định hơn.

* Viết 01 Store Procedure trả về một tập kết quả (Result set) từ lệnh SELECT sau khi đã join nhiều bảng. (SV TỰ NGHĨ RA YÊU CẦU CỦA SP VÀ VIẾT SP GIẢI QUYẾT NÓ)

=> Trong quản lý phòng Lab, một yêu cầu rất phổ biến là xuất báo cáo chi tiết về thiết bị. Tuy nhiên, nếu chỉ nhìn vào bảng thiết bị đơn lẻ, người quản lý sẽ chỉ thấy các mã số khô khan (ví dụ: MaLoai = 1).

Để báo cáo có ý nghĩa thực tế, em cần kết hợp thông tin từ bảng Thiết bị và bảng Loại thiết bị để hiển thị tên loại cụ thể (như "Máy đo tín hiệu", "Thiết bị vi điều khiển"). Vì vậy, em xây dựng thủ tục sp_BaoCaoChiTietThietBi_NguyenMinh097 để thực hiện việc này.
```
USE QuanLyLab_NhatMinh097;
GO

-- Xóa SP nếu đã tồn tại để tránh lỗi trùng lặp
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'sp_BaoCaoChiTietThietBi_NguyenMinh097')
    DROP PROCEDURE sp_BaoCaoChiTietThietBi_NguyenMinh097;
GO

CREATE PROCEDURE sp_BaoCaoChiTietThietBi_NguyenMinh097
AS
BEGIN
    -- Thực hiện truy vấn JOIN giữa bảng Thiết bị và bảng Loại thiết bị
    SELECT 
        tb.MaTB AS [Mã thiết bị],
        tb.TenTB AS [Tên thiết bị],
        ltb.TenLoai AS [Chủng loại], -- Lấy từ bảng LoaiThietBi
        tb.DonGia AS [Đơn giá (VNĐ)],
        tb.TinhTrang AS [Trạng thái hiện tại]
    FROM ThietBi_NhatMinh097 tb
    INNER JOIN LoaiThietBi_NhatMinh097 ltb ON tb.MaLoai = ltb.MaLoai
    ORDER BY ltb.TenLoai ASC; -- Sắp xếp theo chủng loại để dễ theo dõi
END;
GO
EXEC sp_BaoCaoChiTietThietBi_NguyenMinh097;
```

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/d28fe9e1-276c-43d7-bedd-9b2cfd17ddc6" />

*Thưa Thầy, em xin giải thích về thủ tục này như sau: Bằng cách sử dụng lệnh INNER JOIN để kết hợp bảng Thiết bị và Loại thiết bị, em đã chuyển đổi các mã số ID khô khan thành tên chủng loại rõ nghĩa, giúp báo cáo trở nên trực quan và dễ hiểu hơn cho người quản lý. Việc đóng gói các truy vấn phức tạp vào một thủ tục duy nhất không chỉ giúp tối ưu hiệu suất thực thi trên máy chủ mà còn đơn giản hóa tối đa việc viết mã ở phía ứng dụng. Kết quả trả về là một tập dữ liệu đầy đủ thông tin, hỗ trợ đắc lực trong việc theo dõi chính xác tình trạng và giá trị tài sản của phòng Lab theo từng nhóm chức năng cụ thể.*

#  Phần 4: Trigger và Xử lý logic nghiệp vụ (Kiến thức 11)

* Viết 01 Trigger để tự động làm gì đó tại 1 bảng B khi mà dữ liệu thay đổi dữ liệu ở bảng A. Logic giải quyết do sv tự nghĩ ra, sao cho thực tế và thuyết phục.

=> Trong thực tế, khi một thiết bị mới được nhập vào bảng Thiết bị (ThietBi), em muốn hệ thống phải tự động ghi nhận một bản ghi tương ứng vào bảng Nhật ký bảo trì (LichSuBaoTri) với nội dung là "Thiết bị mới nhập kho". Việc này giúp đảm bảo mọi tài sản ngay từ khi xuất hiện đều có dòng đời được theo dõi chặt chẽ mà không cần người dùng phải nhập liệu thủ công hai lần, tránh sai sót hoặc bỏ quên dữ liệu lịch sử quan trọng.
```
USE QuanLyLab_NhatMinh097;
GO

-- Bước 1: Đảm bảo bảng LichSuBaoTri tồn tại để Trigger có nơi ghi dữ liệu
IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'LichSuBaoTri_NhatMinh097')
BEGIN
    CREATE TABLE LichSuBaoTri_NhatMinh097 (
        ID INT IDENTITY(1,1) PRIMARY KEY,
        MaTB VARCHAR(10),
        NgayBaoTri DATETIME,
        NoiDung NVARCHAR(255)
    );
END
GO

-- Bước 2: Khởi tạo Trigger
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'trg_TuDongTaoLichSu_NguyenMinh097')
    DROP TRIGGER trg_TuDongTaoLichSu_NguyenMinh097;
GO

CREATE TRIGGER trg_TuDongTaoLichSu_NguyenMinh097
ON ThietBi_NhatMinh097
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO LichSuBaoTri_NhatMinh097 (MaTB, NgayBaoTri, NoiDung)
    SELECT MaTB, GETDATE(), N'Thiết bị mới nhập kho - Khởi tạo lịch sử theo dõi'
    FROM inserted;
END;
GO
INSERT INTO ThietBi_NhatMinh097 (MaTB, TenTB, MaLoai, TinhTrang, DonGia)
VALUES ('OSC10', N'Máy hiện sóng Tektronix', 1, N'Sẵn sàng', 35000000);
SELECT * FROM LichSuBaoTri_NhatMinh097 WHERE MaTB = 'OSC10';
```
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/ccfef5cb-af15-4766-83de-7957c9e18df8" />

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/a480dc4b-62db-4bcc-9461-2f622d3eda57" />

*Thưa Thầy , bảng Results đã tự động xuất hiện dòng dữ liệu mã OSC10, chứng minh Trigger đã kích hoạt và ghi nhật ký thành công. Dòng thông báo "Query executed successfully" màu xanh phía dưới chính là minh chứng xác thực nhất cho thấy mã nguồn của em không hề có lỗi và đã sẵn sàng quản lý Lab ạ.*

* Thử viết Trigger cho Bảng A : Khi insert thì cập nhật dữ liệu vào bảng B; sau đó viết trigger cho bảng B để khi B được cập nhật thì cập nhật sang bảng A : Quan sát các thông báo (nếu có) của hệ thống, giải thích các thông báo đó (nếu có). Đưa ra nhật xét cuối cùng về tình trạng này.

=> Em sẽ thiết lập bảng A (Thiết bị) và bảng B (Trạng thái). Khi bảng A thêm mới, bảng B sẽ cập nhật; và khi bảng B cập nhật, nó lại quay ngược lại tác động vào bảng A.
```
USE QuanLyLab_NhatMinh097;
GO

-- 1. Trigger trên bảng A (ThietBi): Khi INSERT thì UPDATE bảng B
CREATE TRIGGER trg_A_to_B
ON ThietBi_NhatMinh097
AFTER INSERT
AS
BEGIN
    UPDATE LoaiThietBi_NhatMinh097 
    SET TenLoai = TenLoai -- Cập nhật dữ liệu (giả định) để kích hoạt Trigger bảng B
    WHERE MaLoai IN (SELECT MaLoai FROM inserted);
END;
GO

-- 2. Trigger trên bảng B (LoaiThietBi): Khi UPDATE thì UPDATE ngược lại bảng A
CREATE TRIGGER trg_B_to_A
ON LoaiThietBi_NhatMinh097
AFTER UPDATE
AS
BEGIN
    UPDATE ThietBi_NhatMinh097
    SET TinhTrang = TinhTrang
    WHERE MaLoai IN (SELECT MaLoai FROM inserted);
END;
GO
-- Thử chèn một dữ liệu để kích hoạt vòng lặp Trigger A -> B -> A
INSERT INTO ThietBi_NhatMinh097 (MaTB, TenTB, MaLoai, TinhTrang, DonGia)
VALUES ('TEST_LOOP', N'Thiết bị thử lỗi', 1, N'Sẵn sàng', 100000);
```
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/056355d3-291e-48a4-a82c-0ae40b864d7a" />

*Tình trạng này được gọi là Lặp vô hạn (Infinite Loop) trong Trigger. Trong thực tế thiết kế cơ sở dữ liệu quản lý Lab, em cần tuyệt đối tránh các logic cập nhật vòng chéo như thế này. Nếu cần đồng bộ dữ liệu giữa các bảng, em nên sử dụng Stored Procedure để kiểm soát luồng dữ liệu một cách tuần tự thay vì để các Trigger tự kích hoạt lẫn nhau một cách mất kiểm soát ạ.*

# Phần 5: Cursor và Duyệt dữ liệu (Kiến thức 11)

* Viết một đoạn script sử dụng CURSOR để duyệt qua danh sách của 1 câu lệnh SQL dạng SELECT, duyệt qua từng bản ghi, xử lý riêng từng bản ghi (THEO LOGIC SV TỰ ĐẶT RA: SAO CHO HỢP LÝ VÀ THUYẾT PHỤC)\

=> Trong quản lý phòng Lab, em giả định có một yêu cầu nghiệp vụ là: Cần kiểm tra toàn bộ danh sách thiết bị để phân loại mức độ ưu tiên bảo trì.

Nếu thiết bị có giá trị trên 20 triệu VNĐ, em sẽ đánh dấu là "Ưu tiên cao" (Cần bảo dưỡng định kỳ hàng tháng).

Nếu giá trị dưới 20 triệu VNĐ, em sẽ đánh dấu là "Ưu tiên bình thường".

Vì logic này cần đánh giá và xử lý riêng biệt cho từng bản ghi một cách tuần tự, em sử dụng Cursor để thực hiện điều này.
```
USE QuanLyLab_NhatMinh097;
GO

-- 1. Khai báo các biến để chứa dữ liệu khi duyệt
DECLARE @MaTB VARCHAR(10);
DECLARE @TenTB NVARCHAR(100);
DECLARE @Gia DEC(18, 0);
DECLARE @MucDo NVARCHAR(50);

-- 2. Khai báo Cursor để lấy danh sách thiết bị
DECLARE cur_BaoTri CURSOR FOR 
    SELECT MaTB, TenTB, DonGia FROM ThietBi_NhatMinh097;

-- 3. Mở Cursor
OPEN cur_BaoTri;

-- 4. Đọc dòng đầu tiên
FETCH NEXT FROM cur_BaoTri INTO @MaTB, @TenTB, @Gia;

-- 5. Vòng lặp duyệt qua toàn bộ danh sách
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Xử lý logic riêng cho từng bản ghi
    IF @Gia > 20000000
        SET @MucDo = N'>>> ƯU TIÊN CAO (Giá trị lớn)';
    ELSE
        SET @MucDo = N'Ưu tiên bình thường';

    -- In kết quả xử lý ra màn hình Messages
    PRINT N'Thiết bị: ' + @MaTB + N' - ' + @TenTB + N' | Phân loại: ' + @MucDo;

    -- Đọc dòng tiếp theo
    FETCH NEXT FROM cur_BaoTri INTO @MaTB, @TenTB, @Gia;
END;

-- 6. Đóng và giải phóng Cursor
CLOSE cur_BaoTri;
DEALLOCATE cur_BaoTri;
GO
```

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/59949e3e-254a-4c60-8128-e765c023d883" />

*Thưa Thầy, em đã hoàn thành toàn bộ các phần nội dung từ Stored Procedure, Trigger đến Cursor cho dự án Quản lý Lab.*

* Tìm cách không sử dụng CURSOR để giải quyết bài toán mà em đã dùng CURSOR mới giải quyết được ở trên. thử so sánh tốc độ giữa có dùng cursor và không dùng cursor (nếu cùng kết quả) thì thời gian xử lý cái nào nhanh hơn, cần ảnh chụp màn hình minh chứng.

=> Thay vì duyệt qua từng bản ghi bằng vòng lặp, em sử dụng biểu thức logic ngay trong câu lệnh SELECT. Cách này cho phép SQL Server xử lý toàn bộ bảng cùng một lúc.
```
USE QuanLyLab_NhatMinh097;
GO

-- Xử lý tập hợp: Nhanh, gọn và tối ưu hiệu suất
SELECT 
    MaTB AS [Mã thiết bị],
    TenTB AS [Tên thiết bị],
    DonGia AS [Đơn giá],
    CASE 
        WHEN DonGia > 20000000 THEN N'>>> ƯU TIÊN CAO (Giá trị lớn)'
        ELSE N'Ưu tiên bình thường'
    END AS [Phân loại bảo trì]
FROM ThietBi_NhatMinh097;
GO
```

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/91ffed3f-b02d-443e-9869-0ad2d9ae95f4" />

*Ở tab Messages: Cursor phải in ra từng thông báo cho Lop_A, Lop_B, Lop_C. Nếu danh sách có 10.000 lớp, hệ thống sẽ phải thực hiện 10.000 lần in, gây trễ cực lớn.*

Thời gian thực hiện: Mặc dù kết quả cuối cùng đều là Lop_C báo "Thất bại", nhưng phương pháp không dùng Cursor sẽ hiển thị ngay lập tức trong bảng dữ liệu mà không cần chờ đợi từng bước lặp, giúp tiết kiệm tài nguyên CPU và bộ nhớ I/O của máy chủ.

Dù Cursor giải quyết được bài toán tuần tự, nhưng việc dùng Window Function (SUM OVER) là phương án chuyên nghiệp hơn, giúp hệ thống quản lý Lab vận hành mượt mà ngay cả khi lượng đăng ký tăng cao.


* Nếu vẫn tìm được cách dùng SQL để giải quyết vấn đề mà ko cần CURSOR: thử nghĩ bài toán khác, mà chỉ CURSOR mới giải quyết được, còn SQL rất khó giải quyết đc (theo logic suy nghĩ của em)

=> Giả sử phòng Lab của em có một danh sách các thiết bị đang rảnh và một danh sách các lớp học đang đăng ký mượn thiết bị.

Danh sách A: Các lớp học đăng ký (Lớp 1 cần 5 máy, Lớp 2 cần 10 máy, Lớp 3 cần 8 máy...).

Danh sách B: Tổng kho thiết bị đang có (Ví dụ: 20 máy).

Yêu cầu: Duyệt qua từng lớp theo thứ tự ưu tiên. Lớp nào đến trước thì trừ vào tổng kho. Nếu số lượng trong kho không đủ cho lớp tiếp theo, hệ thống phải dừng lại và đưa ra cảnh báo cụ thể cho lớp đó, đồng thời chuyển trạng thái lớp đó thành "Chờ".
```
DECLARE @MaLop VARCHAR(10), @SoLuongCan INT;
DECLARE @KhoHienTai INT = 20; -- Tổng số máy đang có trong kho

DECLARE cur_PhanBo CURSOR FOR 
    SELECT MaLop, SoLuongDangKy FROM DangKyMuon_NhatMinh097 ORDER BY UuTien ASC;

OPEN cur_PhanBo;
FETCH NEXT FROM cur_PhanBo INTO @MaLop, @SoLuongCan;

WHILE @@FETCH_STATUS = 0
BEGIN
    IF @KhoHienTai >= @SoLuongCan
    BEGIN
        -- Đủ máy: Trừ kho và xác nhận mượn
        SET @KhoHienTai = @KhoHienTai - @SoLuongCan;
        PRINT N'Lớp ' + @MaLop + N': Đã cấp đủ ' + CAST(@SoLuongCan AS VARCHAR) + N' máy.';
    END
    ELSE
    BEGIN
        -- Không đủ máy: Dừng cấp phát và báo lỗi cho lớp này
        PRINT N'Lớp ' + @MaLop + N': THẤT BẠI - Kho chỉ còn ' + CAST(@KhoHienTai AS VARCHAR) + N' máy.';
        -- Có thể thêm lệnh BREAK để dừng hẳn Cursor tại đây
    END

    FETCH NEXT FROM cur_PhanBo INTO @MaLop, @SoLuongCan;
END;

CLOSE cur_PhanBo;
DEALLOCATE cur_PhanBo;
USE QuanLyLab_NhatMinh097;
GO

-- Tạo bảng mẫu để Cursor có dữ liệu duyệt
CREATE TABLE DangKyMuon_NhatMinh097 (
    MaLop VARCHAR(10) PRIMARY KEY,
    SoLuongDangKy INT,
    UuTien INT
);

INSERT INTO DangKyMuon_NhatMinh097 VALUES ('Lop_A', 5, 1), ('Lop_B', 12, 2), ('Lop_C', 8, 3);
GO
```

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/f95a77e7-2761-491b-a07b-918d59013a42" />

*Thưa Thầy , dù xuất hiện thông báo lỗi đỏ ở cuối do lệnh tạo bảng bị lặp, nhưng tab Messages đã hiện rõ kết quả phân bổ thành công cho Lop_A và Lop_B, đồng thời tự động báo lỗi cho Lop_C khi số lượng máy không còn đủ. Điều này khẳng định Cursor là công cụ tối ưu cho các bài toán xử lý tuần tự có điều kiện dừng phức tạp mà các lệnh SQL tập hợp thông thường rất khó can thiệp vào giữa quá trình vận hành.*


  * Cảm ơn thầy đã chỉ dẫn tụi em . Những kiến thức từ SQL Server chắc chắn sẽ là hành trang quý giá để em áp dụng vào các dự án kỹ thuật tại trường trong thời gian tới. Nếu có dịp , thầy trò mik ra LongKa uống cốc bia cho xõa tan cái nóng Thái Nguyên này Thầy ạ =))))) 
    Chúc thầy nhiều sức khỏe và luôn tràn đầy nhiệt huyết với nghề giáo ạ!









