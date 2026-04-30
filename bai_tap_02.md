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

Khai thác: Minh có thể dùng nó để ghi lại xem thiết bị được mượn từ máy tính nào trong phòng Lab.

B. Hàm ISNUMERIC()
    Hàm này kiểm tra xem một chuỗi có phải là số hay không. Trong ngành Điện tử, khi nhận dữ liệu từ các cảm biến (Sensor) gửi về dưới dạng chuỗi, hàm này giúp Minh lọc ra những dữ liệu rác trước khi tính toán.

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

* Ảnh này em đã làm để minh chứng cho việc khai thác các hàm hệ thống (System Functions) có sẵn trong SQL Server. Em đã sử dụng HOST_NAME() để xác định máy tính đang thao tác và SERVERPROPERTY() để truy xuất thông tin cấu hình Server. Việc này giúp em quản lý chặt chẽ hơn về an ninh và nguồn gốc dữ liệu trong hệ thống Quản lý Lab của mình.


* Hàm do người dùng tự viết trong SQL thường mang mục đích gì? Nó có những loại nào? Mỗi loại thường được dùng khi nào? Tại sao có nhiều system function rồi mà vẫn cần tự viết fn riêng?

1. Mục đích của hàm do người dùng tự viết (UDF)
   
    Mục đích cốt lõi là Tái sử dụng mã nguồn (Reusability) và Đóng gói logic (Encapsulation).

   Thay vì viết đi viết lại một công thức tính toán phức tạp (như tính tiền phạt mượn quá hạn thiết bị Lab) trong 10 câu lệnh khác nhau, Minh chỉ cần viết một lần vào hàm và gọi ra dùng ở khắp mọi nơi.

3. Các loại hàm tự viết trong SQL Server

   Có 3 loại chính mà Minh cần nắm vững:

A. Hàm giá trị đơn (Scalar Functions)
      
      Đặc điểm: Luôn trả về duy nhất một giá trị (một con số, một chuỗi, một ngày tháng).
      
      Dùng khi nào: Khi Minh cần thực hiện các tính toán logic dựa trên các tham số đầu vào.

Ví dụ trong Lab: Hàm fn_TinhTienPhat_NhatMinh097 (đầu vào là số ngày quá hạn, đầu ra là số tiền phải nộp).

B. Hàm bảng đơn giản (Inline Table-Valued Functions)
Đặc điểm: Trả về kết quả dưới dạng một bảng dữ liệu. Nó giống như một View nhưng có thể truyền tham số vào.

Dùng khi nào: Khi Minh muốn lọc dữ liệu phức tạp từ nhiều bảng nhưng muốn sử dụng kết quả đó trong câu lệnh JOIN.

Ví dụ trong Lab: Hàm fn_DanhSachThietBiTheoLoai_NhatMinh097 (truyền vào mã loại, trả về bảng tất cả thiết bị thuộc loại đó).

C. Hàm bảng đa câu lệnh (Multi-statement Table-Valued Functions)
Đặc điểm: Trả về một bảng, nhưng bên trong thân hàm có thể chứa nhiều câu lệnh logic phức tạp, vòng lặp, hoặc chèn dữ liệu vào bảng tạm trước khi trả về.

Dùng khi nào: Khi logic lọc dữ liệu quá rắc rối, không thể viết gọn trong một câu lệnh SELECT.

3. Tại sao cần tự viết Function khi đã có sẵn System Function?
Đây là câu hỏi "ăn điểm" với thầy. Minh có thể giải thích dựa trên 3 lý do sau:

Xử lý Logic nghiệp vụ riêng biệt (Domain Logic): SQL có hàm DATEDIFF để tính khoảng cách ngày, nhưng nó không biết quy định của phòng Lab Minh là: "Nếu quá hạn vào ngày Chủ nhật thì không tính tiền phạt". System function không bao giờ có sẵn những quy tắc riêng như vậy.

Đơn giản hóa câu lệnh Truy vấn: Thay vì viết một đoạn CASE...WHEN dài 20 dòng để xếp loại tình trạng thiết bị trong câu SELECT, Minh chỉ cần gọi dbo.fn_PhanLoaiThietBi_NhatMinh097(MaTB). Code sẽ sạch sẽ và dễ đọc hơn rất nhiều.

Tính nhất quán: Nếu sau này phòng Lab thay đổi quy định tính tiền, Minh chỉ cần sửa code ở đúng một chỗ (trong hàm), toàn bộ các báo cáo, ứng dụng khác dùng hàm đó sẽ tự động cập nhật theo.
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

* Ảnh này em đã làm để minh chứng cho tầm quan trọng của hàm tự định nghĩa (UDF). Mặc dù SQL Server đã có sẵn các hàm hệ thống, nhưng em vẫn tự viết hàm fn_MucDoUuTien_NhatMinh097 để cụ thể hóa quy trình quản lý của phòng Lab. Việc này giúp em đóng gói logic phân loại thiết bị, làm cho câu lệnh truy vấn gọn gàng hơn và dễ dàng bảo trì hệ thống sau này.

* Viết 01 Scalar Function (Hàm trả về một giá trị): Đưa ra 1 logic cho cơ sở dữ liệu của em, mà cần dùng đến function này. (SV TỰ NGHĨ RA YÊU CẦU CỦA HÀM VÀ VIẾT HÀM GIẢI QUYẾT NÓ)





