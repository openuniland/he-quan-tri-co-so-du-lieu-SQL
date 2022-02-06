-- Nguyễn Công Minh, lớp: 1910a03, lớp tín chỉ: W602TH2021.015
USE TH_Buoi1_
GO
/*
Bài 2.1
a. Viết lệnh cho phép thêm 3 bản ghi vào bảng tblLoaiihang.
b. Thêm 3 bản ghi cho bảng Nhà cung cấp.
c. Với mỗi loại hàng có trong bảng tblLoaihang thực hiện thêm 3 mặt hàng
cho mỗi loại hàng tương ứng.
d. Xóa mặt hàng có số lượng = 0.
e. Tăng phụ cấp 10% cho những nhân viên có thâm niên làm việc 5 năm trở
lên.

*/
--a.

INSERT dbo.tblLoaiHang
VALUES
(   N'0', -- sMaloaihang - nvarchar(10)
    N'quần'  -- sTenloaihang - nvarchar(10)
)
INSERT dbo.tblLoaiHang
VALUES
(   N'1', -- sMaloaihang - nvarchar(10)
    N'áo'  -- sTenloaihang - nvarchar(10)
)

GO


-- b. Thêm 3 bản ghi cho bảng Nhà cung cấp.

INSERT dbo.tblNhaCungCap
VALUES
(   N'Minh', -- sTenNhaCC - nvarchar(50)
    N'bán', -- sTengiaodich - nvarchar(50)
    N'Hà Nội', -- sDiachi - nvarchar(50)
    N'0123456789'  -- sDienthoai - nvarchar(12)
)
INSERT dbo.tblNhaCungCap
VALUES
(   N'Ngọc', -- sTenNhaCC - nvarchar(50)
    N'bán', -- sTengiaodich - nvarchar(50)
    N'Hà Nội', -- sDiachi - nvarchar(50)
    N'0987654321'  -- sDienthoai - nvarchar(12)
)
INSERT dbo.tblNhaCungCap
VALUES
(   N'Hồng', -- sTenNhaCC - nvarchar(50)
    N'bán', -- sTengiaodich - nvarchar(50)
    N'Hà Nội', -- sDiachi - nvarchar(50)
    N'0451325421'  -- sDienthoai - nvarchar(12)
)
GO 

--c. Với mỗi loại hàng có trong bảng tblLoaihang thực hiện thêm 3 mặt hàng cho mỗi loại hàng tương ứng.
--DELETE dbo.tblLoaiHang

INSERT dbo.tblMatHang
VALUES
(   N'0', -- sMahang - nvarchar(10)
    N'quần bò', -- sTenhang - nvarchar(30)
    1,   -- iMaNCC - int
    N'0', -- sMaloaihang - nvarchar(10)
    10, -- fSoluong - float
    50000, -- fGiahang - float
    'vnd',  -- sDonViTinh - varchar(10)
    0 -- bGioiTinh - bit
)
INSERT dbo.tblMatHang
VALUES
(   N'1', -- sMahang - nvarchar(10)
    N'quần da', -- sTenhang - nvarchar(30)
    2,   -- iMaNCC - int
    N'0', -- sMaloaihang - nvarchar(10)
    15, -- fSoluong - float
    100000, -- fGiahang - float
    'vnd',  -- sDonViTinh - varchar(10)
    0 -- bGioiTinh - bit
)
INSERT dbo.tblMatHang
VALUES
(   N'2', -- sMahang - nvarchar(10)
    N'quần đùi', -- sTenhang - nvarchar(30)
    3,   -- iMaNCC - int
    N'0', -- sMaloaihang - nvarchar(10)
    0, -- fSoluong - float
    30000, -- fGiahang - float
    'vnd',  -- sDonViTinh - varchar(10)
    1 -- bGioiTinh - bit
)
GO


-- d. Xóa mặt hàng có số lượng = 0. trước khi xóa ta cần có dữ liệu nên insert 2 mặt hàng và xóa
-- xóa đi hàng có số lượng = 0 
DELETE dbo.tblMatHang WHERE fSoluong = 0   

--SELECT * FROM dbo.tblMatHang
--e. Tăng phụ cấp 10% cho những nhân viên có thâm niên làm việc 5 năm trở lên.

