Create database QuanLyBanHang
on primary (
	name = 'QuanLyBanHang_Dat',
	filename = 'E:\SQL Sever\Bai1\QuanLyBanHang.mdf',
	size = 5MB, maxsize = 20MB , filegrowth = 20%
)
log on ( name = 'QLBH_log', 
		 filename = 'E:\SQL Sever\Bai1\QuanLyBanHang.ldf',
		 size = 1MB, maxsize = 5 MB, filegrowth = 1MB)
go
use QuanLyBanHang
go

Create table HangsxN (
	NumberSX char(10) not null primary key,
	NameH nvarchar(20) not null ,
	FromH nvarchar(50) not null ,
	Telephone nvarchar(20) not null ,
	Mail nvarchar(20) not null ,
)
go 
create table SanphamN(
	NumberSP char(10) not null primary key,
	NumberSX char(10) not null ,
	NameSP nvarchar(20) not null ,
	SoluongH nvarchar(20) not null ,
	Color nchar(10) not null ,
	Giatien nvarchar(20) not null ,
	Donvitien nvarchar(20) not null ,
	Note nvarchar(20) not null ,
	constraint fk_SanphamN_HangsxN foreign key(NumberSX) references
		HangsxN(NumberSX) on update cascade on delete cascade 
)
go

create table NhanVien(
	NumberNV char(10) not null primary key ,
	NameNV nvarchar (20) not null ,
	SexNV char (5) not null,
	FromNV nvarchar(30) not null,
	TelephoneNV nchar(11) not null,
	MailNV nchar (20) ,

)
go
create table Input (
	NumberHD char(10) not null ,
	NumberSP char(10) not null ,
	NumberNV char(10) not null,
	NgayNhap datetime not null,
	SoluongNhap int not null,
	DonGia int not null,
	constraint PK_Input primary key(NumberHD,NumberSP),
	constraint FK_Input_NhanVien foreign key(NumberNV) references
	NhanVien(NumberNV) on update cascade on delete cascade ,
	constraint FK_Input_SanPham foreign key(NumberSP) references
	SanPhamN(NumberSP) on update cascade on delete cascade 
)
go
Create table OutputHD (
	NumberHDX char(10) not null,
	NumberSP char(10) not null,
	NumberNV char(10) not null,
	Ngayxuat datetime not null,
	SoluongXuat int not null,
	constraint PK_OutputHD primary key(NumberHDX,NumberSP),
	constraint FK_OutputHD_NhanVien foreign key(NumberNV) references
	NhanVien(NumberNV) on update cascade on delete cascade
)
go
