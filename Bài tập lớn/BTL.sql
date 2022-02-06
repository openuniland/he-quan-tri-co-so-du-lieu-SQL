CREATE DATABASE BTL
ON
(
	NAME = 'BTL',
	FILENAME = 'F:\Learn\SQL_server\BTL.mdf',
	SIZE = 2 MB,
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 10%
)
GO
--dùng DB
USE BTL
GO
-- 1
CREATE TABLE tblTacGia
(
	sMaTG VARCHAR(20) NOT NULL PRIMARY KEY,
	sTenTG NVARCHAR(50) NOT NULL,
	sDiaChi NVARCHAR(100) NOT NULL
)

GO 
--2
CREATE TABLE tblTheLoai
(
	sMaLoai VARCHAR(20) NOT NULL PRIMARY KEY,
	sTheLoai NVARCHAR(70) NOT NULL
)

GO
--3
CREATE TABLE tblNhanVien
(
	sMaNV VARCHAR(20) NOT NULL PRIMARY KEY,
	sTenNV NVARCHAR(50) NOT NULL,
	sDiaChi NVARCHAR(100) NOT NULL,
	dNgaySinh DATE NOT NULL,
	sSDT VARCHAR(10) NOT NULL,
	dNgayVaoLam DATE NOT NULL,
	sCCCD VARCHAR(15)
)

GO
--4
CREATE TABLE tblNhaCungCap
(
	sMaNCC VARCHAR(20) NOT NULL PRIMARY KEY,
	sTenNCC NVARCHAR(50) NOT NULL,
	sDiaChi NVARCHAR(100) NOT NULL,
	sSDT VARCHAR(10) NOT NULL
)

GO
--5
CREATE TABLE tblKhachHang
(
	sMaKH VARCHAR(20) NOT NULL PRIMARY KEY,
	sTenKH NVARCHAR(50),
	sDiaChi NVARCHAR(100),
	dNgaySinh DATE,
	sSDT VARCHAR(10),
)

GO 
--6
CREATE TABLE tblSach
(
	sMaSach VARCHAR(20) NOT NULL PRIMARY KEY,
	sTenSach NVARCHAR(100) NOT NULL,
	fDonGia FLOAT NOT NULL,

	--tạo khóa ngoại ngay khi tạo bảng với điều kiện khóa kia đã được tạo trước
	sMaTG VARCHAR(20) NOT NULL,
	FOREIGN KEY (sMaTG) REFERENCES dbo.tblTacGia(sMaTG),
	sMaLoai VARCHAR(20) NOT NULL,
	FOREIGN KEY (sMaLoai) REFERENCES dbo.tblTheLoai(sMaLoai),
	sMaNCC VARCHAR(20) NOT NULL,
	FOREIGN KEY (sMaNCC) REFERENCES dbo.tblNhaCungCap(sMaNCC)
)

GO
--7
CREATE TABLE tblHoaDon 
(
	sSoHD VARCHAR(20) NOT NULL PRIMARY KEY,

	--tạo khóa ngoại ngay khi tạo bảng với điều kiện khóa kia đã được tạo trước
	sMaNV VARCHAR(20) NOT NULL,
	FOREIGN KEY (sMaNV) REFERENCES dbo.tblNhanVien(sMaNV),
	sMaKH VARCHAR(20) NOT NULL,
	FOREIGN KEY (sMaKH) REFERENCES dbo.tblKhachHang(sMaKH)
)


GO
--8
CREATE TABLE tblDonNhap
(
	sSoHDN VARCHAR(20) NOT NULL PRIMARY KEY,
	fSoLuongNhap FLOAT NOT NULL,

	--tạo khóa ngoại ngay khi tạo bảng với điều kiện khóa kia đã được tạo trước
	sMaNCC VARCHAR(20) NOT NULL,
	FOREIGN KEY (sMaNCC) REFERENCES dbo.tblNhaCungCap(sMaNCC),
	sMaNV VARCHAR(20) NOT NULL,
	FOREIGN KEY (sMaNV) REFERENCES dbo.tblNhanVien(sMaNV)
)

