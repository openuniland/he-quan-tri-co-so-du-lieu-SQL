--Nguyễn Công Minh - 1910a03
USE ThucHanhSQL
GO

				/*------ Buổi 6 -------*/
--6.1
--a. Thực hiện phân tán ngang bảng tblKhachhang theo điều kiện khách hàng
--    có địa chỉ ‘Hà nội’ đặt tại trạm 1 và khác ‘Hà nội’ đặt ở trạm 2.

SELECT * FROM dbo.tblKhachHang

CREATE TABLE phantankhachhang
(
iMaKH INT NOT NULL ,stenKH NVARCHAR(30),dngaysinh DATE,sdiachi NVARCHAR(40),
dienthoai VARCHAR(12),gioitinh BIT ,tongtienhang FLOAT
)
ALTER TABLE phantankhachhang ADD CONSTRAINT PK_ma PRIMARY KEY(iMaKH)
ALTER TABLE dbo.phantankhachhang ADD CONSTRAINT CK_diachi CHECK (sdiachi LIKE N'%hà nội%')

INSERT INTO tram1 SELECT *FROM dbo.tblKhachHang WHERE sdiachi LIKE N'hà nội'


CREATE SYNONYM tram1 FOR dbo.phantankhachhang -- dat tram1 la may chu 
CREATE SYNONYM tram2 FOR LINK.BTTHPHANTAN.dbo.phantankhachhang -- tram 2 la may ao

INSERT INTO tram2 SELECT *FROM dbo.tblKhachHang WHERE sdiachi NOT LIKE N'hà nội'


--- b. Viết lệnh lấy danh sách của khách hàng ở ‘Hà nội’ hoặc ‘TP HCM’ có độ tuổi từ 18 - 25 đã mua hàng.

-- vì tất cả những người mua hàng mới đc gọi là khách hàng nên all khách hàng đều đã mua hàng
CREATE VIEW DSKH_HN_HCM
AS 
SELECT * FROM dbo.phantankhachhang WHERE YEAR(GETDATE()) - YEAR(dngaysinh) >= 18
							AND  YEAR(GETDATE()) - YEAR(dngaysinh) <= 25
 UNION

 SELECT * FROM tram2 WHERE sdiachi LIKE N'TPHCM' AND 
 YEAR(GETDATE()) - YEAR(dngaysinh) >= 18
AND  YEAR(GETDATE()) - YEAR(dngaysinh) <= 25

-- gọi view
SELECT * FROM DSKH_HN_HCM

--c. Viết thủ tục thêm dữ liệu Khách hàng và đưa vào trạm phù hợp.
ALTER PROC ADDKH
@ma int , @ten nvarchar(30) , @ngaysinh date , @diachi nvarchar(40) , @dienthoai varchar(12),
@gioitinh bit , @tongtienhang float
AS 
IF NOT EXISTS (SELECT * FROM dbo.tblKhachHang WHERE iMaKH = @ma)
BEGIN
INSERT INTO dbo.tblKhachHang
			VALUES(@ma,@ten, @ngaysinh,@diachi,@dienthoai,@gioitinh,@tongtienhang)
    IF @diachi LIKE N'%hà nội%'
		BEGIN
			INSERT INTO dbo.phantankhachhang SELECT * FROM dbo.tblKhachHang
			WHERE iMaKH NOT IN (SELECT iMaKH FROM dbo.phantankhachhang) AND sDiachi LIKE N'%hà nội%'
		END
	ELSE
		BEGIN
		    INSERT INTO tram2 SELECT * FROM dbo.tblKhachHang
			WHERE iMaKH NOT IN (SELECT iMaKH FROM tram2) AND sDiachi NOT LIKE N'%hà nội%'
		END
END
SELECT * FROM dbo.tblKhachHang 
SELECT * FROM tram1
SELECT * FROM tram2
DELETE dbo.tblKhachHang WHERE iMaKH = 7
EXECUTE ADDKH	@ma = 7,
				@ten = N'nguyễn văn K',
				@ngaysinh = '19980201',
				@diachi = 'hà nội',
				@dienthoai = '1280',
				@gioitinh = 0,
				@tongtienhang = 0.0


		/*----- bài 6.2 -----*/
/*
a. Thực hiện phân tán ngang bảng tblNHANVIEN theo điều kiện nhân viên
có Lương cơ bản đưới 4 triệu đặt tại máy trạm 1 và các nhân viên còn lại
đặt ở máy trạm 2
*/

CREATE TABLE NHANVIENPHANTAN
(
iMaNV INT NOT NULL,
sTenNV NVARCHAR(30),
sDiachi NVARCHAR(50),
sDienthoai CHAR(12),
dNgaysinh DATETIME,
dNgayvaolam DATETIME,
fLuongcoban FLOAT(11),
fPhucap FLOAT(7)
)
ALTER TABLE NHANVIENPHANTAN ADD sCMND CHAR(20) UNIQUE
ALTER TABLE NHANVIENPHANTAN ADD CONSTRAINT PK_Ma PRIMARY KEY(iMaNV)


