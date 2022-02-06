--Nguyễn Công Minh - 1910a03

USE TH_Buoi1_
GO
/*
Bài 3.1
a. Cho biết những mặt hàng nào có số lượng dưới 100 (tblMatHang).
b. Tạo View số mặt hàng của từng loại hàng.
c. Cho biết số tiền phải trả của từng đơn đặt hàng.
d. Cho biết tổng số tiền hàng thu được trong mỗi tháng của năm 2016 (tính
theo ngày đặt hàng).
e. Trong năm 2016, những mặt hàng nào chỉ được đặt mua đúng một lần.
*/
--a
SELECT * FROM dbo.tblMatHang WHERE fSoluong < 100
--b
CREATE VIEW SoMatHang AS 
SELECT a1.sMaloaihang , COUNT(a1.sMaloaihang) AS soluongmathang
FROM dbo.tblLoaiHang AS a1 , dbo.tblMatHang AS a2
WHERE a1.sMaloaihang = a2.sMaloaihang GROUP BY a1.sMaloaihang

--c

SELECT COUNT(iSoHD) AS tongsoluong,sMahang , ((fGiaban * fSoluongmua) - (fGiaban * fMucgiamgia)) AS tienthanhtoan  FROM dbo.tblChiTietDatHang 
GROUP BY sMahang , ((fGiaban * fSoluongmua) - (fGiaban * fMucgiamgia)) 
SELECT * FROM dbo.tblChiTietDatHang

-- d
SELECT SUM(((fGiaban * fSoluongmua) - (fGiaban * fMucgiamgia)) ) AS tongtien 
FROM dbo.tblDonDatHang , dbo.tblChiTietDatHang WHERE YEAR(dNgaydathang) = 2016 AND MONTH(dNgaydathang) = 8


INSERT INTO dbo.tblChiTietDatHang VALUES(1,'001',3.0,20,0.0 )
INSERT INTO dbo.tblChiTietDatHang VALUES ( 2,'002',5.0,210,1.0)
INSERT INTO dbo.tblChiTietDatHang VALUES ( 3,'002',6.0,220,1.0)
INSERT INTO dbo.tblChiTietDatHang VALUES ( 4,'004',3.0,60,0.0)
INSERT INTO dbo.tblChiTietDatHang VALUES ( 5,'001',1.0,90,0.0)
INSERT INTO dbo.tblChiTietDatHang VALUES ( 6,'005',8.0,110,1.0)
INSERT INTO dbo.tblChiTietDatHang VALUES ( 7,'006',7.0,20,0.0)

-- e. Trong năm 2016, những mặt hàng nào chỉ được đặt mua đúng một lần.
SELECT * FROM dbo.tblDonDatHang 
SELECT * FROM dbo.tblChiTietDatHang
SELECT * FROM dbo.tblMatHang
---Mệnh đề HAVING được dùng kết hợp với mệnh đề GROUP BY trong SQL Server
--(Transact-SQL) để giới hạn nhóm các hàng trả về, chỉ khi điều kiện được được đáp ứng là TRUE.
SELECT sMahang  FROM dbo.tblChiTietDatHang , dbo.tblDonDatHang WHERE tblChiTietDatHang.iSoHD = tblDonDatHang.iSoHD 
AND YEAR(dNgaydathang) = 2016
GROUP BY sMahang HAVING COUNT(sMahang) = 1
--- cách 2
SELECT sTenhang , tblChiTietDatHang.sMahang  FROM dbo.tblChiTietDatHang INNER JOIN dbo.tblDonDatHang ON tblDonDatHang.iSoHD = tblChiTietDatHang.iSoHD JOIN dbo.tblMatHang ON tblMatHang.sMahang = tblChiTietDatHang.sMahang
WHERE  YEAR(dNgaydathang) = 2021 GROUP BY sTenhang , tblChiTietDatHang.sMahang  HAVING  COUNT(tblChiTietDatHang.sMahang) = 1 


/*
Bài 3.2
a. Tạo View tính tổng tiền hàng và tổng số mặt hàng của từng đơn nhập
hàng
b. Cho biết danh sách tên các mặt hàng mà không được nhập về trong tháng 6 năm 2017
c. Cho biết tên nhà cung cấp đã cung cấp những mặt hàng thuộc một loại
hàng xác định nào đó (phụ thuộc dữ liệu nhập vào - Ví dụ: Máy xách tay)
d. Tạo View cho biết số lượng đã bán của từng loại hàng trong năm 2016
e. Cho biết tổng số tiền hàng đã bán được của từng nhân viên trong năm 2016	
*/
--a 
CREATE VIEW tienhang_mathang_donnhap  AS 
SELECT COUNT(sMahang) AS tongmathang, SUM((fGianhap)*(fSoluongnhap)) AS tongtienhang FROM dbo.tblChiTietNhapHang 

-- b

SELECT sMahang FROM dbo.tblMatHang WHERE sMahang NOT IN 
( SELECT sMahang FROM dbo.tblChiTietNhapHang )
 
 -- c
 SELECT sTenhang , iMaNCC FROM dbo.tblMatHang WHERE iMaNCC IN 
 (SELECT iMaNCC FROM dbo.tblNhaCungCap )
 
 -- d chưa chạy =)) nào thực hành mới chạy
 CREATE VIEW soluonghangdaban_2016_chitietdathang AS 
 SELECT DISTINCT sMahang , fSoluongmua AS soluongdaban FROM dbo.tblChiTietDatHang , dbo.tblDonDatHang WHERE YEAR(dNgaydathang) = 2016
 -- WHERE sMahang IN (SELECT sMahang FROM dbo.tblMatHang )
 
 -- e
