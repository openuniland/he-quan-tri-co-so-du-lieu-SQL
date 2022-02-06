--Bài thực hành 4 - Nguyễn Công Minh - 1910a03 - 19a10010112
USE TH_Buoi1_t
GO 
--a.Tạo thủ tục có tham số truyền vào là năm cho biết các mặt hàng không bán được trong năm đó.
CREATE PROC hangthatthu
@nam INT 
AS
BEGIN
	  SELECT sTenhang FROM dbo.tblMatHang 
	INNER JOIN dbo.tblChiTietDatHang ON tblChiTietDatHang.sMahang = tblMatHang.sMahang
	INNER JOIN dbo.tblDonDatHang ON tblDonDatHang.iSoHD = tblChiTietDatHang.iSoHD
	WHERE YEAR(dNgaydathang) = @nam

END
-- gọi thủ tục
EXEC dbo.hangthatthu @nam = 2021 -- int

/* b.
Viết thủ tục:
○ Tham số truyền vào: số lượng hàng và năm;
○ Thực hiện tăng lương cơ bản lên gấp rưỡi cho những nhân viên bán
được số lượng hàng nhiều hơn số lượng hàng truyền vào trong năm
đó*/
-- chưa chạy
CREATE PROC tangluong
@soluong INT ,
@nam INT 
AS
BEGIN

	UPDATE dbo.tblNhanVien SET fLuongcoban = fLuongcoban *1.5 FROM dbo.tblNhanVien
	INNER JOIN dbo.tblDonDatHang ON tblDonDatHang.iMaNV = tblNhanVien.iMaNV
	INNER JOIN dbo.tblChiTietDatHang ON tblChiTietDatHang.iSoHD = tblDonDatHang.iSoHD
	WHERE YEAR(dNgaydathang) = @nam AND fSoluongmua > @soluong
  
END

SELECT * FROM dbo.tblChiTietDatHang

/* c.
Tạo thủ tục thống kê tổng số lượng hàng bán được của một mặt hàng có
mã hàng là tham số truyền vào
*/
ALTER PROC thongke
@mahang CHAR(10)
AS 
IF EXISTS (SELECT * FROM dbo.tblChiTietDatHang WHERE sMahang = @mahang)
	BEGIN
		SELECT sTenhang,SUM(fSoluongmua) AS [số lượng] FROM dbo.tblMatHang
		INNER JOIN dbo.tblChiTietDatHang ON tblChiTietDatHang.sMahang = tblMatHang.sMahang
		WHERE tblMatHang.sMahang = @mahang
		GROUP BY sTenhang
	END
ELSE
BEGIN
    PRINT N'mã hàng này chưa có người mua !!'
END

EXEC thongke @mahang = '010' 

--d.
--Tạo thủ tục có tham số truyền vào là năm, cho biết tổng số tiền hàng thu được trong năm đó
ALTER PROC tontienhangtrongnam
@namban INT
AS 
IF EXISTS (SELECT * FROM dbo.tblDonDatHang WHERE YEAR(dNgaydathang) = @namban)
	BEGIN
		SELECT SUM(fGiaban*fSoluongmua) AS [tổng tiền hàng] FROM dbo.tblChiTietDatHang 
		INNER JOIN dbo.tblDonDatHang ON tblDonDatHang.iSoHD = tblChiTietDatHang.iSoHD
		WHERE YEAR(dNgaydathang) = @namban

	END
ELSE
BEGIN
    PRINT N'không có mặt hàng nào bán trong năm này !!'
END

EXEC tontienhangtrongnam @namban = 2021

--e.
/*
Viết trigger cho bảng tblChiTietDatHang để sao cho khi thêm 1 bản ghi
hoặc khi sửa tblChiTietDatHang.fGiaban chỉ chấp nhận giá bán ra phải
lớn hơn hoặc bằng giá gốc (tblMatHang.fGiaHang)
*/