CREATE SYNONYM tramnv2 FOR LINK.BTTHPHANTAN.DBO.NHANVIENPHANTAN

SELECT * FROM dbo.tblNhanVien WHERE (fLuongcoban + fPhucap) >= 4
INSERT INTO dbo.NHANVIENPHANTAN SELECT * FROM dbo.tblNhanVien WHERE (fLuongcoban + fPhucap) < 4

INSERT INTO tramnv2 SELECT * FROM dbo.tblNhanVien WHERE (fLuongcoban + fPhucap) >= 4

--b. Viết thủ tục để thêm một nhân viên mới vào CSDL tương ứng

CREATE PROC ADDNV
@ma int , @ten nvarchar(30),@diachi nvarchar(30),@dt varchar(12),@ns datetime ,@ngayvaolam datetime , @lcb int , @pc int , @cmnd varchar(15)
AS 
IF NOT EXISTS (SELECT * FROM dbo.tblNhanVien WHERE iMaNV = @ma)
BEGIN
    INSERT INTO dbo.tblNhanVien VALUES(@ma,@ten,@diachi,@dt,@ns,@ngayvaolam,@lcb,@pc,@cmnd)
		IF (@lcb+@pc) <4
			BEGIN
			    INSERT INTO dbo.NHANVIENPHANTAN SELECT *FROM dbo.tblNhanVien 
				WHERE iMaNV NOT IN (SELECT iMaNV FROM dbo.NHANVIENPHANTAN) AND (fLuongcoban + fPhucap) < 4
			END
		ELSE
			BEGIN
			    INSERT INTO tramnv2 SELECT *FROM dbo.tblNhanVien 
				WHERE iMaNV NOT IN (SELECT iMaNV FROM tramnv2) AND (fLuongcoban + fPhucap) < 4
			END
END
-- gọi thủ tục , test 
EXECUTE ADDNV	@ma = 8 ,
				@ten = N'nguyễn khánh linh',
				@diachi = N'hà nội',
				@dt = '1234',
				@ns = '19900203',
				@ngayvaolam = '20211010',
				@lcb = 3,
				@pc = 0.5,
				@cmnd = '13245'

DELETE dbo.tblNhanVien WHERE iMaNV = 8
DELETE dbo.NHANVIENPHANTAN WHERE iMaNV = 8

-- c. Tạo View cho xem danh sách tên các nhân viên đã làm ở cửa hàng trên 2 năm
CREATE VIEW DSNV_lonhon2nam
AS 
SELECT * FROM dbo.NHANVIENPHANTAN WHERE YEAR(GETDATE()) - YEAR(dNgayvaolam) > 2
UNION
SELECT * FROM tramnv2 WHERE YEAR(GETDATE()) - YEAR(dNgayvaolam) >2

-- gọi view
SELECT * FROM DSNV_lonhon2nam


				/*------ bài 6.3 ------*/

/*
a. Chia tách dọc trên tblDonDathang thành 2 bảng theo cấu trúc như sau
○1. tblThongtinGiaohang (iSoHD, dNgaygiaohang, sDiachiGiaohang)
○2. tblDonDathang (iSoHD, iMaNV, iMaKH, dNgayDathang)
*/

CREATE TABLE tblThongtinGiaohang 
(
iSoHD INT NOT NULL , dNgaygiaohang DATETIME ,  sDiachiGiaohang  NVARCHAR(40)
)
ALTER TABLE tblThongtinGiaohang ADD CONSTRAINT KC_sohd PRIMARY KEY (iSoHD)

SELECT * FROM dbo.tblThongtinGiaohang
SELECT * FROM LINK.BTTHPHANTAN.dbo.tblDonDatHang

CREATE SYNONYM tramdh2 FOR LINK.BTTHPHANTAN.dbo.tblDonDatHang

-- b. Chuyển tblThongtinGiaohang cùng dữ liệu sang Máy trạm 2

INSERT INTO dbo.tblThongtinGiaohang SELECT iSoHD,dNgaygiaohang,sDiachigiaohang FROM dbo.tblDonDatHang 

INSERT INTO tramdh2 SELECT iSoHD,iMaNV,iMaKH,dNgaydathang FROM dbo.tblDonDatHang

--c. Sửa lại Stored Procedure đã làm ở Bài 4.3.c để dữ liệu được thêm bằng
--Stored Procedure đó sẽ đến đúng các bảng đích đã chia tách.





--d. Tạo View cho xem danh sách nhân viên và số đơn hàng chưa đến ngày giao của từng nhân viên.

CREATE VIEW DSNV_SODH_CHUAGIAO
AS 
SELECT b.iSoHD ,a.iMaNV,a.sTenNV,c.dNgaygiaohang FROM dbo.tblNhanVien a 
INNER JOIN tramdh2 b ON a.iMaNV = b.iMaNV 
INNER JOIN dbo.tblThongtinGiaohang c ON c.iSoHD = b.iSoHD
WHERE c.dNgaygiaohang > GETDATE()

SELECT * FROM DSNV_SODH_CHUAGIAO











