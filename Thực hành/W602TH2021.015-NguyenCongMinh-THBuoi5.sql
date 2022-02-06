-- Nguyễn Công Minh, lớp: 1910a03, lớp tín chỉ: W602TH2021.015
USE ThucHanhSQL
GO

				/*----- Buổi 5 ------*/
--5.1
-- a. Tạo tài khoản đăng nhập SQL Server có tên ‘Capnhat’

CREATE LOGIN Capnhat
WITH PASSWORD = '123456'

-- b. Tạo user trong DB tương ứng với login ‘Capnhat’ và thực hiện cấp quyền Insert, Update, Delete.

CREATE USER Capnhat
FOR LOGIN Capnhat

GRANT INSERT , UPDATE , DELETE TO Capnhat

-- c. Kiểm trả kết quả phân quyền bằng việc thực hiện lệnh Select, Insert trên bảng bất kì.
SELECT * FROM dbo.tblKhachHang


			/*------ 5.2 ------*/
--a. Tạo user đăng nhập SQL Server có tên “BanHang” và thực hiện cấp
--quyền Insert trên bảng tblDONDATHANG và tblCHITIETDATHANG
CREATE LOGIN BanHang
WITH PASSWORD = '123456'

CREATE USER BanHang
FOR LOGIN BanHang

GRANT INSERT ON dbo.tblDonDatHang TO BanHang

GRANT INSERT ON dbo.tblChiTietDatHang TO BanHang

--b. Tạo user và cấp quyển thực thi thủ tục ở “Bài 4.2”

GRANT EXECUTE ON thembanghi -- thêm 1 đơn đặt hàng 
TO BanHang
-- demo 
EXEC thembanghi @sohd =1 ,@manv = 1,@makh =  1 ,@ngaydat = '20211006',@ngaygiao = '20211007' ,@diachi = N'Hà Nội'
--

GRANT EXECUTE ON cungcaphang -- cung cấp hàng với tên ncc và năm cấp
TO BanHang
-- demo 
EXEC cungcaphang @ten = N'Nguyễn Công Minh' , @nam = 2021
--

GRANT EXECUTE ON timNCCvaNgaynhapcuamathang  -- tìm theo tên hàng
TO BanHang
--demo 
EXEC timNCCvaNgaynhapcuamathang @tenhang = N'ao'

-- c.Chỉnh sửa quyền của người dùng ở ý b thêm quyền xem thông tin của bảng tblMATHANG ( user bán hàng)

GRANT SELECT ON dbo.tblMatHang TO BanHang

			/*--------- Bài 5.3 -----------*/

--a. Tạo 1 tài khoản SQL server login với tên truy cập “U1” và mật khẩu là “p123abc”.

CREATE LOGIN U1
WITH PASSWORD = 'p123abc'

--b. Tạo 1 user trong DB của bài tập này cho U1.

CREATE USER U1
FOR LOGIN U1

--c. Cho phép cho U1 được toàn quyền trên bảng tblKhachHang

GRANT ALL ON dbo.tblKhachHang TO U1

/*d. 
	Tạo Role có tên “BPNhapHang” và cấp quyền:
	○1. Được Thêm và Xem dữ liệu của tblNhaCungCap,
	tblDonNhapHang, tblChiTietNhapHang
	○2. Được Xem dữ liệu của tblNhanvien, tblMatHang
	○3. Cấm Thêm, Sửa, Xoá trên bảng tblKhachHang
*/

CREATE ROLE BPNhapHang
-- o1

GRANT SELECT , INSERT ON dbo.tblNhaCungCap TO BPNhapHang
GRANT SELECT , INSERT ON dbo.tblDonnhaphang TO BPNhapHang
GRANT SELECT , INSERT ON dbo.tblChiTietNhapHang TO BPNhapHang

--o2

GRANT SELECT ON dbo.tblNhanVien TO BPNhapHang
GRANT SELECT ON dbo.tblMatHang TO BPNhapHang

--o3

DENY INSERT , UPDATE , DELETE ON dbo.tblKhachHang TO BPNhapHang

/*
e. Đưa U1 vào làm thành viên của role BPNhapHang. Kiểm tra kết quả phân
quyền bằng việc:
	○1. Thêm 1 đơn nhập hàng với 3 mặt hàng cần nhập (bất kì)
	○2. Thêm 1 Khách hàng bất kì
*/
-- add mem cho role
EXECUTE sys.sp_addrolemember @rolename = 'BPNhapHang',  -- sysname
                             @membername = 'U1' -- sysname

--o1. 

INSERT INTO dbo.tblDonnhaphang(iSoHD,iMaNV,dNgaynhaphang)
VALUES (3,5,GETDATE())

INSERT INTO dbo.tblChiTietNhapHang(iSoHD,sMahang,fGianhap,fSoluongnhap)
VALUES (3,'005',10,50)

INSERT INTO dbo.tblChiTietNhapHang(iSoHD,sMahang,fGianhap,fSoluongnhap)
VALUES (3,'004',10,50)

INSERT INTO dbo.tblChiTietNhapHang(iSoHD,sMahang,fGianhap,fSoluongnhap)
VALUES (3,'007',10,50)

--o2.
INSERT INTO dbo.tblKhachHang (iMaKH,sTenKH,dNgaysinh,sDiachi,sDienthoai,bGioitinh,tongtienhang)
VALUES (7,N'lê quang nhã','19900101',N'quận 3 , TPHCM','19001900','nam',0)


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
ALTER TABLE dbo.phantankhachhang ADD CONSTRAINT CK_diachi CHECK (sdiachi LIKE N'%Hà Nội%')

INSERT INTO tram1 SELECT *FROM dbo.tblKhachHang WHERE sdiachi LIKE N'Hà Nội'


CREATE SYNONYM tram1 FOR dbo.phantankhachhang -- dat tram1 la may chu 
CREATE SYNONYM tram2 FOR LINK.BTTHPHANTAN.dbo.phantankhachhang -- tram 2 la may ao

INSERT INTO tram2 SELECT *FROM dbo.tblKhachHang WHERE sdiachi NOT LIKE N'Hà Nội'


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
    IF @diachi LIKE N'%Hà Nội%'
		BEGIN
			INSERT INTO dbo.phantankhachhang SELECT * FROM dbo.tblKhachHang
			WHERE iMaKH NOT IN (SELECT iMaKH FROM dbo.phantankhachhang) AND sDiachi LIKE N'%Hà Nội%'
		END
	ELSE
		BEGIN
		    INSERT INTO tram2 SELECT * FROM dbo.tblKhachHang
			WHERE iMaKH NOT IN (SELECT iMaKH FROM tram2) AND sDiachi NOT LIKE N'%Hà Nội%'
		END
END
SELECT * FROM dbo.tblKhachHang 
SELECT * FROM tram1
SELECT * FROM tram2
DELETE dbo.tblKhachHang WHERE iMaKH = 7
EXECUTE ADDKH	@ma = 7,
				@ten = N'Hoàng Văn Hùng',
				@ngaysinh = '19990201',
				@diachi = 'Hà Nội',
				@dienthoai = '1280',
				@gioitinh = 0,
				@tongtienhang = 0.0