CREATE TRIGGER update_giaban ON dbo.tblChiTietDatHang
FOR INSERT , update
AS 
IF UPDATE(fGiaban)
	BEGIN
	    IF EXISTS (SELECT inserted.sMahang FROM dbo.tblMatHang INNER JOIN inserted
		ON dbo.tblMatHang.sMahang = inserted.sMahang
		WHERE dbo.tblMatHang.fGiahang > inserted.fGiaban)
		ROLLBACK TRANSACTION
	END

SELECT * FROM dbo.tblMatHang
SELECT * FROM dbo.tblChiTietDatHang
INSERT INTO dbo.tblChiTietDatHang
VALUES
(   4,   -- iSoHD - int
    '001',  -- sMahang - char(10)
    90, -- fGiaban - float
    10, -- fSoluongmua - float
    0.0  -- fMucgiamgia - float
    )

--f.
--Viết trigger để đảm bảo lượng hàng bán ra không vượt quá lượng hàng hiện có.

CREATE TRIGGER RB_hangban_hangtonkho ON dbo.tblChiTietDatHang
FOR INSERT ,UPDATE 
AS 
IF UPDATE(fSoluongmua)
	BEGIN
	    IF EXISTS (SELECT inserted.sMahang FROM dbo.tblMatHang INNER JOIN inserted ON dbo.tblMatHang.sMahang = inserted.sMahang
		WHERE dbo.tblMatHang.fSoluong < inserted.fSoluongmua)
		ROLLBACK TRANSACTION
	END


/*
Viết trigger cho bảng CHITIETDATHANG sao cho khi một bản ghi mới được bổ sung thì
giảm số lượng hàng hiện có nếu số lượng hàng có >= số lượng hàng bán ra.
Ngược lại thì huỷ bỏ thao tác bổ sung. 
*/


ALTER TRIGGER CTDH ON dbo.tblChiTietDatHang
FOR INSERT ,UPDATE 
AS 
BEGIN
    IF UPDATE(fsoluongmua)
	DECLARE @soluongmua INT , @soluonghang INT ,@mahang INT
	
	SELECT @soluongmua = fsoluongmua, @mahang =sMaHang FROM inserted 
	SELECT @soluonghang = fsoluong FROM dbo.tblMatHang WHERE sMahang = @mahang
	IF(@soluongmua < @soluonghang)
		BEGIN
		  UPDATE dbo.tblMatHang SET fSoluong = fSoluong - @soluongmua WHERE sMahang = @mahang
		END
	ELSE 
		BEGIN
			PRINT N'không đủ hàng tồn để bán '
			ROLLBACK 
		END 
END

INSERT INTO dbo.tblChiTietDatHang
VALUES
(   2,   -- iSoHD - int
    '001',  -- sMahang - char(10)
    1200, -- fGiaban - float
    79, -- fSoluongmua - float
    0.0  -- fMucgiamgia - float
    )

UPDATE tblChiTietDatHang SET fSoluongmua = 50 WHERE sMahang = '001'
DELETE dbo.tblChiTietDatHang WHERE iSoHD = 2

SELECT * FROM dbo.tblChiTietDatHang
SELECT * FROM dbo.tblMatHang

----- bài 4.2
/*
a. Tạo thủ tục để bổ sung thêm một bản ghi mới cho tblDonDatHang (thủ
tục cần kiểm tra tính hợp lệ của dữ liệu cần bổ sung như: dNgaydathang
phải <= ngày hiện tại và dNgaygiaohang phải >= dNgaydathang)
*/
CREATE PROC thembanghi
@sohd INT ,
@manv INT ,@makh INT , @ngaydat DATETIME , @ngaygiao DATETIME,@diachi NVARCHAR(50)
AS 
IF NOT EXISTS (SELECT * FROM dbo.tblDonDatHang WHERE iSoHD = @sohd)
AND EXISTS(SELECT * FROM dbo.tblNhanVien WHERE iMaNV = @manv) 
AND EXISTS (SELECT * FROM dbo.tblKhachHang WHERE iMaKH = @makh)
	BEGIN
		 IF	(@ngaydat <= GETDATE() AND DATEDIFF(DAY,@ngaydat ,@ngaygiao) >= 0 )
			BEGIN
				INSERT INTO dbo.tblDonDatHang VALUES(@sohd,@manv,@makh,@ngaydat,@ngaygiao,@diachi,NULL)
			END
		ELSE 
			BEGIN
			    PRINT 'vi phạm ràng buộc về ngày giao hàng phải nhỏ hơn đặt hàng'
			END
	END