GO
--9
CREATE TABLE tblChiTiet_HD_BanSach 
(
	sSoHD VARCHAR(20) NOT NULL,
	sMaSach VARCHAR(20) NOT NULL,
	fSoLuongMua FLOAT NOT NULL,
	fDonGia FLOAT NOT NULL,

	FOREIGN KEY (sSoHD) REFERENCES dbo.tblHoaDon(sSoHD),
	FOREIGN KEY (sMaSach) REFERENCES dbo.tblSach(sMaSach),
	PRIMARY KEY(sSoHD, sMaSach)

)

GO
--10
CREATE TABLE tblChiTiet_HD_NhapSach
(
	sSoHDN VARCHAR(20) NOT NULL,
	sMaSach VARCHAR(20) NOT NULL,
	fSoLuongNhap FLOAT NOT NULL,

	FOREIGN KEY (sSoHDN) REFERENCES dbo.tblDonNhap(sSoHDN),
	FOREIGN KEY (sMaSach) REFERENCES dbo.tblSach(sMaSach),
	PRIMARY KEY (sSoHDN, sMaSach)
)

-- thêm dữ liệu vào các bảng
-- 1 tác giả
INSERT dbo.tblTacGia
(
    sMaTG,
    sTenTG,
    sDiaChi
)
VALUES
(   'TG1',  -- sMaTG - varchar(20)
    N'Xuân Diệu', -- sTenTG - nvarchar(50)
    N'Ba Đình - Hà Nội'  -- sDiaChi - nvarchar(100)
    )
INSERT dbo.tblTacGia
(
    sMaTG,
    sTenTG,
    sDiaChi
)
VALUES
(   'TG2',  -- sMaTG - varchar(20)
    N'Nguyễn Du', -- sTenTG - nvarchar(50)
    N'Hà Nội'  -- sDiaChi - nvarchar(100)
    )
INSERT dbo.tblTacGia
(
    sMaTG,
    sTenTG,
    sDiaChi
)
VALUES
(   'TG3',  -- sMaTG - varchar(20)
    N'Hồ Xuân Hương', -- sTenTG - nvarchar(50)
    N'Nghệ An'  -- sDiaChi - nvarchar(100)
    )
INSERT dbo.tblTacGia
(
    sMaTG,
    sTenTG,
    sDiaChi
)
VALUES
(   'TG4',  -- sMaTG - varchar(20)
    N'Nguyễn Khuyến', -- sTenTG - nvarchar(50)
    N'Bình Lục - Hà Nam'  -- sDiaChi - nvarchar(100)
    )
INSERT dbo.tblTacGia
(
    sMaTG,
    sTenTG,
    sDiaChi
)
VALUES
(   'TG5',  -- sMaTG - varchar(20)
    N'Huy Cận', -- sTenTG - nvarchar(50)
    N'Hà Nội'  -- sDiaChi - nvarchar(100)
    )
INSERT dbo.tblTacGia
(
    sMaTG,
    sTenTG,
    sDiaChi
)
VALUES
(   'TG6',  -- sMaTG - varchar(20)
    N'Hàn Mặc Tử', -- sTenTG - nvarchar(50)
    N'Đồng Hới - Quảng Bình'  -- sDiaChi - nvarchar(100)
    )
INSERT dbo.tblTacGia
(
    sMaTG,
    sTenTG,
    sDiaChi
)
VALUES
(   'TG7',  -- sMaTG - varchar(20)
    N'Chế Lan Viên', -- sTenTG - nvarchar(50)
    N'Cam Lộ - Quảng Trị'  -- sDiaChi - nvarchar(100)
    )
INSERT dbo.tblTacGia
(
    sMaTG,
    sTenTG,
    sDiaChi
)
VALUES
(   'TG8',  -- sMaTG - varchar(20)
    N'Tố Hữu', -- sTenTG - nvarchar(50)
    N'Quảng Điền - Thừa Thiên Huế'  -- sDiaChi - nvarchar(100)
    )
INSERT dbo.tblTacGia
(
    sMaTG,
    sTenTG,
    sDiaChi
)
VALUES
(   'TG9',  -- sMaTG - varchar(20)
    N'Stephen Hawking', -- sTenTG - nvarchar(50)
    N'Vương Quốc Anh'  -- sDiaChi - nvarchar(100)
    )
