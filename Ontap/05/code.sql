create database QLHang1
on primary (name = 'QLHang_dat', filename = 'E:\SQL Sever\Ontap\05\QLHang_dat.mdf',size = 5mb,maxsize = 10mb , filegrowth = 20%)
log on (name = 'QLHang_log', filename = 'E:\SQL Sever\Ontap\05\QLHang_log.ldf',size = 1mb,maxsize = 50mb , filegrowth = 20%)
go
use QLHang1
go

create table Hang
(
	MaH char(10) not null primary key,
	TenH nvarchar(20) not null,
	DVTinh char(10),
	SoluongH int not null
)
go

Create table HDBan
(
	MaHD char(10) not null  primary key,
	Ngayban date not null,
	HotenKH nvarchar(20) not null,
	
)
go
create table HangBan
(
	MaHD char(10) not null,
	MaH char(10) not null,
	Soluong int  not null,
	Dongia int not null, 
	constraint PK_HB primary key (MaHD, MaH),
	constraint FK1_HB foreign key (MaHD) references HDBan (MaHD)
	on update cascade on delete cascade ,
	constraint FK2_HB foreign key (MaH) references Hang (MaH)
	on update cascade on delete cascade 
)
go

insert into Hang values ('01','Gach','VND',20) 
insert into Hang values ('02','Go','VND',20)
insert into Hang values ('03','Nhua','VND',20)

insert into HDBan values ('11','2018/05/05','Thoa')
insert into HDBan values ('12','2018/05/05','Thoa1')
insert into HDBan values ('13','2018/05/05','Thoa2')

insert into HangBan values ('11','01','5',20000)
insert into HangBan values ('12','02','5',20000)
insert into HangBan values ('13','01','5',20000)
insert into HangBan values ('11','03','5',20000)

select *from Hang
select *from HDBan
select *from HangBan



-- Cau 2 Tong sl hangban 
create function TongHangban(@TenH char(10) , @NgayBan date)
returns int
as 
	begin
		declare @Tong int
			select  @Tong = sum(Soluong)
			from HangBan inner join HDBan on HangBan.MaHD = HDBan.MaHD 
			inner join Hang on HangBan.MaH = Hang.MaH
			where Hang.TenH = @TenH and HDBan.Ngayban = @NgayBan
		return @Tong
	end
go
 
select dbo.TongHangban('Gach','2018/05/05')

--Câu 3 : Đưa ra hàm thống kê 
create function TKDSKH(@TenKH nvarchar(10) , @NgayX date , @NgayY date)
returns @BangTK table (
	MaHang char(10),
	TenHang nvarchar(20),
	Soluong int,
	Dongia int
)
as 
	begin
		insert into @BangTK
		select Hang.MaH , TenH , Soluong , Dongia 
		from HangBan inner join HDBan on HangBan.MaHD = HDBan.MaHD 
		inner join Hang on HangBan.MaH = Hang.MaH
		where HDBan.HotenKH = @TenKH and HDBan.Ngayban >= @NgayX and HDBan.Ngayban <= @NgayY
		return
	end
go
-- test 
select *from TKDSKH('Thoa','2018/05/05','2018/05/06')

-- cau 4
create function TKtimkiem(@dongiaX int , @dongiaY int)
returns @BangTK table (
	MaHang char(10),
	TenHang nvarchar(20),
	NgayBan date,
	Soluong int,
	Dongia int
)
as 
	begin
		insert into @BangTK
		select Hang.MaH , TenH , Ngayban , Soluong , Dongia 
		from HangBan inner join HDBan on HangBan.MaHD = HDBan.MaHD 
		inner join Hang on HangBan.MaH = Hang.MaH
		where  Dongia  >= @dongiaX and Dongia <= @dongiaY
		return
	end
go

select *from TKtimkiem(1000,30000)


-------
