ELSE
	BEGIN
	   PRINT N'ràng buộc bị vi phạm '
	   ROLLBACK TRAN
	END
    	
-- gọi thủ tục
EXEC thembanghi @sohd =1 ,@manv = 1,@makh =  1 ,@ngaydat = '20211006',@ngaygiao = '20211007' ,@diachi = N'vĩnh phúc'
-- chưa test câu a nha.
SELECT * FROM dbo.tblDonDatHang
SELECT * FROM dbo.tblChiTietDatHang
SELECT * FROM dbo.tblKhachHang

---b.
/*
Thêm cột TongTienHang (float) vào bảng tblKhachHang, tạo trigger sao
cho giá trị TongTienHang tự động tăng lên mỗi khi khách hàng đến tham
gia mua hàng tại cửa hàng
*/
ALTER TABLE dbo.tblKhachHang ADD tongtienhang INT

UPDATE dbo.tblKhachHang SET tongtienhang = A.tong FROM dbo.tblKhachHang INNER JOIN
( SELECT tblKhachHang.iMaKH , SUM(fGiaban*fSoluongmua - fMucgiamgia) AS [tong] FROM dbo.tblKhachHang
INNER JOIN dbo.tblDonDatHang ON tblDonDatHang.iMaKH = tblKhachHang.iMaKH 
 INNER JOIN dbo.tblChiTietDatHang ON tblChiTietDatHang.iSoHD = tblDonDatHang.iSoHD
 GROUP BY tblKhachHang.iMaKH)
 AS A ON A.iMaKH = tblKhachHang.iMaKH

CREATE TRIGGER tongtienhang ON dbo.tblChiTietDatHang
FOR UPDATE , INSERT 
AS 
BEGIN
   UPDATE dbo.tblKhachHang SET tongtienhang =tongtienhang + A.tong FROM dbo.tblKhachHang INNER JOIN
	( SELECT tblKhachHang.iMaKH , SUM(fGiaban*fSoluongmua - fMucgiamgia) AS [tong]
		FROM dbo.tblKhachHang
	INNER JOIN dbo.tblDonDatHang ON tblDonDatHang.iMaKH = tblKhachHang.iMaKH 
	INNER JOIN inserted ON inserted.iSoHD = tblDonDatHang.iSoHD
	GROUP BY tblKhachHang.iMaKH)
	 AS A ON A.iMaKH = tblKhachHang.iMaKH
END
-- thử nghiệm
SELECT * FROM tblKhachHang
SELECT * FROM dbo.tblDonDatHang
SELECT * FROM dbo.tblChiTietDatHang
UPDATE dbo.tblChiTietDatHang SET fGiaban = 20 WHERE sMahang = '010'
-- c.
/*
Tạo Thủ tục cho biết danh sách tên các mặt hàng đã được nhập hàng từ
một nhà cung cấp (theo tên nhà cung cấp) trong một năm nào đó (tham số
truyền vào gồm tên nhà cung cấp và một năm)
*/
CREATE PROC cungcaphang 
@ten NVARCHAR(30),
@nam INT 
AS 
BEGIN
    	SELECT sTenhang FROM dbo.tblNhaCungCap INNER JOIN dbo.tblMatHang ON tblMatHang.iMaNCC = tblNhaCungCap.iMaNCC 
	INNER JOIN dbo.tblChiTietNhapHang ON tblChiTietNhapHang.sMahang = tblMatHang.sMahang
	INNER JOIN dbo.tblDonnhaphang ON tblDonnhaphang.iSoHD = tblChiTietNhapHang.iSoHD
		WHERE sTenNhaCC LIKE  @ten AND YEAR(dNgaynhaphang) = @nam