INSERT dbo.tblNhanVien
VALUES
(   0,         -- iMaNV - int
    N'Nguyễn Thanh B',       -- sTenNV - nvarchar(30)
    N'Hà Nội',       -- sDiaChi - nvarchar(50)
    '0123456789',        -- sDienThoai - varchar(12)
    '19990202', -- dNgaySinh - datetime
    '20200202', -- dNgayVaoLam - datetime
    2.0,       -- fLuongCoBan - float
    1.0,       -- fPhuCap - float
    '001'         -- sCMND - varchar(12)
)
INSERT dbo.tblNhanVien
VALUES
(   1,         -- iMaNV - int
    N'Nguyễn Thanh B',       -- sTenNV - nvarchar(30)
    N'Hà Nội',       -- sDiaChi - nvarchar(50)
    '0123456789',        -- sDienThoai - varchar(12)
    '20010202', -- dNgaySinh - datetime
    '20200202', -- dNgayVaoLam - datetime
    2.0,       -- fLuongCoBan - float
    1.0,       -- fPhuCap - float
    '002'         -- sCMND - varchar(12)
)

SELECT * FROM dbo.tblNhanVien
UPDATE dbo.tblNhanVien SET fPhuCap = fPhucap + (fPhucap * 0.1) WHERE YEAR(GETDATE())- YEAR(dNgayvaolam) >=5