INSERT dbo.tblTacGia
(
    sMaTG,
    sTenTG,
    sDiaChi
)
VALUES
(   'TG10',  -- sMaTG - varchar(20)
    N'Fujiko F. Fujio', -- sTenTG - nvarchar(50)
    N'Nhật Bản'  -- sDiaChi - nvarchar(100)
    )
-- 2 thể loại
INSERT dbo.tblTheLoai
(
    sMaLoai,
    sTheLoai
)
VALUES
(   'TL1', -- sMaLoai - varchar(20)
    N'Thơ Trữ Tình' -- sTheLoai - nvarchar(70)
    )
INSERT dbo.tblTheLoai
(
    sMaLoai,
    sTheLoai
)
VALUES
(   'TL2', -- sMaLoai - varchar(20)
    N'Truyện Dân Gian' -- sTheLoai - nvarchar(70)
    )
INSERT dbo.tblTheLoai
(
    sMaLoai,
    sTheLoai
)
VALUES
(   'TL3', -- sMaLoai - varchar(20)
    N'Truyện Hiện Đại' -- sTheLoai - nvarchar(70)
    )
INSERT dbo.tblTheLoai
(
    sMaLoai,
    sTheLoai
)
VALUES
(   'TL4', -- sMaLoai - varchar(20)
    N'Khoa Học' -- sTheLoai - nvarchar(70)
    )
INSERT dbo.tblTheLoai
(
    sMaLoai,
    sTheLoai
)
VALUES
(   'TL5', -- sMaLoai - varchar(20)
    N'Thơ Tự Do' -- sTheLoai - nvarchar(70)
    )
-- 3  nhân viên
INSERT dbo.tblNhanVien
(
    sMaNV,
    sTenNV,
    sDiaChi,
    dNgaySinh,
    sSDT,
    dNgayVaoLam,
    sCCCD
)
VALUES
(   'NV1',        -- sMaNV - varchar(20)
    N'Nguyễn Công Minh',       -- sTenNV - nvarchar(50)
    N'Hoàng Mai - Hà Nội',       -- sDiaChi - nvarchar(100)
    '20011027', -- dNgaySinh - date
    '0327102001',        -- sSDT - varchar(10)
    '20210909', -- dNgayVaoLam - date
    '0213654875'         -- sCCCD - varchar(15)
    )
INSERT dbo.tblNhanVien
(
    sMaNV,
    sTenNV,
    sDiaChi,
    dNgaySinh,
    sSDT,
    dNgayVaoLam,
    sCCCD
)
VALUES
(   'NV2',        -- sMaNV - varchar(20)
    N'Nguyễn Đình Tịnh',       -- sTenNV - nvarchar(50)
    N'Hoàng Mai - Hà Nội',       -- sDiaChi - nvarchar(100)
    '20010101', -- dNgaySinh - date
    '0325482254',        -- sSDT - varchar(10)
    '20210606', -- dNgayVaoLam - date
    '5487955485'         -- sCCCD - varchar(15)
    )
INSERT dbo.tblNhanVien
(
    sMaNV,
    sTenNV,
    sDiaChi,
    dNgaySinh,
    sSDT,
    dNgayVaoLam,
    sCCCD
)
VALUES
(   'NV3',        -- sMaNV - varchar(20)
    N'Trần Văn Ngọc Bảo',       -- sTenNV - nvarchar(50)
    N'Hoàng Mai - Hà Nội',       -- sDiaChi - nvarchar(100)
    '20010908', -- dNgaySinh - date
    '0365425987',        -- sSDT - varchar(10)
    '20201111', -- dNgayVaoLam - date
    '2654569874'         -- sCCCD - varchar(15)
    )
INSERT dbo.tblNhanVien
(
    sMaNV,
    sTenNV,
    sDiaChi,
    dNgaySinh,
    sSDT,
    dNgayVaoLam,
    sCCCD
)
VALUES
(   'NV4',        -- sMaNV - varchar(20)
    N'Trần Văn Nam',       -- sTenNV - nvarchar(50)
    N'Thanh Xuân - Hà Nội',       -- sDiaChi - nvarchar(100)
    '20010530', -- dNgaySinh - date
    '0123521458',        -- sSDT - varchar(10)
    '20200615', -- dNgayVaoLam - date
    '2654895126'         -- sCCCD - varchar(15)
    )