END
-- gọi thủ tục
EXEC cungcaphang @ten = N'lê tuấn vũ' , @nam = 2021

---- d.
/*
Tạo thủ tục cho biết tên các nhà cung cấp và ngày nhập hàng đã được
nhập hàng của một mặt hàng nào đó theo tên mặt hàng (tham số truyền
vào là tên mặt hàng)
*/

CREATE PROC timNCCvaNgaynhapcuamathang
@tenhang NVARCHAR(30)
AS
BEGIN
    SELECT tblNhaCungCap.iMaNCC,sTenNhaCC,dNgaynhaphang FROM dbo.tblMatHang
		INNER JOIN dbo.tblNhaCungCap ON tblNhaCungCap.iMaNCC = tblMatHang.iMaNCC
		INNER JOIN dbo.tblChiTietNhapHang ON tblChiTietNhapHang.sMahang = tblMatHang.sMahang
		INNER JOIN dbo.tblDonnhaphang ON tblDonnhaphang.iSoHD = tblChiTietNhapHang.iSoHD
		WHERE sTenhang LIKE @tenhang
END
--gọi thủ tục
EXEC timNCCvaNgaynhapcuamathang @tenhang = N'cam'

--e.
/*
Thêm cột TongSoMatHang(float) vào bảng tblDONDATHANG,
tạo trigger sao cho giá trị của TongSoMatHang tự động tăng lên
mỗi khi bổ sung thêm một mặt hàng khách đặt mua trong đơn đặt hàng tương ứng
*/
ALTER TABLE dbo.tblDonDatHang ADD TongSoMatHang FLOAT

UPDATE dbo.tblDonDatHang SET TongSoMatHang = A.tong FROM dbo.tblDonDatHang INNER JOIN (
SELECT tblDonDatHang.iSoHD , SUM(fSoluongmua) AS tong FROM dbo.tblDonDatHang
		INNER JOIN dbo.tblChiTietDatHang ON tblChiTietDatHang.iSoHD = tblDonDatHang.iSoHD
		INNER JOIN dbo.tblMatHang ON tblMatHang.sMahang = tblChiTietDatHang.sMahang
		GROUP BY tblDonDatHang.iSoHD) 
		AS A ON A.iSoHD = tblDonDatHang.iSoHD

alter TRIGGER autoupdatetongsomathang ON  dbo.tblChiTietDatHang
FOR INSERT , UPDATE   
AS 

if update (fSoluongmua)
begin 
    UPDATE dbo.tblDonDatHang SET TongSoMatHang =TongSoMatHang + A.tong
	FROM dbo.tblDonDatHang INNER JOIN (
SELECT tblDonDatHang.iSoHD , SUM(fSoluongmua) AS tong FROM dbo.tblDonDatHang
		INNER JOIN inserted ON inserted.iSoHD = tblDonDatHang.iSoHD
		INNER JOIN dbo.tblMatHang ON tblMatHang.sMahang = inserted.sMahang
		GROUP BY tblDonDatHang.iSoHD) 
		AS A ON A.iSoHD = tblDonDatHang.iSoHD

END
SELECT * FROM dbo.tblChiTietDatHang
SELECT * FROM dbo.tblDonDatHang
SELECT* FROM dbo.tblMatHang
DELETE dbo.tblChiTietDatHang WHERE sMahang = '005'
UPDATE dbo.tblChiTietDatHang SET fSoluongmua = 2 WHERE sMahang = '005'
INSERT INTO dbo.tblChiTietDatHang
VALUES
(   8,   -- iSoHD - int
    '005',  -- sMahang - char(10)
    100, -- fGiaban - float
    1, -- fSoluongmua - float
    1.0  -- fMucgiamgia - float
    )



----------------- Bài 4.3 --------------------
-- a. Tạo Stored Procedure thêm dữ liệu cho bảng tblMatHang theo các tham số truyền vào.

