--Họ và Tên: Nguyễn Công Minh
--Tên lớp: 1910a03
CREATE DATABASE TH_Buoi1
ON
(
	NAME = 'TH_Buoi1',
	FILENAME = 'D:\Learn\SQL_server\TH_Buoi1.mdf',
	SIZE = 2 MB,
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 10%
)
GO
--dùng DB
USE TH_Buoi1
GO

--tạo bảng
CREATE TABLE tblLoaiHang
(
sMaloaihang NVARCHAR(10) NOT NULL,
sTenloaihang NVARCHAR(10) NOT NULL
)

-- thêm khóa chính và thêm tên cho khóa từ bên ngoài
ALTER TABLE tblLoaiHang ADD CONSTRAINT PK_sMaloaihang PRIMARY KEY(sMaloaihang);

--tạo bảng
CREATE TABLE tblNhaCungCap
(
iMaNCC int IDENTITY(1,1) NOT NULL,
sTenNhaCC NVARCHAR(50) NULL,
sTengiaodich NVARCHAR(50) NULL,
sDiachi NVARCHAR(50) NULL,
sDienthoai NVARCHAR(12) NULL,
--thêm tên khóa chính từ bên trong
CONSTRAINT PK_tblNhaCungCap PRIMARY KEY (iMaNCC)
)

--tạo bảng
CREATE TABLE tblMatHang
(
sMahang NVARCHAR(10) NOT NULL,
sTenhang NVARCHAR(30) NOT NULL,
iMaNCC INT NULL ,
sMaloaihang NVARCHAR(10) NULL,
fSoluong FLOAT NULL,
fGiahang FLOAT NULL
)

-- thêm khóa chính và khóa ngoại
ALTER TABLE tblMatHang
ADD CONSTRAINT PK_mathang PRIMARY KEY (sMahang),
CONSTRAINT FK_mathang_loaihang FOREIGN KEY (sMaloaihang)
REFERENCES tblLoaiHang(sMaloaihang),
CONSTRAINT FK_mathang_nhacungcap FOREIGN KEY (iMaNCC)
REFERENCES tblNhaCungCap(iMaNCC)

--phần làm theo yêu cầu

--bài 1.1
-- a: done
-- b: tạo bảng KhachHang và NhanVien

CREATE TABLE tblKhachHang
(
	iMaKH INT NOT NULL,
	sTenKH NVARCHAR(30) NOT NULL,
	dNgaySinh DATE NOT NULL,
	sDiaChi NVARCHAR(50) NOT NULL,
	sDienThoai VARCHAR(12) NOT NULL
)
GO

CREATE TABLE tblNhanVien
(
	iMaNV INT NOT NULL,
	sTenNV NVARCHAR(30) NOT NULL,
	sDiaChi NVARCHAR(50) NOT NULL,
	sDienThoai VARCHAR(12) NOT NULL,
	dNgaySinh DATETIME NOT NULL,
	dNgayVaoLam DATETIME NOT NULL,
	fLuongCoBan FLOAT NOT NULL,
	fPhuCap FLOAT NOT NULL
)

--c: thêm sCMND không trùng nhau vào bảng nhân viên
ALTER TABLE dbo.tblNhanVien ADD sCMND INT UNIQUE

--d: thiết lập ràng buộc khóa chính và khóa ngoại cho hai bảng trên
ALTER TABLE dbo.tblKhachHang ADD PRIMARY KEY (iMaKH)
ALTER TABLE dbo.tblNhanVien ADD PRIMARY KEY (iMaNV)

--e: thiết lập ngày vào làm việc với ngày sinh đủ 18 tuổi
ALTER TABLE dbo.tblNhanVien ADD CHECK (DATEDIFF(YEAR, dNgaySinh, dNgayVaoLam) >= 18)

--f: thêm cột sDonViTinh cho bảng mặt hàng
ALTER TABLE dbo.tblMatHang ADD sDonViTinh VARCHAR(10)

--g: tạo chỉ mục cho cột sTenHang trong bảng tblMatHang
CREATE INDEX index_TenHang ON dbo.tblMatHang (sTenhang)

--bài 1.2
--a: tạo bảng tblDonNhapHang và bảng tblChiTietNhapHang
CREATE TABLE tblDonNhapHang
(
	iSoHD INT NOT NULL,
	iMaNV INT NOT NULL,
	dNgayNhapHang DATETIME NOT NULL
)

CREATE TABLE tblChiTietNhapHang
(
	iSoHD INT NOT NULL,
	sMaHang NVARCHAR(10) NOT NULL,
	fGiaNhap FLOAT NOT NULL,
	fSoLuongNhap FLOAT NOT NULL
)