INSERT dbo.tblNhanVien
(
    sMaNV,
    sTenNV,
    sDiaChi,
    dNgaySinh,
    sSDT,
    dNgayVaoLam,
    sCCCD
)
VALUES
(   'NV5',        -- sMaNV - varchar(20)
    N'Hà Đức Hiếu',       -- sTenNV - nvarchar(50)
    N'Hoàng Mai - Hà Nội',       -- sDiaChi - nvarchar(100)
    '20011027', -- dNgaySinh - date
    '0654879445',        -- sSDT - varchar(10)
    '20201215', -- dNgayVaoLam - date
    '1236549584'         -- sCCCD - varchar(15)
    )
-- 4 nhà cung cấp
INSERT dbo.tblNhaCungCap
(
    sMaNCC,
    sTenNCC,
    sDiaChi,
    sSDT
)
VALUES
(   'NCC1',  -- sMaNCC - varchar(20)
    N'Kim Đồng', -- sTenNCC - nvarchar(50)
    N'Hà Nội', -- sDiaChi - nvarchar(100)
    '0312555555'   -- sSDT - varchar(10)
    )
INSERT dbo.tblNhaCungCap
(
    sMaNCC,
    sTenNCC,
    sDiaChi,
    sSDT
)
VALUES
(   'NCC2',  -- sMaNCC - varchar(20)
    N'Trẻ', -- sTenNCC - nvarchar(50)
    N'Hà Nội', -- sDiaChi - nvarchar(100)
    '0365459584'   -- sSDT - varchar(10)
    )
INSERT dbo.tblNhaCungCap
(
    sMaNCC,
    sTenNCC,
    sDiaChi,
    sSDT
)
VALUES
(   'NCC3',  -- sMaNCC - varchar(20)
    N'Giáo Dục', -- sTenNCC - nvarchar(50)
    N'Hà Nội', -- sDiaChi - nvarchar(100)
    '0333398548'   -- sSDT - varchar(10)
    )
INSERT dbo.tblNhaCungCap
(
    sMaNCC,
    sTenNCC,
    sDiaChi,
    sSDT
)
VALUES
(   'NCC4',  -- sMaNCC - varchar(20)
    N'Văn Học', -- sTenNCC - nvarchar(50)
    N'Hà Nội', -- sDiaChi - nvarchar(100)
    '0895848958'   -- sSDT - varchar(10)
    )
INSERT dbo.tblNhaCungCap
(
    sMaNCC,
    sTenNCC,
    sDiaChi,
    sSDT
)
VALUES
(   'NCC5',  -- sMaNCC - varchar(20)
    N'Lao Động', -- sTenNCC - nvarchar(50)
    N'Hà Nội', -- sDiaChi - nvarchar(100)
    '0323236548'   -- sSDT - varchar(10)
    )
-- 5 khách hàng
INSERT dbo.tblKhachHang
(
    sMaKH,
    sTenKH,
    sDiaChi,
    dNgaySinh,
    sSDT
)
VALUES
(   'KH1',        -- sMaKH - varchar(20)
    N'Trần Văn Long',       -- sTenKH - nvarchar(50)
    N'Hà Giang',       -- sDiaChi - nvarchar(100)
    '19990101', -- dNgaySinh - date
    '0125254658'         -- sSDT - varchar(10)
    )
INSERT dbo.tblKhachHang
(
    sMaKH,
    sTenKH,
    sDiaChi,
    dNgaySinh,
    sSDT
)
VALUES
(   'KH2',        -- sMaKH - varchar(20)
    N'Lê Thị Hồng',       -- sTenKH - nvarchar(50)
    N'Ninh Bình',       -- sDiaChi - nvarchar(100)
    '20001015', -- dNgaySinh - date
    '0354952156'         -- sSDT - varchar(10)
    )
INSERT dbo.tblKhachHang
(
    sMaKH,
    sTenKH,
    sDiaChi,
    dNgaySinh,
    sSDT
)
VALUES
(   'KH3',        -- sMaKH - varchar(20)
    N'Trần Quốc Anh',       -- sTenKH - nvarchar(50)
    N'Thanh Hóa',       -- sDiaChi - nvarchar(100)
    '20020505', -- dNgaySinh - date
    '098457585'         -- sSDT - varchar(10)
    )
