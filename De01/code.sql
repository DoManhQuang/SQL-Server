create database QLBanHangDe1
on primary (name = 'QLBanHangDe1_dat' , filename = 'E:\SQL Sever\De01\QLBanHangDe1_dat.mdf', size = 5mb , maxsize = 10mb ,filegrowth = 20%)
log on (name = 'QLBanHangDe1_log' , filename = 'E:\SQL Sever\De01\QLBanHangDe1_log.ldf', size = 5mb , maxsize = 10mb ,filegrowth = 20%)
go

use QLBanHangDe1
go

create table tblCongty
(
	MaCT char(10) primary key not null,
	TenCT nvarchar(20) not null,
	Trangthai char(15) not null,
	Thanhpho nvarchar(20) not null,
)
create table tblSanpham 
(
	MaSP char (10) primary key not null,
	TenSP nvarchar(20) not null,
	Mausac nvarchar(10) not null,
	Soluong int not null,
	Giaban int not null
)
create table tblCungung
(
	MaCT char(10) not null,
	MaSP char(10) not null,
	Slcungung int not null,
	Ngaycungung date not null,
	constraint PK_tblCungung primary key (MaCT , MaSP) ,
	constraint FP_tblCungung1 foreign key (MaCT) references tblCongty(MaCT) on update cascade
	on delete cascade ,
	constraint FP_tblCungung2 foreign key (MaSP) references tblSanpham(MaSP) on update cascade
	on delete cascade
)
--drop table tblCungung , tblSanpham , tblCongty
insert into tblCongty values ('001','Vinfast','Active','Hai Phong')
insert into tblCongty values ('002','Vinsmart','Active','Hai Phong')
insert into tblCongty values ('003','Bkav','Active','Ha Noi')
insert into tblCongty values ('004','Dolphin','Active','Ha Noi')

insert into tblSanpham values ('101','Lux','Silver',30,3000)
insert into tblSanpham values ('102','Vactive','White',30,1000)
insert into tblSanpham values ('103','Bphone3','Black',30,1000)
insert into tblSanpham values ('104','Website','Blue',30,500)

insert into tblCungung values ('001','101',10,'2018-12-15')
insert into tblCungung values ('002','102',10,'2018-12-15')
insert into tblCungung values ('003','103',10,'2018-12-15')
insert into tblCungung values ('004','104',10,'2018-12-15')
insert into tblCungung values ('002','104',10,'2018-12-15')

select * from tblCongty
select * from tblSanpham
select * from tblCungung

/*
	Câu 2 : Tạo 1 hàm đưa ra các TenSP , Mausac , Soluong , cua tblCongty
	với TenCT va Ngaycungung từ bàn phím .
*/

create function TK_SanPham (@TenCT nvarchar(20), @Ngaycungung date )
returns @BangTK table
(
	TenSP nvarchar(20),
	Mausac nvarchar(10),
	Soluong int 
)
as
	begin
		insert into @BangTK
		select TenSP, MauSac , Soluong 
		from tblSanpham inner join tblCungung on tblSanpham.MaSP = tblCungung.MaSP inner join tblCongty on tblCongty.MaCT = tblCungung.MaCT
		where tblCongty.TenCT = @TenCT and tblCungung.Ngaycungung = @Ngaycungung
		return
	end
go
--test
select *from TK_SanPham('Vinsmart','2018-12-15')
/*
	Câu 3 : Viết hàm thủ tục thêm mới 1 tblCungung với TenCT , TenSP ,
	Slcungung ,Ngaycungung từ bàn phím .
*/
create proc Insert_tblCungung (@TenCT nvarchar(20) , @TenSP nvarchar(20) , 
@Slcungung int , @Ngaycungung date )
as
	begin 
		declare @MaSP char(10)
		declare @MaCT char(10)
			select @MaCT= MaCT , @MaSP = MaSP -- Lấy MaSP va MaCT từ database
			from tblCongty , tblSanpham
			where TenCT = @TenCT and TenSP = @TenSP
		insert into tblCungung values (@MaCT , @MaSP , @Slcungung , @Ngaycungung ) 
	end
go
-- test
exec Insert_tblCungung 'Dolphin','Bphone3',20,'2018-12-16'
select * from tblCungung

/*
	Câu 4 : Tạo trigger Update trên tblCungung cập nhập lại Slcungung
	kiểm tra Slcungung_M - Slcungung_C <= Soluong ? 
	true : cập nhập lại số lượng
	false : thông báo ra màn hình 
*/
create trigger tblCungung_tg 
on tblCungung
for update
as
	begin
		declare @SLmoi int --số lượng mới cung ứng 
		declare @SLcu int -- số lượng cũ cung ứng
		declare @MaSP char(10) -- lấy mã sản phẩm
			select @SLmoi = inserted.Slcungung from inserted
			select @SLcu = deleted.Slcungung from deleted
			select @MaSP = inserted.MaSP from inserted
		if(exists(select * from tblSanpham inner join inserted on tblSanpham.MaSP = inserted.MaSP where Soluong >= (@SLmoi - @SLcu)))
			begin
				update tblSanpham set Soluong = Soluong - (@SLmoi - @SLcu) where MaSP = @MaSP
			end
		else
			begin
				raiserror ('Lỗi Soluong < (SLmoi - SLcu)',16,1)
				rollback transaction
			end
	end
go
--drop trigger tblCungung_tg 
-- test 
select * from tblSanpham
select * from tblCungung
update tblCungung set Slcungung = 20  where MaSP = '103' -- test true 
update tblCungung set Slcungung = 100  where MaSP = '103' -- test false
select * from tblSanpham
select * from tblCungung

/* 
-- Tham Khao
--Câu 4 Tạo trigger
create trigger Cau4
on CUNGUNG for update
As
	Begin
		declare @SLMoi int
		declare @SLCu int
		declare @SoLuong int
		declare @MaSP char(10)
		select @SLMoi=SoLuongCungUng from inserted
		select @SLCu=SoLuongCungUng from deleted
		select @MaSP=MaSP from inserted
		select @SoLuong=SoLuong from SANPHAM inner join inserted on inserted.MaSP= SANPHAM.MaSP
		if(@SLMoi-@SLCu>@SoLuong)
			Begin 
				Raiserror(N'Không thể update vì số lượng không đủ để cung ứng',16,1)
				Rollback Transaction
			End
		else
			Begin
				Update SANPHAM set SoLuong=SoLuong-(@SLMoi-@SLCu) where MaSP=@MaSP
			End
	End
	*/