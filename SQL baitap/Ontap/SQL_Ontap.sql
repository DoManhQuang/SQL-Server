-- On tap view
create database QLKHO
on primary (name = 'QLKHO_dat' , filename = 'E:\SQL baitap\QLKHO.mdf' , size = 5mb, maxsize = 10mb , filegrowth = 20%)
log on ( name = 'QLKHO_log' , filename = 'E:\SQL baitap\QLKHO.lgf' , size = 1mb , maxsize = 5mb , filegrowth = 1mb)
go

use QLKHO 
go 

create table Nhap (
	SoHDN char(10) not null  primary key,
	MaVT char(10) not null,
	SoluongN int not null,
	DongiaN int not null,
	NgayN datetime not null,
	constraint FK_Nhap foreign key (MaVT) references HangTon(MaVT) 
	on update cascade on delete cascade 
)
go 
create table Xuat (
	SoHDX char(10) not null  primary key ,
	MaVT char (10) not null,
	SoluongX int not null,
	DongiaX int not null,
	NgayX datetime not null,
	constraint FK_Xuat foreign key(MaVT) references HangTon(MaVT)
	on update cascade on delete cascade
)
go
create table HangTon (
	MaVT char(10) not null primary key,
	TenVT char(20) not null,
	SoluongT int not null,
)
go

insert into HangTon values ('111','Apple',10)
insert into HangTon values ('112','Samsung',10)
insert into HangTon values ('113','Oppo',10)
insert into HangTon values ('114','Bphone',10)
insert into HangTon values ('115','Honor',10)

insert into Xuat values ('222','111',10,1000,10/10/2018)
insert into Xuat values ('223','112',10,900,11/10/2018)
insert into Xuat values ('224','113',10,800,12/10/2018)
insert into Xuat values ('225','114',10,700,13/10/2018)
insert into Xuat values ('226','115',5,600,14/10/2018)

insert into Nhap values ('333','111',5,1000,11/11/2018)
insert into Nhap values ('334','112',5,900,12/11/2018)
insert into Nhap values ('335','113',5,800,13/11/2018)
insert into Nhap values ('336','114',5,700,14/11/2018)
insert into Nhap values ('337','115',10,600,15/11/2018)

select * from Xuat 
select * from Nhap 
select * from HangTon

-- Cau 2 : Thống kê tiền bán theo mã vật tư gồm MaVT , TenVT , TienBan ( Tien Ban = SoLuongX * DongiaX )
create view Cau2
as
select HangTon.MaVT,TenVT , SUM (SoluongX * DongiaX) as 'Tien Ban'
from Xuat inner join HangTon on Xuat.MaVT = HangTon.MaVT
group by HangTon.MaVT,TenVT

select * from Cau2 

-- Câu 3 : Thông kê Số Lượng Xuất theo tên Vật tư 

create view Cau3
as
select HangTon.TenVT , SUM (SoluongX) as 'Tong So Luong'
from Xuat inner join HangTon on Xuat.MaVT = HangTon.MaVT
group by HangTon.TenVT

select * from Cau3
drop view Cau3

-- Câu 4 : Thống Kê Số Lượng Nhập theo tên Vật Tư
create view Cau4
as
select HangTon.TenVT , SUM (SoluongN) as 'Tong so Luong Nhap '
from Nhap inner join HangTon on Nhap.MaVT = HangTon.MaVT
group by HangTon.TenVT

select * from Cau4 

-- Câu 5 : Đưa ra tổng số lượng còn trong kho biết còn = nhap - xuat + ton theo từng nhóm vật tư
create view Cau5
as
select HangTon.MaVT,HangTon.TenVT , SUM (SoluongN) - SUM (SoluongX) + SUM(SoluongT) as 'Tong ton'
from Nhap inner join HangTon on Nhap.MaVT = HangTon.MaVT 
	 inner join Xuat on Xuat.MaVT = HangTon.MaVT  