INSERT dbo.tblKhachHang
(
    sMaKH,
    sTenKH,
    sDiaChi,
    dNgaySinh,
    sSDT
)
VALUES
(   'KH4',        -- sMaKH - varchar(20)
    N'Nguyễn Văn Tùng',       -- sTenKH - nvarchar(50)
    N'Bắc Ninh',       -- sDiaChi - nvarchar(100)
    '19990622', -- dNgaySinh - date
    '0365325458'         -- sSDT - varchar(10)
    )
INSERT dbo.tblKhachHang
(
    sMaKH,
    sTenKH,
    sDiaChi,
    dNgaySinh,
    sSDT
)
VALUES
(   'KH5',        -- sMaKH - varchar(20)
    N'Lê Thi Giang',       -- sTenKH - nvarchar(50)
    N'Hà Nội',       -- sDiaChi - nvarchar(100)
    '19951226', -- dNgaySinh - date
    '0987458965'         -- sSDT - varchar(10)
    )
-- 6 sách
INSERT dbo.tblSach
(
    sMaSach,
    sTenSach,
    fDonGia,
    sMaTG,
    sMaLoai,
    sMaNCC
)
VALUES
(   'S1',  -- sMaSach - varchar(20)
    N'Vội Vàng', -- sTenSach - nvarchar(100)
    120000, -- fDonGia - float
    'TG1',  -- sMaTG - varchar(20)
    'TL5',  -- sMaLoai - varchar(20)
    'NCC5'   -- sMaNCC - varchar(20)
    )
INSERT dbo.tblSach
(
    sMaSach,
    sTenSach,
    fDonGia,
    sMaTG,
    sMaLoai,
    sMaNCC
)
VALUES
(   'S2',  -- sMaSach - varchar(20)
    N'Đây Mùa Thu Tới', -- sTenSach - nvarchar(100)
    75000, -- fDonGia - float
    'TG1',  -- sMaTG - varchar(20)
    'TL5',  -- sMaLoai - varchar(20)
    'NCC5'   -- sMaNCC - varchar(20)
    )
INSERT dbo.tblSach
(
    sMaSach,
    sTenSach,
    fDonGia,
    sMaTG,
    sMaLoai,
    sMaNCC
)
VALUES
(   'S3',  -- sMaSach - varchar(20)
    N'Lược Sử Thời Gian', -- sTenSach - nvarchar(100)
    340000, -- fDonGia - float
    'TG9',  -- sMaTG - varchar(20)
    'TL4',  -- sMaLoai - varchar(20)
    'NCC2'   -- sMaNCC - varchar(20)
    )
INSERT dbo.tblSach
(
    sMaSach,
    sTenSach,
    fDonGia,
    sMaTG,
    sMaLoai,
    sMaNCC
)
VALUES
(   'S4',  -- sMaSach - varchar(20)
    N'Doraemon', -- sTenSach - nvarchar(100)
    24000, -- fDonGia - float
    'TG10',  -- sMaTG - varchar(20)
    'TL3',  -- sMaLoai - varchar(20)
    'NCC1'   -- sMaNCC - varchar(20)
    )
INSERT dbo.tblSach
(
    sMaSach,
    sTenSach,
    fDonGia,
    sMaTG,
    sMaLoai,
    sMaNCC
)
VALUES
(   'S5',  -- sMaSach - varchar(20)
    N'Đoàn Thuyền Đánh Cá', -- sTenSach - nvarchar(100)
    25000, -- fDonGia - float
    'TG5',  -- sMaTG - varchar(20)
    'TL5',  -- sMaLoai - varchar(20)
    'NCC3'   -- sMaNCC - varchar(20)
    )