/*
sau bài 2.1 em nhận thấy mỗi khi thêm thông tin ngày tháng vào cần nắm rõ điều kiện thêm vào để trách xảy ra xung đột với điều kiện đã
đặt ra trước đó ví dụ như ngày sinh
*/
-------------------------------------------------------------------------------------------------------------------------------------
/*
Bài 2.2
A. Thực hiện cho phép thêm 3 bản ghi vào bảng tblKhachHang và 3 bản ghi vào bảng tblNhanVien
B. Thực hiện thêm 03 bản ghi vào bảng tblDonDatHang
C. Thực hiện với mỗi đơn đặt hàng trong bảng tblDonDatHang cho phép
thêm các chi tiết đơn đặt hàng tương ứng, mỗi đơn đặt hàng có ít nhất 02
mặt hàng được thêm
D. Thực hiện cho phép mức giảm giá là 10% cho các mặt hàng bán trong
tháng 7 năm 2016
E. Thực hiện xóa các chi tiết đơn đặt hàng của hóa đơn có mã đơn đặt hàng do sinh viên tự xác định.
*/
-- A. Thực hiện cho phép thêm 3 bản ghi vào bảng tblKhachHang và 3 bản ghi vào bảng tblNhanVien
INSERT dbo.tblKhachHang
VALUES
(   0,         -- iMaKH - int
    N'Hoàng Văn Linh',       -- sTenKH - nvarchar(30)
    '19990512', -- dNgaySinh - date
    N'Thanh Hóa',       -- sDiaChi - nvarchar(50)
    '1548613548'         -- sDienThoai - varchar(12)
)
INSERT dbo.tblKhachHang
VALUES
(   1,         -- iMaKH - int
    N'Trần Thị Ánh',       -- sTenKH - nvarchar(30)
    '19990512', -- dNgaySinh - date
    N'Ninh Bình',       -- sDiaChi - nvarchar(50)
    '35648649616'         -- sDienThoai - varchar(12)
)
INSERT dbo.tblKhachHang
VALUES
(   2,         -- iMaKH - int
    N'Nguyễn An Vân',       -- sTenKH - nvarchar(30)
    '19990512', -- dNgaySinh - date
    N'Hà Nội',       -- sDiaChi - nvarchar(50)
    '5487894'         -- sDienThoai - varchar(12)
)
GO
-- 3 bản nhân viên
--SELECT * FROM dbo.tblNhanVien
INSERT dbo.tblNhanVien
VALUES
(   2,         -- iMaNV - int
    N'Nguyễn Thanh Hai',       -- sTenNV - nvarchar(30)
    N'Hà Nội',       -- sDiaChi - nvarchar(50)
    '0123456789',        -- sDienThoai - varchar(12)
    '20010202', -- dNgaySinh - datetime
    '20200202', -- dNgayVaoLam - datetime
    2.0,       -- fLuongCoBan - float
    1.0,       -- fPhuCap - float
    '003'         -- sCMND - varchar(12)
)
INSERT dbo.tblNhanVien
VALUES
(   3,         -- iMaNV - int
    N'Nguyễn Thanh Hai',       -- sTenNV - nvarchar(30)
    N'Hà Nội',       -- sDiaChi - nvarchar(50)
    '0123456789',        -- sDienThoai - varchar(12)
    '20010202', -- dNgaySinh - datetime
    '20200202', -- dNgayVaoLam - datetime
    2.0,       -- fLuongCoBan - float
    1.0,       -- fPhuCap - float
    '004'         -- sCMND - varchar(12)
)
INSERT dbo.tblNhanVien
VALUES
(   4,         -- iMaNV - int
    N'Nguyễn Thanh Hai',       -- sTenNV - nvarchar(30)
    N'Hà Nội',       -- sDiaChi - nvarchar(50)
    '0123456789',        -- sDienThoai - varchar(12)
    '20010202', -- dNgaySinh - datetime
    '20200202', -- dNgayVaoLam - datetime
    2.0,       -- fLuongCoBan - float
    1.0,       -- fPhuCap - float
    '005'         -- sCMND - varchar(12)
)
GO 
-- B. Thực hiện thêm 03 bản ghi vào bảng tblDonDatHang
INSERT dbo.tblDonDatHang
VALUES
(   0,         -- iSoHD - int
    2,         -- iMaNV - int
    2,         -- iMaKH - int
    GETDATE(), -- dNgayDatHang - datetime
    '20211201', -- dNgayGiaoHang - datetime
    N'Hoàng Mai - Hà Nội'        -- sDiaChiGiaoHang - nvarchar(50)
)
INSERT dbo.tblDonDatHang
VALUES
(   1,         -- iSoHD - int
    2,         -- iMaNV - int
    2,         -- iMaKH - int
    GETDATE(), -- dNgayDatHang - datetime
    '20211201', -- dNgayGiaoHang - datetime
    N'Hoàng Mai - Hà Nội'        -- sDiaChiGiaoHang - nvarchar(50)
)
INSERT dbo.tblDonDatHang
VALUES
(   2,         -- iSoHD - int
    2,         -- iMaNV - int
    2,         -- iMaKH - int
    GETDATE(), -- dNgayDatHang - datetime
    '20211201', -- dNgayGiaoHang - datetime
    N'Hoàng Mai - Hà Nội'        -- sDiaChiGiaoHang - nvarchar(50)
)
GO
/*C. Thực hiện với mỗi đơn đặt hàng trong bảng tblDonDatHang cho phép
thêm các chi tiết đơn đặt hàng tương ứng, mỗi đơn đặt hàng có ít nhất 02
mặt hàng được thêm */
INSERT dbo.tblChiTietDatHang
VALUES
(   0,   -- iSoHD - int
    '0', -- sMaHang - nvarchar(10)
    120000, -- fGiaBan - float
    2, -- fSoLuongMua - float
    1.0  -- fMucGiamGia - float
)
INSERT dbo.tblChiTietDatHang
VALUES
(   1,   -- iSoHD - int
    '0', -- sMaHang - nvarchar(10)
    120000, -- fGiaBan - float
    3, -- fSoLuongMua - float
    1.0  -- fMucGiamGia - float
)
INSERT dbo.tblChiTietDatHang
VALUES
(   2,   -- iSoHD - int
    '0', -- sMaHang - nvarchar(10)
    120000, -- fGiaBan - float
    3, -- fSoLuongMua - float
    1.0  -- fMucGiamGia - float
)
GO
-- D. Thực hiện cho phép mức giảm giá là 10% cho các mặt hàng bán trong tháng 7 năm 2016
SELECT * FROM dbo.tblDonDatHang
UPDATE dbo.tblMatHang SET fGiahang = fGiahang - (fGiahang * 0.1) FROM dbo.tblDonDatHang WHERE (MONTH(dNgaydathang) = 7)
GO 
-- E. Thực hiện xóa các chi tiết đơn đặt hàng của hóa đơn có mã đơn đặt hàng do sinh viên tự xác định.
DELETE dbo.tblDonDatHang WHERE  iSoHD = 0
GO 

