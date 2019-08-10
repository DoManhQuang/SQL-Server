create database QLnhakho1
on primary (name = 'QLnhakho1_dat', filename = 'E:\SQL Sever\Ontap\De04\QLnhakho_dat.mdf',size = 5mb,maxsize = 10mb , filegrowth = 20%)
log on (name = 'QLnhakho1_log', filename = 'E:\SQL Sever\Ontap\De04\QLnhakho_dat.ldf',size = 1mb,maxsize = 50mb , filegrowth = 20%)
go
use QLnhakho1
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
insert into Ton values ('04','Go',20)
insert into Ton values ('05','Go1',20)
insert into Ton values ('06','Go2',20)
insert into Ton values ('07','Go3',20)
insert into Ton values ('08','Go4',20)

insert into Nhap values ('11','01','10',20000,'2018/05/05')
insert into Nhap values ('12','02','10',20000,'2018/05/05')
insert into Nhap values ('13','03','10',20000,'2018/05/05')
insert into Nhap values ('14','03','10',20000,'2018/05/05')
insert into Nhap values ('15','03','10',20000,'2018/05/05')
insert into Nhap values ('16','03','10',20000,'2018/05/05')
insert into Nhap values ('17','03','10',20000,'2018/05/05')

insert into Xuat values ('22','01','5',20000,'2018/05/06')
insert into Xuat values ('25','01','5',20000,'2018/05/06')
insert into Xuat values ('23','02','5',20000,'2018/05/06')
insert into Xuat values ('24','03','5',20000,'2018/05/06')

select * from Ton 
select * from Nhap 
select * from Xuat


select COUNT(*) as 'Soluong' , DongiaN
from Ton inner join Nhap on Ton.MaVT = Nhap.MaVT
where Ton.TenVT like 'Go%'
group by Ton.TenVT , Ton.MaVT , Nhap.DongiaN



/*
	Câu 1 : hãy đưa ra thông kê tiền bán MaVT , TenVT , TienBan = SoluongX*DongiaX
	theo NgayX và MaVT 
*/
create function TKTienBan(@MaVT char(10) , @NgayX date)
returns @BangTK table 
	(
		MaVT char(10),
		TenVT nvarchar(20),
		TienBan int
	)
as 
	begin
		insert into @BangTK
			select  Ton.MaVT , TenVT , sum(SoluongX*DongiaX)
			from Ton inner join Xuat on Ton.MaVT = Xuat.MaVT
			where Ton.MaVT = @MaVT and Xuat.NgayX = @NgayX
			group by Ton.MaVT ,Xuat.NgayX ,TenVT
		return
	end
go
--- test 
select * from TKTienBan('01','2018/05/06')


-- Cau 2 Thong ke tienban cua mavt
create function TKTienBanVT(@MaVT char(10))
returns int
as 
	begin
		declare @Tong int
			select  @Tong = sum(SoluongX*DongiaX)
			from Ton inner join Xuat on Ton.MaVT = Xuat.MaVT
			where Ton.MaVT = @MaVT 
		return @Tong
	end
go

-- test 
select  dbo.TKTienBanVT('01')
-- Câu 3 : Đưa ra hàm thống kê tiền nhập theo MaVT,NgayN
create function TKTienhap(@MaVT char(10) , @NgayN date)
returns @BangTK table (
	TienNhap int		
)
as 
	begin
		insert into @BangTK
		select sum(SoluongN*DongiaN)
		from Nhap
		where MaVT = @MaVT
		group by MaVT
		return
	end
go
-- test 
select *from TKTienhap('02','2018/05/05')

-- câu 4 : Viết bảng trigger cho bang Nhap sao cho MaVT 
-- Cập nhập tăng số lượng ở bảng tồn , ngược lại thì thông báo chưa có MaVT
create trigger Themmoihocsinh
on Sinhvien
for insert
as
	begin 
		declare @Siso int
		Select @Siso = Siso from Lop where MaLop = inserted.MaLop
		if(@Siso <= 80)
			begin
				update Lop set Siso = @Siso + 1 where MaLop = inserted.MaLop
			end
		else
			begin
				raiserror('Lop da full sinh vien',16,1)
				rollback transaction
			end
	end
go

drop trigger NhapHang
select * from Ton 
select * from Nhap 
insert into Nhap values ('22','04','30',20000,'2018/05/05')

--constraint FK_table (ColName) references Name_talbe(colname) on update cascade on delete cascade