-- 7 hóa đơn
INSERT dbo.tblHoaDon
VALUES
(   'HD1', -- sSoHD - varchar(20) 
	'NV1', -- sMaNV - varchar(20)
    'KH1'  -- sMaKH - varchar(20)
)
INSERT dbo.tblHoaDon
VALUES
(   'HD2', -- sSoHD - varchar(20) 
	'NV1', -- sMaNV - varchar(20)
    'KH2'  -- sMaKH - varchar(20)
)
INSERT dbo.tblHoaDon
VALUES
(   'HD3', -- sSoHD - varchar(20) 
	'NV2', -- sMaNV - varchar(20)
    'KH3'  -- sMaKH - varchar(20)
)
INSERT dbo.tblHoaDon
VALUES
(   'HD4', -- sSoHD - varchar(20) 
	'NV3', -- sMaNV - varchar(20)
    'KH4'  -- sMaKH - varchar(20)
)
INSERT dbo.tblHoaDon
VALUES
(   'HD5', -- sSoHD - varchar(20) 
	'NV3', -- sMaNV - varchar(20)
    'KH5'  -- sMaKH - varchar(20)
)
--8 đơn nhập
INSERT dbo.tblDonNhap
VALUES
(   'HDN1',  -- sSoHDN - varchar(20)
    20, -- fSoLuongNhap - float
    'NCC1',  -- sMaNCC - varchar(20)
    'NV4'   -- sMaNV - varchar(20)
)
INSERT dbo.tblDonNhap
VALUES
(   'HDN2',  -- sSoHDN - varchar(20)
    15, -- fSoLuongNhap - float
    'NCC2',  -- sMaNCC - varchar(20)
    'NV4'   -- sMaNV - varchar(20)
)
INSERT dbo.tblDonNhap
VALUES
(   'HDN3',  -- sSoHDN - varchar(20)
    35, -- fSoLuongNhap - float
    'NCC3',  -- sMaNCC - varchar(20)
    'NV4'   -- sMaNV - varchar(20)
)
INSERT dbo.tblDonNhap
VALUES
(   'HDN4',  -- sSoHDN - varchar(20)
    50, -- fSoLuongNhap - float
    'NCC4',  -- sMaNCC - varchar(20)
    'NV5'   -- sMaNV - varchar(20)
)
INSERT dbo.tblDonNhap
VALUES
(   'HDN5',  -- sSoHDN - varchar(20)
    10, -- fSoLuongNhap - float
    'NCC5',  -- sMaNCC - varchar(20)
    'NV5'   -- sMaNV - varchar(20)
)
--9 chi tiết hóa đơn bán sách
INSERT dbo.tblChiTiet_HD_BanSach
VALUES
(   'HD1',  -- sSoHD - varchar(20)
    'S1',  -- sMaSach - varchar(20)
    2, -- fSoLuongMua - float
    120000  -- fDonGia - float
)
INSERT dbo.tblChiTiet_HD_BanSach
VALUES
(   'HD2',  -- sSoHD - varchar(20)
    'S2',  -- sMaSach - varchar(20)
    4, -- fSoLuongMua - float
    75000  -- fDonGia - float
)
INSERT dbo.tblChiTiet_HD_BanSach
VALUES
(   'HD3',  -- sSoHD - varchar(20)
    'S3',  -- sMaSach - varchar(20)
    1, -- fSoLuongMua - float
    340000  -- fDonGia - float
)
INSERT dbo.tblChiTiet_HD_BanSach
VALUES
(   'HD4',  -- sSoHD - varchar(20)
    'S4',  -- sMaSach - varchar(20)
    3, -- fSoLuongMua - float
    24000  -- fDonGia - float
)
INSERT dbo.tblChiTiet_HD_BanSach
VALUES
(   'HD5',  -- sSoHD - varchar(20)
    'S5',  -- sMaSach - varchar(20)
    1, -- fSoLuongMua - float
    25000  -- fDonGia - float
)
--10 chi tiết hóa đơn nhập sách
INSERT dbo.tblChiTiet_HD_NhapSach
VALUES
(   'HDN1', -- sSoHDN - varchar(20)
    'S1', -- sMaSach - varchar(20)
    20 -- fSoLuongNhap - float
)
INSERT dbo.tblChiTiet_HD_NhapSach
VALUES
(   'HDN2', -- sSoHDN - varchar(20)
    'S2', -- sMaSach - varchar(20)
    15 -- fSoLuongNhap - float
)
INSERT dbo.tblChiTiet_HD_NhapSach
VALUES
(   'HDN3', -- sSoHDN - varchar(20)
    'S3', -- sMaSach - varchar(20)
    35 -- fSoLuongNhap - float
)
INSERT dbo.tblChiTiet_HD_NhapSach
VALUES
(   'HDN4', -- sSoHDN - varchar(20)
    'S4', -- sMaSach - varchar(20)
    50 -- fSoLuongNhap - float
)
INSERT dbo.tblChiTiet_HD_NhapSach
VALUES
(   'HDN5', -- sSoHDN - varchar(20)
    'S5', -- sMaSach - varchar(20)
    10 -- fSoLuongNhap - float
)