SELECT (((fGiaban)*(fSoluongmua)) - ((fGiaban*fSoluongmua) * fMucgiamgia)) AS tongtienbanduoc 
FROM dbo.tblNhanVien , dbo.tblDonDatHang , dbo.tblChiTietDatHang WHERE tblNhanVien.iMaNV = tblDonDatHang.iMaNV
AND tblDonDatHang.iSoHD = tblChiTietDatHang.iSoHD

SELECT tblDonDatHang.iMaNV, SUM (((fGiaban)*(fSoluongmua))- ((fGiaban*fSoluongmua) * fMucgiamgia / 100))   AS tongtienbanduoc 
FROM dbo.tblNhanVien , dbo.tblDonDatHang , dbo.tblChiTietDatHang WHERE tblNhanVien.iMaNV = tblDonDatHang.iMaNV
AND tblDonDatHang.iSoHD = tblChiTietDatHang.iSoHD AND YEAR(dNgaydathang) = 2021
GROUP BY tblDonDatHang.iMaNV

/*
Bài 3.3
a. Lấy danh sách khách hàng Nữ chưa đặt hàng lần nào.
b. Thống kê số lượng đặt hàng của toàn bộ các mặt hàng Thời trang (kể cả
các mặt hàng chưa được đặt lần nào).
c. Lấy danh sách các khách hàng Nam và Tổng tiền đặt hàng của mỗi người.
d. Tạo View thống kê số lượng khách hàng theo Giới tính.
e. Tạo View cho xem danh sách 3 khách hàng mua hàng nhiều lần nhất.
f. Tạo View cho xem danh sách mặt hàng và giá bán trung bình của từng
mặt hàng
g. Cập nhật giá bán (tblMatHang.fGiaHang) theo qui tắc:
Giá bán 1 mặt hàng = Giá mua lớn nhất trong vòng 30 ngày của mặt hàng
đó + 10%
*/

-- a
SELECT iMaKH , sTenKH FROM dbo.tblKhachHang WHERE bGioitinh = N'0' AND iMaKH NOT IN (SELECT iMaKH FROM dbo.tblDonDatHang)
-- b
SELECT DISTINCT tblMatHang.sMahang,SUM(fSoluongmua) AS sohangdaban FROM dbo.tblMatHang , dbo.tblChiTietDatHang WHERE sMaloaihang = 4
GROUP BY tblMatHang.sMahang

-- c
SELECT dh.iMaKH ,kh.sTenKH, SUM  ((ct.fGiaban * ct.fSoluongmua) - (ct.fGiaban * ct.fSoluongmua * ct.fMucgiamgia /100)) AS tongtien FROM dbo.tblKhachHang AS kh , dbo.tblDonDatHang AS dh , dbo.tblChiTietDatHang AS ct 
WHERE kh.iMaKH = dh.iMaKH AND ct.iSoHD = dh.iSoHD AND kh.bGioitinh = N'1'
GROUP BY dh.iMaKH , kh.sTenKH

-- d case when là khi mà giới tính = 1 thì tính còn ko thì trả về end
CREATE VIEW soluongKH_gioitinh_khachhang AS 
SELECT SUM(CASE WHEN bGioitinh = 1 THEN 1 END) AS nam,SUM(CASE WHEN bGioitinh = 0 THEN 1 END) AS nữ FROM dbo.tblKhachHang 
 
 --e 
 CREATE VIEW top3_khachmuanhieuhangnhat AS 
 SELECT TOP 3 sTenKH ,fSoluongmua  FROM dbo.tblKhachHang , dbo.tblDonDatHang ,dbo.tblChiTietDatHang 
 WHERE tblKhachHang.iMaKH = tblDonDatHang.iMaKH AND tblChiTietDatHang.iSoHD = tblDonDatHang.iSoHD 
 ORDER BY fSoluongmua DESC


 
 -- f chưa chạy 
 CREATE VIEW trungbinhgiamathang_mathang AS 
 SELECT sTenhang AS [tên mặt hàng] , AVG(fGiahang) AS [giá trung bình ] FROM dbo.tblMatHang 
 GROUP BY sTenhang
 SELECT * FROM dbo.tblMatHang
 INSERT INTO dbo.tblMatHang
 VALUES
 (   '015',  -- sMahang - char(10)
     N'cam', -- sTenhang - nvarchar(30)
     5,   -- iMaNCC - int
     '2',  -- sMaloaihang - char(10)
     20, -- fSoluong - float
     21, -- fGiahang - float
     'vnd'   -- sDonvitinh - varchar(10)
     )
 -- g chưa chạy (đã đúng )
 -- hiện ra
SELECT sMahang , MAX(fGiaban) FROM dbo.tblChiTietDatHang INNER JOIN dbo.tblDonDatHang ON tblDonDatHang.iSoHD = tblChiTietDatHang.iSoHD WHERE
DATEDIFF(DAY , dNgaydathang , GETDATE()) <=30 
GROUP BY sMahang
-- update
UPDATE dbo.tblMatHang SET fGiahang = (MAX(fGiahang) * 0.1)+MAX(fGiahang)
FROM dbo.tblChiTietDatHang INNER JOIN dbo.tblDonDatHang ON tblDonDatHang.iSoHD = tblChiTietDatHang.iSoHD WHERE
DATEDIFF(DAY , dNgaydathang , GETDATE()) <=30 