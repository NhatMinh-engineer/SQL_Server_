Tên : Nguyễn Hữu Nhật Minh
Lớp : K59KMT.K01
Mssv : K235480106097  
  Em mong thầy xem bài làm và nhận xét giúp em , để em có thể ngày càng tốt hơn ạ 


Câu 1 : Vì lúc setup , em đã chọn chế độ basic nên nó đã bỏ qua bước login ạ , nên sau em bù bằng cách tạo sau, sau khi đã down xong ssms

<img width="1919" height="1079" alt="Ảnh chụp màn hình 2026-04-12 012445" src="https://github.com/user-attachments/assets/aec862a7-55a1-4dcd-b310-a53c86f805aa" />


Câu 2 : Cấu hình cho SQL Server làm việc

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/047c970e-6e21-4c78-ba1b-698d56c3ab1d" />

Câu 3 : Kiểm tra xem service SQL Server có đang running và mở đúng cổng đã chọn hay không?

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/7229a665-b1aa-4979-a36e-cf6534b75c2e" />

Câu 4 : Cài đặt SQL Server Management Studio

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/d1bf6308-5a01-40ba-b480-5dc7ddfc6b2f" />

Câu 5 : Chạy phần mềm ssms để Đăng nhập vào SQL Server bằng 2 cách: Windows Authentication và SQL Server Authentication. 

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/27462f6b-b512-4e15-bace-ad843fe8b54e" />

Câu 6 : Tạo cơ sở dữ liệu mới (create database) với tên tuỳ ý, chọn Path (nơi lưu trữ db) cho file lưu dữ liệu và file lưu log ở ổ đĩa khác với ổ C. mở path đã chọn xem 2 file đã tạo ra.

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/e22d1106-86e1-422b-bffe-79083a87dbc7" />

Câu 7 : Tạo bảng dữ liệu (create and design table) với tên bảng tuỳ ý, có các trường dữ liệu phù hợp với dữ liệu của file data mẫu (CSV), với Khoá chính (Primary Key) là trường masv

<img width="1915" height="1079" alt="image" src="https://github.com/user-attachments/assets/41169d1a-4eb7-4a39-973f-5418ec838500" />

Câu 8 :  Tìm cách import dữ liệu từ file mẫu vào trong bảng vừa tạo.

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/26dbb5a2-652f-470c-b638-dc3b164551c0" />

Câu 9 :  GÕ lệnh để kiểm tra xem số dòng của bảng dữ liệu sau khi import, kết quả ok sẽ khoảng 12020 dòng.

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/72fca1d8-e5d0-45c4-9a7d-7bba678b9d28" />

Câu 10 : Gõ lệnh để thêm (insert) 1 row vào bảng, với dữ liệu là thông tin cá nhân của sv đang làm bài (mỗi sv sẽ luôn khác nhau ở bước này).

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/4aec92ca-a48e-4de0-a659-af20e6c04cb9" />

Câu 11 : Gõ lệnh để cập nhật(update) trường noisinh thành 'Sao Hoả' cho những dòng có noisinh và diachi đều là NULL.

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/5115a477-b46c-4576-939e-5cdfb89de968" />

câu 12 :  Tạo bảng SaoHoa gồm những sinh viên có nơi sinh ở 'Sao Hoả', keyword gợi ý: sử dụng 1 câu lệnh: SELECT + INTO

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/c0dec980-225d-4387-9991-c7ef6b168d3c" />

Câu 13 : Gõ lệnh xoá (delete) trong bảng SaoHoa những sinh viên cùng họ với em, vd em họ nguyễn thì xoá những sv họ nguyễn.

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/f42a75dd-b50b-40f0-b0a8-c4fb17799857" />

Câu 14 :  Xuất toàn bộ kết quả của các bước 6,7,8,9,10,11,12,13 ra file dulieu.sql , keyword gợi ý: sử dụng tính năng GEN SCRIPT struct+data cho database

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/9b4c94dc-4481-43a1-824e-9156fe9054e6" />

câu 15 : Xoá csdl đã tạo, sau khi xoá thành công, kiểm tra tại path (path chọn ở bước 6) xem còn tồn tại 2 file của bước 6 không?

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/67cd0feb-29ad-42b0-a291-36c1bf4a2946" />

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/184de64e-4225-4591-be2e-e5a7b5da88b5" />


Câu 16 : mở file dulieu.sql của bước 14, chạy toàn bộ các lệnh này. REFRESH lại cây liệt kê các database => kiểm chứng kết quả được tạo ra tương đương với các bước 6,7,8,9,10,11,12,13.

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/824b4a6a-74f6-461f-ab2f-0e842f086c3c" />

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/09694f45-39f6-433e-bec9-36a8437618cc" />


Câu 17 : upload file dulieu.sql lên github repository của em (repository mà em đang edit file README.md)

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/7f5c57e0-d2bd-4299-8716-055daa1838ff" />







