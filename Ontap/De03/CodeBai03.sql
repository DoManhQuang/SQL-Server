create database QLnhakho
on primary (name = 'QLnhakho_dat', filename = 'E:\SQL Sever\Ontap\De03\QLnhakho_dat.mdf',size = 5mb,maxsize = 10mb , filegrowth = 20%)
log on (name = 'QLnhakho_log', filename = 'E:\SQL Sever\Ontap\De03\QLnhakho_dat.ldf',size = 1mb,maxsize = 50mb , filegrowth = 20%)
go
use QLnhakho
go
create table Ton
(
	MaVT char(10) not null primary key,
	TenVT nvarchar(20) not null,
	SoluongT int not null
)
go

Create table Nhap
(
	SoHDN char(10) not null  primary key,
	MaVT char(10) not null ,
	SoluongN int not null,
	DongiaN int not null,
	NgayN date not null, 
	constraint FK_Nhap foreign key (MaVT) references Ton (MaVT) 
	on update cascade on delete cascade 
)
go
create table Xuat
(
	SoHDX char(10) primary key,
	MaVT char(10) not null,
	SoluongX int  not null,
	DongiaX int not null, 
	NgayX date not null,
	constraint FK_Xuat foreign key (MaVT) references Ton (MaVT)
	on update cascade on delete cascade
)
go
insert into Ton values ('01','Gach',20)
insert into Ton values ('02','Da',20)
insert into Ton values ('03','Soi',20)

insert into Nhap values ('11','01','10',20000,'2018/05/05')
insert into Nhap values ('12','02','10',20000,'2018/05/05')
insert into Nhap values ('13','03','10',20000,'2018/05/05')
insert into Nhap values ('14','03','10',20000,'2018/05/05')
insert into Nhap values ('15','03','10',30000,'2018/05/05')

insert into Xuat values ('22','01','5',20000,'2018/05/06')
insert into Xuat values ('25','01','5',20000,'2018/05/06')
insert into Xuat values ('23','02','5',20000,'2018/05/06')
insert into Xuat values ('24','03','5',20000,'2018/05/06')

select * from Ton 
select * from Nhap 
select * from Xuat

select Ton.MaVT , TenVT , sum(SoluongN*DongiaN) as 'TienNhap'
from Ton inner join Nhap on Ton.MaVT = Nhap.MaVT
where NgayN = '2018/05/05' 
group by Ton.MaVT , Ton.TenVT





--Đưa ra table chứa NgayN , Mavt , Tenvt , Tiennhap = soluongN*dongiaN 
-- tham so là Mavt va NgayN
create function TKTiennhap(@MaVT char(10) , @NgayN date)
returns @BangTK table(
	MaVT char(10),
	NgayN date,
	TenVT nvarchar(20),
	TienNhap int
)
as 
	begin
	insert into @BangTK
		select Nhap.MaVT , NgayN , TenVT , Sum(SoluongN*DongiaN) as 'TienNhap'
		from Nhap inner join Ton on Nhap.MaVT = Ton.MaVT
		where Nhap.MaVT = @MaVT and Nhap.NgayN = @NgayN 
		group by Nhap.MaVT , NgayN , Ton.TenVT
	return 
	end
go
-- test

select * from TKTiennhap('01','2018/05/05')

-- Cau 2 : Thống kê tổng số lượng xuất và 
--TienX = soluong X * dongiaX theo tenVT và NgayX

create function TKTienxuat(@TenVT nvarchar(20) , @NgayX date)
returns int
as
	begin
			declare @TienX int
			select  @TienX = Sum(SoluongX*DongiaX) 
			--Tổng số lượng xuất và tổng tiền xuất 
			from Xuat inner join Ton on Xuat.MaVT = Ton.MaVT
			where Ton.TenVT = @TenVT and Xuat.NgayX = @NgayX
			group by Ton.TenVT , Xuat.NgayX 
			return @TienX
	end
go 
--drop function TKTienxuat
-- test 
select dbo.TKTienxuat('Gach','2018/05/06')

/*
	Viết trigger cho bảng Xuat sao cho khi xuất ở bảng
	Xuất hợp lệ . Nghĩa là số hàng xuất không quá số lượng 
	trong bảng Ton thì cho Bán và update . trái lại 
	Roll back đồng thời đưa ra thông báo "Hãy kiểm tra
	Mavt hoặc số lượng xuất " 
*/

create trigger TRG_HoaDon
on Xuat
for insert 
as
	begin
		declare @SoluongT int -- số lượng hiện có 
		declare @SoluongX int -- số lượng bán 
		select  @SoluongT = SoluongT from Ton 
		select @SoluongX = SoluongX from inserted
		if (@SoluongT < @SoluongX)
			begin
				Raiserror('Hãy kiểm tra Mavt hoặc số lượng xuất',16,1)
				Rollback transaction
			end
		else
			update Ton set SoluongT = SoluongT - @SoluongX 
			from Ton inner join inserted on Ton.MaVT = inserted.MaVT 
	end
go
--- test
select * from Ton  
select * from Xuat
--drop trigger TRG_HoaDon
insert into Xuat values ('27','03','20',20000,'2018/05/06')


-------- Đề 02
/*
	Câu 1 : Tạo hàm đưa thông kê tiền bán Gồm MaVT , TenVT , Tienban = soluongX * dongiaX
	theo ngayX và Mavt
*/
/*
create function TKTienBan(@MaVT char(10),@NgayX date)
returns @BangTK table
	(
		MaVT char(10),
		TenVT nvarchar(10),
		Tienban int
	)
as 
	begin
		insert into @BangTK
			select Xuat.MaVT , TenVT , Sum( soluongX * dongiaX) 
			from Ton inner join Xuat on Ton.MaVT = Xuat.MaVT
			where Xuat.MaVT = @MaVT and Xuat.NgayX = @NgayX
			group by Xuat.MaVT ,Xuat.NgayX
		return
	end
go
--- test
--drop function TKTienBan
select * from Ton
select * from TKTienBan('02','2018/05/06')
*/