--TẠO CÁC VIEW
--tạo view cho biết số lượng nhân viên
CREATE VIEW SoLuongNhanVien
AS
SELECT COUNT(sMaNV) AS N'Số Lượng Nhân Viên'
FROM dbo.tblNhanVien

SELECT * FROM SoLuongNhanVien

--tạo view cho biết các sách đang dược bán
CREATE VIEW SachDangBan
AS
SELECT sMaSach, sTenSach, fDonGia
FROM dbo.tblSach

SELECT * FROM SachDangBan

--tạo view cho biết số lượng sách trong cửa hàng
CREATE VIEW TongSoSach
AS
SELECT SUM(fSoLuongNhap) AS N'Tổng số sách trong cửa hàng'
FROM dbo.tblSach
INNER JOIN dbo.tblChiTiet_HD_NhapSach
ON tblSach.sMaSach = tblChiTiet_HD_NhapSach.sMaSach

SELECT * FROM TongSoSach

--tạo view tính tổng số tiền nhập sách
CREATE VIEW TongSoTienNhap
AS
SELECT SUM(fSoLuongNhap * fDonGia) AS N'Tổng số tiền nhập sách'
FROM dbo.tblSach
INNER JOIN dbo.tblChiTiet_HD_NhapSach
ON tblSach.sMaSach = tblChiTiet_HD_NhapSach.sMaSach

SELECT * FROM TongSoTienNhap

-- tạo view xem số lượng của từng loại sách
CREATE VIEW SoLuongTungLoaiSach
AS
SELECT tblSach.sMaSach, sTenSach, fSoLuongNhap
FROM dbo.tblSach
INNER JOIN dbo.tblChiTiet_HD_NhapSach
ON tblSach.sMaSach = tblChiTiet_HD_NhapSach.sMaSach

SELECT * FROM SoLuongTungLoaiSach

-- tạo view cho biết số tiền phải trả cho từng hóa đơn mua
CREATE VIEW SoTienPhaiTraTheoHD
AS
SELECT sSoHD, SUM(fSoLuongMua*fDonGia) AS N'Tổng tiền'
FROM dbo.tblChiTiet_HD_BanSach
GROUP BY sSoHD

SELECT * FROM SoTienPhaiTraTheoHD

--TẠO CÁC PROC
--tạo thủ tục có tham số truyền vào là năm cho biết năm đó những nhân viên nào vào làm
CREATE PROC ProNam
@nam INT
AS
BEGIN 
	SELECT * FROM dbo.tblNhanVien WHERE YEAR(dNgayVaoLam) = @nam
END

EXEC ProNam 2020

--tạo thủ tục có tham số truyền vào là mã nhà cung cấp xem nhà cung cấp đó cửa hàng nhập bao nhiêu sách
CREATE PROC ProNCC
@NCC VARCHAR(20)
AS 
BEGIN
	SELECT sMaNCC, fSoLuongNhap FROM dbo.tblDonNhap WHERE sMaNCC = @NCC
END 

EXEC ProNCC 'NCC5'
GO 
--TẠO CÁC TRIGGER
--tạo trigger chỉ được nhập dưới 50 sách một lần

CREATE TRIGGER TRIGGER_NhapDuoi50
ON dbo.tblDonNhap
INSTEAD OF INSERT 
AS 
BEGIN 
	DECLARE @soluong FLOAT
	SELECT @soluong = Inserted.fSoLuongNhap FROM Inserted
	IF(@soluong > 50)
	PRINT N'Không được nhập quá 50'
	ROLLBACK