--b: thiết lập khóa chính khóa ngoại
ALTER TABLE dbo.tblDonNhapHang ADD PRIMARY KEY (iSoHD)

ALTER TABLE dbo.tblChiTietNhapHang ADD CONSTRAINT FK_MaHang FOREIGN KEY(sMaHang) REFERENCES dbo.tblMatHang(sMahang)
ALTER TABLE dbo.tblChiTietNhapHang ADD CONSTRAINT FK_SoHD FOREIGN KEY(iSoHD) REFERENCES dbo.tblDonNhapHang(iSoHD)

--c: fGiaNhap, fSoLuongNhap > 0
ALTER TABLE dbo.tblChiTietNhapHang ADD CHECK(fGiaNhap > 0)
ALTER TABLE dbo.tblChiTietNhapHang ADD CHECK(fSoLuongNhap > 0)

--bài 1.3
--a: thêm trường bGioiTinh(bit) vào bảng tblKhachHang
ALTER TABLE dbo.tblMatHang ADD bGioiTinh BIT NOT NULL

--b: tạo bảng tblDonDatHang 
-- dNgayGiaoHang >= dNgayDatHang
-- dNgayDatHang = getdate()

CREATE TABLE tblDonDatHang 
(
	iSoHD INT PRIMARY KEY NOT NULL,
	iMaNV INT NOT NULL,
	iMaKH INT NOT NULL,
	dNgayDatHang DATETIME DEFAULT GETDATE(),
	dNgayGiaoHang DATETIME NOT NULL, 
	sDiaChiGiaoHang NVARCHAR(50) NOT NULL,

	CHECK (dNgayGiaoHang >= dNgayDatHang),
	CHECK (dNgayDatHang <= GETDATE())
)

--c: tạo khóa ngoại trường iMaKH ở tblDonDatHang tham chiếu tới tblKhachHang
ALTER TABLE dbo.tblDonDatHang ADD CONSTRAINT FK_MaKH FOREIGN KEY (iMaKH) REFERENCES dbo.tblKhachHang(iMaKH)

--d: tạo khóa ngoại trường iMaNV ở tblDonDatHang tham chiếu tới tblNhanVien
ALTER TABLE dbo.tblDonDatHang ADD CONSTRAINT FK_MaNV FOREIGN KEY (iMaNV) REFERENCES dbo.tblNhanVien(iMaNV)

--bài 1.4
--a: tạo bảng tblChiTietDatHang 
CREATE TABLE tblChiTietDatHang
(
	iSoHD INT NOT NULL,
	sMaHang NVARCHAR(20) NOT NULL,
	fGiaBan FLOAT NOT NULL,
	fSoLuongMua FLOAT NOT NULL,
	fMucGiamGia FLOAT NOT NULL
)

--b: Trong bảng tblChiTietDatHang, sửa cấu trúc trường sMaHang sang kiểu Kí tự có độ dài 10.
ALTER TABLE dbo.tblChiTietDatHang ALTER COLUMN sMaHang NVARCHAR(10) NOT NULL

--c: Trong tblChiTietDatHang, đặt sMaHang làm khoá ngoại,tham chiếu tblMatHang / đặt iSoHD làm khoá ngoại, tham chiếu sang tblDonDatHang
ALTER TABLE dbo.tblChiTietDatHang ADD CONSTRAINT FK_MaHang_CTDH FOREIGN KEY (sMaHang) REFERENCES dbo.tblMatHang(sMahang)
ALTER TABLE dbo.tblChiTietDatHang ADD CONSTRAINT FK_SoHD_CTDH FOREIGN KEY (iSoHD) REFERENCES dbo.tblDonDatHang(iSoHD)

--d: Trong bảng tblChiTietDatHang, đặt khoá chính trên cặp trường {iSoHD,sMaHang}
ALTER TABLE dbo.tblChiTietDatHang ADD CONSTRAINT PK_ChiTietDatHang PRIMARY KEY (iSoHD, sMaHang)


--e: Trong bảng tblChiTietDatHang, đảm bảo rằng: fGiaban>0, fSoluongMua>0, fMucgiamgia>=0
ALTER TABLE dbo.tblChiTietDatHang ADD CHECK(fGiaBan > 0)
ALTER TABLE dbo.tblChiTietDatHang ADD CHECK(fSoLuongMua > 0)
ALTER TABLE dbo.tblChiTietDatHang ADD CHECK(fMucGiamGia > 0)

--ĐÃ HOÀN THÀNH <3