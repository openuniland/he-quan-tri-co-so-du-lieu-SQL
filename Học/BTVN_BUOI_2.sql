
--tạo data và tạo các bảng
CREATE DATABASE BT_BUOI2
ON
(
	NAME = 'BT_BUOI2',
	FILENAME = 'D:\Learn\SQL_server\BT_BUOI2.mdf',
	SIZE = 2 MB,
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 10%
)
GO
USE BT_BUOI2
GO

CREATE TABLE Khoa
(
	--tên khoa không trùng thêm unique
	MaK CHAR(10) PRIMARY KEY NOT NULL,
	TenKhoa NVARCHAR(20) UNIQUE NOT NULL,
	SDT TEXT NOT NULL,
	DiaChi TEXT NOT NULL
)
GO

CREATE TABLE Lop
(
	MaLop CHAR(10) PRIMARY KEY NOT NULL,
	TenLop NVARCHAR(20) UNIQUE NOT NULL,

	MaK CHAR(10) NOT NULL,
	FOREIGN KEY (MaK) REFERENCES dbo.Khoa(MaK)
)
GO

CREATE TABLE SinhVien
(
	MaSV CHAR(10) PRIMARY KEY NOT NULL,
	TenSV NVARCHAR(20) NOT NULL,
	GioiTinh NVARCHAR(3) NOT NULL,
	--kiểm tra sinh viên trên 18 tuổi
	NgaySinh DATE CHECK ((YEAR(GETDATE()) - YEAR(NgaySinh)) >= 18)  NOT NUlL,

	MaLop CHAR(10) NOT NULL,
	FOREIGN KEY (MaLop) REFERENCES dbo.Lop(MaLop)
)
GO

CREATE TABLE Mon
(
	MaM CHAR(10) PRIMARY KEY NOT NULL,
	TenM NVARCHAR(20) NOT NULL,
	SoTC INT CHECK(SoTC <= 5) NOT NUlL
)
GO

CREATE TABLE Diem
(
	MaSV CHAR(10) NOT NULL,
	MaM CHAR(10) NOT NULL,
	NgayHoc DATE NOT NULL,
	DiemCC FLOAT NOT NUlL,
	DiemGiuaKi FLOAT NOT NULL,
	DiemThi FLOAT CHECK(DiemThi Between 0 and 10) NOT NULL

	FOREIGN KEY (MaSV) REFERENCES dbo.SinhVien(MaSV),
	FOREIGN KEY (MaM) REFERENCES dbo.Mon(MaM)
)	
GO

--thêm dữ liệu
INSERT dbo.Khoa
VALUES
(   'ktruc',  -- MaK - char(10)
    N'Kiến Trúc', -- TenKhoa - nvarchar(20)
    '9876',  -- SDT - text
    N'Ngọc Hồi - Thanh Trì - Hà Nội'   -- DiaChi - text
)

INSERT dbo.Lop
VALUES
(   'lop6',  -- MaLop - char(10)
    N'kt01', -- TenLop - nvarchar(20)
    'kt'   -- MaK - char(10)
)

INSERT dbo.SinhVien
VALUES
(   'it008',        -- MaSV - char(10)
    N'Lê Ánh Hồng',       -- TenSV - nvarchar(20)
    N'Nữ',       -- GioiTinh - nvarchar(3)
    '1999-01-02', -- NgaySinh - date
    'lop6'         -- MaLop - char(10)
)

INSERT dbo.Mon
VALUES
(   'gt1',  -- MaM - char(10)
    N'Giải tích 1', -- TenM - nvarchar(20)
    3    -- SoTC - int
)

INSERT dbo.Diem
VALUES
(   'it005',        -- MaSV - char(10)
    'csdl',        -- MaM - char(10)
    GETDATE(), -- NgayHoc - date
    8,       -- DiemCC - float
    5,       -- DiemGiuaKi - float
    5        -- DiemThi - float
)

-- câu 1: cho biết số lượng sinh viên của từng lớp
SELECT TenLop, COUNT(MaSV) AS 'Số sinh viên' FROM dbo.Lop, dbo.SinhVien
WHERE dbo.SinhVien.MaLop = dbo.Lop.MaLop
GROUP BY TenLop

-- câu 2: cho biết số lượng sinh viên nữ của từng khoa: tên khoa, số nữ
SELECT *  FROM dbo.SinhVien, dbo.Khoa, dbo.Lop
WHERE dbo.Khoa.MaK = dbo.Lop.MaK
AND dbo.Lop.MaLop = dbo.SinhVien.MaLop
AND dbo.SinhVien.GioiTinh = N'Nữ'

-- câu 3: cho biết số lượng môn có tín chỉ > 3
SELECT COUNT(dbo.Mon.TenM) AS 'Số môn có lượng tín > 3' FROM dbo.Mon
WHERE dbo.Mon.SoTC > 3

--cho biết những khoa nào có số sinh viên nữ > 100
SELECT DISTINCT dbo.Khoa.TenKhoa FROM dbo.Khoa, dbo.SinhVien, dbo.Lop
WHERE dbo.Khoa.MaK = dbo.Lop.MaK
AND dbo.Lop.MaLop = dbo.SinhVien.MaLop
AND GioiTinh = N'Nữ'
AND COUNT(dbo.SinhVien.MaSV) > 100

GROUP BY dbo.SinhVien.MaSV

--cho biết môn nào không có sinh viên học
SELECT DISTINCT TenM, dbo.SinhVien.TenSV FROM dbo.Mon, dbo.SinhVien, dbo.Diem
WHERE dbo.Diem.MaM = dbo.Mon.MaM
AND dbo.Diem.MaSV = dbo.SinhVien.TenSV

--câu 7: lấy ra tên sinh viên có điểm cao nhất môn cơ sở dữ liệu
SELECT MAX(DiemThi) FROM dbo.Diem, dbo.SinhVien, dbo.Mon
WHERE dbo.Mon.MaM = 'csdl'
AND dbo.Mon.MaM = dbo.Diem.MaM
AND Diem.MaSV = dbo.SinhVien.MaSV SELECT * FROM dbo.SinhVien