END 
GO 
-- test insert lớn hơn 50
INSERT dbo.tblDonNhap
VALUES
(   'HDN6',  -- sSoHDN - varchar(20)
    55, -- fSoLuongNhap - float
    'NCC1',  -- sMaNCC - varchar(20)
    'NV4'   -- sMaNV - varchar(20)
)
GO 
--Phân quyền và bảo mật CSDL
-- 1. tạo người dùng và mật khẩu
CREATE LOGIN nguyencongminh
WITH PASSWORD = '1111',
DEFAULT_DATABASE = BTL;
CREATE USER nguyencongminh
FOR LOGIN nguyencongminh;
GO 

CREATE LOGIN trannguyenanh
WITH PASSWORD = '1111',
DEFAULT_DATABASE = BTL;
CREATE USER trannguyenanh
FOR LOGIN trannguyenanh;

GO 

CREATE LOGIN doquochuy
WITH PASSWORD = '1111',
DEFAULT_DATABASE = BTL;
CREATE USER doquochuy
FOR LOGIN doquochuy;

GO

CREATE LOGIN daohongngoc
WITH PASSWORD = '1111',
DEFAULT_DATABASE = BTL;
CREATE USER daohongngoc
FOR LOGIN daohongngoc;

-- 2. phân quyền
-- GÁN QUYỀN NGƯỜI DÙNG SỬ DỤNG
-- cấp phát cho người dùng tên nguyencongminh quyền thực thi tất cả trên bảng tblSach
GRANT ALL PRIVILEGES
ON dbo.tblSach
TO nguyencongminh;

-- cấp phát cho người dùng tên trannguyenanh quyền select, update, insert, references trên bảng tblKhachHang
-- và chuyển tiếp cho người dùng khác
GRANT SELECT, UPDATE, INSERT, DELETE, REFERENCES
ON dbo.tblKhachHang
TO trannguyenanh
WITH GRANT OPTION;

-- cấp phát cho người dùng tên doquochuy quyền tạo bảng, khung nhìn, thủ tục
GRANT CREATE TABLE, CREATE VIEW, CREATE PROCEDURE
TO doquochuy;

-- cấp phát cho người dùng tên daohongngoc quyền select, execute, delete trên tblHoaDon
GRANT SELECT, EXECUTE, DELETE
ON dbo.tblHoaDon
TO daohongngoc;

GRANT ALL ON dbo.tblSach TO server1

-- Phân tán dữ liệu
-- 1 phân tán các nhân viên trên 25 tuổi qua server2
-- truy vấn đến server2
select * from LINK.BTL.dbo.tblNhanVien

-- 2 tạo view xem tất cả nhân viên của 2 server
CREATE VIEW XemTatCaNV
AS 
SELECT *
FROM dbo.tblNhanVien 
UNION
SELECT *
FROM LINK.BTL.dbo.tblNhanVien


-- xem view
SELECT * FROM XemTatCaNV

-- ORDER BY __ ASC //  DESC
-- full outer join


-- phân tán: danh sách nhân viên đi làm từ 2020
CREATE VIEW XEMNV2020
AS
SELECT *
FROM dbo.tblNhanVien WHERE YEAR(dNgayVaoLam) = '2020'
UNION
SELECT *
FROM LINK.BTL.dbo.tblNhanVien WHERE YEAR(dNgayVaoLam) = '2020'

SELECT * FROM XEMNV2020

SELECT * FROM dbo.tblNhanVien
SELECT *
FROM LINK.BTL.dbo.tblNhanVien

-- tạo proc truyền vào mã kh, năm

CREATE PROC TenSachKHMua
@makh VARCHAR(20), @nam int
AS
BEGIN
	SELECT sTenSach FROM dbo.tblSach
END

EXEC TenSachKHMua 'KH1', 2020

DROP PROC TenSachKHMua


ALTER TABLE dbo.tblHoaDon ADD fNam INT

-- TẠO NGƯỜI DÙNG user06

CREATE LOGIN user06
WITH PASSWORD = '1111',
DEFAULT_DATABASE = BTL;
CREATE USER user06
FOR LOGIN user06;
-- phân quyền
GRANT execute
ON TenSachKHMua
TO user06;

EXEC TenSachKHMua 'KH1', 2020

SELECT sTenSach FROM dbo.tblSach