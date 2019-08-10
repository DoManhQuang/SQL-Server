create database QLBenhVien
on primary ( name = 'QLBenhvien_dat', filename = 'E:\SQL Sever\Ontap\De01\QLBenhvien_dat.mdf', size = 5mb , maxsize = 10mb , filegrowth = 20% )
log on ( name = 'QLBenhvien_log', filename = 'E:\SQL Sever\Ontap\De01\QLBenhvien_dat.ldf', size = 1mb , maxsize = 5mb , filegrowth = 20% )
go 
use QLBenhVien
go
create table tblDV
(
	MaDV char(10) not null primary key,
	TenDV nvarchar(20) not null ,
	gia integer not null,
)
go
create table tblBenhNhan
(
	MaBN char(10) not null primary key,
	Hoten nvarchar(20) not null,
	Ngaysinh date not null,
	Gioitinh bit 
)
go 
create table tblPhieuKham
(
	Sophieu integer not null,
	MaDV char(10) not null,
	MaBN char(10) not null,
	Ngay date not null,
	Soluong integer not null,

	constraint PK_tblPhieuKham primary key (Sophieu , MaDV) ,
	constraint FK_tblPhieuKham foreign key (MaBN) references tblBenhNhan (MaBN) 
	on update cascade on delete cascade 
)
go 

insert into tblDV values ('123','Mat xa',1000)

insert into tblDV values ('124','bop lung',2000)

insert into tblDV values ('125','Cham cuu',3000)


insert into tblBenhNhan values ('200','Phuong','2018-11-08',1)

insert into tblBenhNhan values ('201','Quang','2018-11-08',1)

insert into tblBenhNhan values ('202','Luong','2018-11-08',0)

insert into tblBenhNhan values ('203','Minh','2018-11-08',0)

insert into tblBenhNhan values ('204','Giang','2018-11-08',1)

insert into tblBenhNhan values ('205','Trang','2018-11-08',0)

insert into tblBenhNhan values ('206','Thoa','2018-11-08',0)


insert into tblPhieuKham values ('01','124','201','2018-11-08',5)

insert into tblPhieuKham values ('02','125','203','2018-11-08',7)

insert into tblPhieuKham values ('03','123','205','2018-11-08',1)

insert into tblPhieuKham values ('04','125','206','2018-11-08',2)

insert into tblPhieuKham values ('05','123','205','2018-11-08',3)

insert into tblPhieuKham values ('07','123','205','2018-11-07',3)
insert into tblPhieuKham values ('06','125','206','2018-11-07',2)


select * from tblDV
select * from tblBenhNhan
select * from tblPhieuKham


Alter view viewCau2
as
select Hoten ,Gioitinh ,Ngay,COUNT(*) as 'So_nguoi'
from tblBenhNhan inner join tblPhieuKham on tblBenhNhan.MaBN = tblPhieuKham.MaBN
where tblBenhNhan.Gioitinh = 0 
group by tblBenhNhan.Hoten , tblBenhNhan.Gioitinh , tblPhieuKham.Ngay

select * from viewCau2

create function Tongtienthu_theongay(@Ngay(date))
return int
as
begin 
	declare @tongtien int
	select @tongtien = Soluong * gia
	from inner join tblPhieuKham.






