CREATE PROC themDL_MH 
@ma CHAR(10),@ten NVARCHAR(30),@maNCC INT ,@maloai CHAR(10) ,@sl FLOAT , @giahang FLOAT 
AS 
IF EXISTS (SELECT * FROM dbo.tblNhaCungCap WHERE iMaNCC = @maNCC)
AND EXISTS (SELECT * FROM dbo.tblLoaiHang WHERE sMaloaihang = @maloai)
	BEGIN
	     INSERT INTO dbo.tblMatHang VALUES (@ma,@ten,@maNCC,@maloai,@sl,@giahang, 'vnd')
	END


EXEC themDL_MH @ma = '015' ,@ten = N'dress',@maNCC = '3',@maloai = 4,@sl = 15,@giahang = 12

DELETE dbo.tblMatHang WHERE sMahang = '015'

SELECT * FROM dbo.tblMatHang
SELECT * FROM dbo.tblNhaCungCap

--- 
/*
b. Tạo Stored Procedure:
○ Nhận vào các tham số: Giá trị, Mức giảm giá
○ Thực hiện giảm giá cho các mặt hàng được đặt trong tháng hiện tại,
có (fGiaban*fSoluongmua)>=Giá trị và đang có fMucGiamgia=0.
*/
CREATE PROC giamgia_MH
@giatri FLOAT , @mucsale FLOAT
AS 
	BEGIN
		UPDATE dbo.tblChiTietDatHang SET fMucgiamgia = @mucsale FROM dbo.tblChiTietDatHang 
		INNER JOIN dbo.tblDonDatHang ON tblDonDatHang.iSoHD = tblChiTietDatHang.iSoHD 
		WHERE (fGiaban*fSoluongmua) > @giatri AND fMucgiamgia = 0 AND MONTH(dNgaydathang) = MONTH(GETDATE())

	END
-- gọi thủ tục
EXEC giamgia_MH @giatri = 199 , @mucsale = 2

--
/*
c. Tạo Stored Procedure: 
○ Nhận vào các tham số: các thông tin về đơn đặt hàng, danh sách
mặt hàng ở dạng xâu gồm “{{Mã hàng 1, Số lượng 1}, {Mã hàng
2, Số lượng 2}, ....}”
○ Thực hiện việc thêm đơn đặt hàng và chi tiết đơn đặt hàng với:
■ Giá bán mỗi mặt hàng được lấy tương ứng từ bảng
tblMathang
■ Mức giảm giá mỗi mặt hàng mặc định bằng 0
*/

-- chưa chạy

	CREATE  PROC XauHang
	@chuoi nvarchar(256),
	@sMahang nvarchar(10)=null, @iSoHD int , @fGiaban float =null, @fSoluongmua int = null, @fMucgiamgia float=0,
	@iMaNV int, @iMaKH int, @dNgaygiaohang nvarchar(20), @dNgaydathang nvarchar(20), @sDiachigiaohang nvarchar(20)
	AS
	BEGIN
		WHILE LEN(@chuoi) <> 0
		BEGIN
		SET @sMahang = SUBSTRING(@chuoi , 1 , CHARINDEX(',', @chuoi)-1)
		SET @chuoi = SUBSTRING(@chuoi ,CHARINDEX(',', @chuoi)+1, LEN(@chuoi))
			IF CHARINDEX(',', @chuoi) = 0
				BEGIN
					SET @fSoluongmua = SUBSTRING(@chuoi , 1 , LEN(@chuoi))
					SET @chuoi = ''
					SET @fGiaban = (SELECT fGiahang FROM dbo.tblMatHang WHERE sMahang = @sMahang)
				END
			ELSE
			BEGIN
				SET @fSoluongmua = SUBSTRING(@chuoi , 1 , CHARINDEX(',', @chuoi)-1)
				SET @chuoi = SUBSTRING(@chuoi ,CHARINDEX(',', @chuoi)+1, LEN(@chuoi))
				SET @fGiaban = (SELECT fGiahang FROM dbo.tblMatHang WHERE sMahang = @sMahang)
				
			END
			INSERT INTO dbo.tblDonDatHang(iSoHD,iMaNV,iMaKH,dNgaydathang,dNgaygiaohang,sDiachigiaohang)
			VALUES(@iSoHD,@iMaNV,@iMaKH,@dNgaydathang,@dNgaygiaohang,@sDiachigiaohang)
			
			INSERT INTO dbo.tblChiTietDatHang(iSoHD,sMahang,fGiaban,fSoluongmua,fMucgiamgia)
			VALUES(@iSoHD,@sMahang,@fGiaban,@fSoluongmua,@fMucgiamgia)
			SET @iSoHD = @iSoHD +1
		END
	END

	
	EXEC XauHang @chuoi = '001,5,002,9,003,10', @iSoHD =8 ,
	@iMaNV=1, @iMaKH =1, @dNgaydathang ='20210105',@dNgaygiaohang ='20210202', @sDiachigiaohang= N'Hà Nội'