group by HangTon.MaVT,HangTon.TenVT

select * from Cau5

---------------------------------------------------
----------------------------------------------------

-- Ôn Tập Đề Thi : 
create database QLSach 
on primary ( name = 'QLSach_dat' , filename = 'E:\SQL baitap\Ontap\QLsach.mdf' , size = 5mb, maxsize = 10mb, filegrowth = 20%)
log on (name = 'QLSach_log' ,filename = 'E:\SQL baitap\Ontap\QLsach.lgf', size = 1mb , maxsize = 5mb , filegrowth = 20%)
go 

use QLSach
go 

create table NhaSanXuat (
	MaNXS char (10) not null primary key,
	TenNXS char(10) not null,
	SoluongXB int not null,
)
go
create table TacGia (
	MaTG char(10) not null primary key ,
	TenTG char(20) not null,
) 
go 
create table Sach (
	MaSach char (10) not null primary key,
	TenSach char (10) not null ,
	NamXB datetime not null,
	Soluong int not null,
	Dongia int not null,
	MaTG char (10) not null,
	MaNXB char (10) not null,
	constraint FK_Sach1 foreign key (MaTG) references TacGia(MaTG) 
	on update cascade on delete cascade ,
	constraint FK_Sach2 foreign key (MaNXB) references NhaSanXuat(MaNXS)
	on update cascade on delete cascade
)
go


insert into NhaSanXuat values ('111','Kim Dong',2000)
insert into NhaSanXuat values ('112','Thoi Dai',1000)
insert into NhaSanXuat values ('113','Giao Duc',3000)

insert into TacGia values ('1412','Ghoso')
insert into TacGia values ('7777','Kisimoto')
insert into TacGia values ('2212','Manh Quang')

insert into Sach values ('222','Conan' ,'10/10/2010', 100 , 20000 ,'1412','111')
insert into Sach values ('223','Naruto' ,'11/10/2010', 100 , 20000 ,'7777','111')
insert into Sach values ('224','Trinh Tham' ,'12/10/2010', 100 , 20000 ,'2212','112')
insert into Sach values ('225','Toan Hoc','9/10/2010', 100 , 20000 ,'2212','113')
insert into Sach values ('226','Vat Ly','9/10/2011', 100 , 20000 ,'2212','113')

-- Câu 2 : Tạo view thống kê số lượng sách xuất bản theo đơn từng nhà sản xuất 
-- gồm các thông tin MaNSX , TenNSX , sum so luong XB

create view Cau2
as 
select NhaSanXuat.MaNXS,NhaSanXuat.TenNXS , SUM(SoluongXB) as 'Tong so luong XB '
from NhaSanXuat inner join Sach on NhaSanXuat.MaNXS = Sach.MaNXB 
	inner join TacGia on TacGia.MaTG = Sach.MaTG
group by NhaSanXuat.MaNXS,TenNXS 

select * from Cau2

-- Câu 3 : Tạo 1 hàm đưa ra MaSach , TenSach  , TenTG , Dongia của nhà sản xuất có tên nhập từ bàn phím với
-- năm xuất bản từ x đến y với x,y được nhập từ bàn phím 

create function Thongke_1(@TenNXB char(10) , @x datetime , @y datetime )
	returns @Thongke table (MaSach char(10) , TenSach char(10) , TenTG char (10) , Dongia int )
	
	as begin 
	insert into @ThongKe
	select Sach.MaSach , Sach.TenSach , TacGia.TenTG , Sach.Dongia
	from Sach inner join TacGia on Sach.MaTG = TacGia.MaTG
	inner join nhasanxuat on nhasanxuat.manxs=sach.manxb
	where YEAR (NamXB) between @x and @y and
	NhaSanXuat.TenNXS = @TenNXB 
	return
 end 
select * from dbo.Thongke_1('Giao Duc',2010,2011)


	