/*
sau bài 2.2 này em thấy mỗi khi thêm các sản phẩm cần nắm rõ các điều kiện và các khóa ngoại và khóa chính của nó
để khi thêm không bị trùng lặp bởi có nhiều khóa
*/
---------------------------------------------------------------------------------------------------------------
/*
Bài 2.3
a. Với mỗi khách hàng Nam, hãy thêm cho mỗi người 3 đơn hàng
(tblDonDatHang); mỗi đơn hàng trong 1 tháng khác nhau trước đây và đặt
ít nhất 3 mặt hàng (tblChitietDonHang) với số lượng mua khác nhau.
b. Thêm loại hàng “Thời trang” và “Chăm sóc sức khoẻ” : done
c. Thêm 5 mặt hàng thuộc loại hàng “Thời trang” : done
d. Lập đơn đặt hàng cho ít nhất 2⁄3 số khách hàng Nữ với ít nhất 4⁄5 số mặt hàng Thời trang đã thêm.
e. Giảm giá bán 5% mỗi mặt hàng đã đặt và chưa giao thuộc loại hàng “Thời
trang”
f. Xoá loại hàng “Chăm sóc sức khoẻ”
*/

/*a. Với mỗi khách hàng Nam, hãy thêm cho mỗi người 3 đơn hàng
(tblDonDatHang); mỗi đơn hàng trong 1 tháng khác nhau trước đây và đặt
ít nhất 3 mặt hàng (tblChitietDonHang) với số lượng mua khác nhau. */

INSERT dbo.tblDonDatHang
VALUES
(   3,         -- iSoHD - int
    0,         -- iMaNV - int
    2,         -- iMaKH - int
    GETDATE(), -- dNgayDatHang - datetime
    '20211203', -- dNgayGiaoHang - datetime
    N'Hà Nội'        -- sDiaChiGiaoHang - nvarchar(50)
)
INSERT dbo.tblDonDatHang
VALUES
(   4,         -- iSoHD - int
    0,         -- iMaNV - int
    2,         -- iMaKH - int
    GETDATE(), -- dNgayDatHang - datetime
    '20211203', -- dNgayGiaoHang - datetime
    N'Hà Nội'        -- sDiaChiGiaoHang - nvarchar(50)
)
INSERT dbo.tblDonDatHang
VALUES
(   5,         -- iSoHD - int
    0,         -- iMaNV - int
    2,         -- iMaKH - int
    GETDATE(), -- dNgayDatHang - datetime
    '20211203', -- dNgayGiaoHang - datetime
    N'Hà Nội'        -- sDiaChiGiaoHang - nvarchar(50)
)
GO 
--đặt ít nhất 3 mặt hàng (tblChitietDonHang)
INSERT dbo.tblChiTietDatHang
VALUES
(   6,   -- iSoHD - int
    '4', -- sMaHang - nvarchar(10)
    55000, -- fGiaBan - float
    5, -- fSoLuongMua - float
    1.0  -- fMucGiamGia - float
)
GO 
-- b. Thêm loại hàng “Thời trang” và “Chăm sóc sức khoẻ"
INSERT dbo.tblLoaiHang
VALUES
(   '2', -- sMaloaihang - nvarchar(10)
    N'Thời trang'  -- sTenloaihang - nvarchar(10)
)
INSERT dbo.tblLoaiHang
VALUES
(   '3', -- sMaloaihang - nvarchar(10)
    N'cssk'  -- sTenloaihang - nvarchar(10)
)
GO 
-- c. Thêm 5 mặt hàng thuộc loại hàng “Thời trang”
INSERT dbo.tblMatHang
VALUES
(   '3', -- sMahang - nvarchar(10)
    N'Váy ngắn', -- sTenhang - nvarchar(30)
    2,   -- iMaNCC - int
    '2', -- sMaloaihang - nvarchar(10)
    50, -- fSoluong - float
    200000, -- fGiahang - float
    'vnd',  -- sDonViTinh - varchar(10)
    1 -- bGioiTinh - bit
)
INSERT dbo.tblMatHang
VALUES
(   '4', -- sMahang - nvarchar(10)
    N'Váy dài', -- sTenhang - nvarchar(30)
    2,   -- iMaNCC - int
    '2', -- sMaloaihang - nvarchar(10)
    50, -- fSoluong - float
    50000, -- fGiahang - float
    'vnd',  -- sDonViTinh - varchar(10)
    1 -- bGioiTinh - bit
)
INSERT dbo.tblMatHang
VALUES
(   '5', -- sMahang - nvarchar(10)
    N'Váy tím', -- sTenhang - nvarchar(30)
    2,   -- iMaNCC - int
    '2', -- sMaloaihang - nvarchar(10)
    50, -- fSoluong - float
    120000, -- fGiahang - float
    'vnd',  -- sDonViTinh - varchar(10)
    1 -- bGioiTinh - bit
)
INSERT dbo.tblMatHang
VALUES
(   '6', -- sMahang - nvarchar(10)
    N'Váy đỏ', -- sTenhang - nvarchar(30)
    2,   -- iMaNCC - int
    '2', -- sMaloaihang - nvarchar(10)
    50, -- fSoluong - float
    450000, -- fGiahang - float
    'vnd',  -- sDonViTinh - varchar(10)
    1 -- bGioiTinh - bit
)
INSERT dbo.tblMatHang
VALUES
(   '7', -- sMahang - nvarchar(10)
    N'Váy hồng', -- sTenhang - nvarchar(30)
    2,   -- iMaNCC - int
    '2', -- sMaloaihang - nvarchar(10)
    50, -- fSoluong - float
    750000, -- fGiahang - float
    'vnd',  -- sDonViTinh - varchar(10)
    1 -- bGioiTinh - bit
)
GO