SELECT * FROM dbo.tblMatHang
/*
d. Hãy đảm bảo rằng: khi có 1 nhân viên bị xoá khỏi bảng tblNhanVien
(bằng bất kì cách nào) thì các đơn đặt hàng và đơn nhập hàng của nhân
viên đó sẽ được chuyển đều cho các nhân viên khác có số đơn đặt hàng
và số đơn nhập hàng cao nhất nhưng ít hơn nhân viên bị xoá.
*/

CREATE TRIGGER tg_DropNhanVien ON dbo.tblNhanVien
FOR  DELETE 
AS
BEGIN
	DECLARE @MaNVXoa int,
			@MaNVNhap int,
			@MaNVXuat int,
			@SoHDNVXNhap int,
			@SoHDNVXXuat int,
			@SoHDNVKNhap int,
			@SoHDNVKXuat INT
           -- đầu tiên cho thằng mã = thằng mã bị xóa
	SELECT @MaNVXoa = (SELECT iMaNV FROM deleted)

	-- thứ 2 là đặt số đơn nhập và đơn đặt của nhân viên đó vào 2 biến
	SELECT @SoHDNVXNhap = (SELECT count(iSoHD) FROM  dbo.tblDonDatHang where dbo.tblDonDatHang.iMaNV = @MaNVXoa)
	SELECT @SoHDNVXXuat = (SELECT count(iSoHD)  FROM dbo.tblDonnhaphang where dbo.tblDonnhaphang.iMaNV = @MaNVXoa)

	-- thứ 3 so sách tìm thằng có số đơn lớn nhất mà nhỏ hơn 2 biến đặt ở trên
	SELECT @SoHDNVKNhap = (SELECT TOP 1 count(iSoHD) FROM dbo.tblDonDatHang having count(iSoHD) < @SoHDNVXNhap)
	SELECT @SoHDNVKXuat = (SELECT TOP 1 count(iSoHD)  FROM dbo.tblDonnhaphang having count(iSoHD) < @SoHDNVXXuat)

	-- thứ 4 đặt mã của nv trong bảng đặt và nhập hàng để làm dữ liệu thạy đổi
	SELECT @MaNVNhap = (SELECT iMaNV FROM dbo.tblDonDatHang where dbo.tblDonDatHang.iSoHD = @SoHDNVKNhap )
	SELECT @MaNVXuat = (SELECT iMaNV FROM dbo.tblDonnhaphang where dbo.tblDonnhaphang.iSoHD = @SoHDNVKXuat )

	-- khi tìm đc thì ta đổi mã nv trong bảng đặt và nhập hàng của người bị xóa cho người có số đơn cao nhất nhỏ hơn nv bị xóa
	Update dbo.tblDonDatHang set iMaNV = @MaNVNhap where iMaNV = @MaNVXoa
	Update dbo.tblDonnhaphang set iMaNV = @MaNVXuat where iMaNV = @MaNVXoa
END