--d. Lập đơn đặt hàng cho ít nhất 2⁄3 số khách hàng Nữ với ít nhất 4⁄5 số mặt hàng Thời trang đã thêm.
INSERT dbo.tblDonDatHang
VALUES
(   3,         -- iSoHD - int
    0,         -- iMaNV - int
    1,         -- iMaKH - int
    GETDATE(), -- dNgayDatHang - datetime
    '20211209', -- dNgayGiaoHang - datetime
    N'Hoàng Mai - Hà Nội'        -- sDiaChiGiaoHang - nvarchar(50)
)
INSERT dbo.tblDonDatHang
VALUES
(   4,         -- iSoHD - int
    2,         -- iMaNV - int
    1,         -- iMaKH - int
    GETDATE(), -- dNgayDatHang - datetime
    '20211209', -- dNgayGiaoHang - datetime
    N'Ba Đình - Hà Nội'        -- sDiaChiGiaoHang - nvarchar(50)
)
-- thêm chi tiết đặt hàng
INSERT dbo.tblChiTietDatHang
VALUES
(   3,   -- iSoHD - int
    '4', -- sMaHang - nvarchar(10)
    55000, -- fGiaBan - float
    3, -- fSoLuongMua - float
    0.0  -- fMucGiamGia - float
)
INSERT dbo.tblChiTietDatHang
VALUES
(   3,   -- iSoHD - int
    '5', -- sMaHang - nvarchar(10)
    44000, -- fGiaBan - float
    8, -- fSoLuongMua - float
    0.0  -- fMucGiamGia - float
)
INSERT dbo.tblChiTietDatHang
VALUES
(   3,   -- iSoHD - int
    '6', -- sMaHang - nvarchar(10)
    33000, -- fGiaBan - float
    17, -- fSoLuongMua - float
    0.0  -- fMucGiamGia - float
)
INSERT dbo.tblChiTietDatHang
VALUES
(   3,   -- iSoHD - int
    '7', -- sMaHang - nvarchar(10)
    10000, -- fGiaBan - float
    5, -- fSoLuongMua - float
    0.0  -- fMucGiamGia - float
)
---
-- f. Xoá loại hàng “Chăm sóc sức khoẻ”
DELETE FROM dbo.tblLoaiHang WHERE sTenloaihang = N'cssk'
SELECT * FROM dbo.tblLoaiHang

-- e. Giảm giá bán 5% mỗi mặt hàng đã đặt và chưa giao thuộc loại hàng “Thời trang"
UPDATE dbo.tblMatHang SET fGiahang = (fGiahang +fGiahang*0.5) WHERE sMaloaihang = 2

/*
sau bài 2.3 này em cần chú ý thêm độ dài của tên vì em set độ dài ngắn nên khi thêm bị ảnh hưởng, và cần chú ý khi thêm
giữ liệu phải không được trùng lặp nếu yêu cầu điều kiện không trùng
*/