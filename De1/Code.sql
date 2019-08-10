create database QLBanHangDe2 
on primary ( name = 'QLBanHang_dat' ,filename = 'E:\SQL Sever\De1\QLBanHangDe2_dat.mdf' ,size = 5mb , maxsize = 10mb , filegrowth = 20%)
log on ( name = 'QLBanHang_log' ,filename = 'E:\SQL Sever\De1\QLBanHangDe2_log.ldf' ,size = 5mb , maxsize = 10mb , filegrowth = 20%)
go
use QLBanHangDe2
go
create table tblCongty
(
	MaCT char(5) primary key not null,
	TenCT nvarchar(10) not null,
	Trangthai nvarchar(10) not null,
	Thanhpho nvarchar(10) not null,
)

create table tblSanpham
(
	MaSP char(5) primary key not null,
	TenSP nvarchar(10)  not null,
	Mausac nvarchar(5)  not null,
	Soluong int  not null,
	Giaban int  not null,
)
create table tblCungung(
	MaCT char(5) not null,
	MaSP char(5) not null,
	Slcungung int not null,
	Ngaycungung date not null,
	constraint PK_tblCungung primary key (MaCT,MaSP),
	constraint FK1_tblCungung foreign key (MaCT) references tblCongty(MaCT) -- references ở bảng nào ? 
	on update cascade on delete cascade,
	constraint FK2_tblCungung foreign key (MaSP) references tblSanpham(MaSP)
	on update cascade on delete cascade
)
go
--drop table tblCungung , tblSanpham , tblCongty

insert into tblCongty values('01','Vinfast','Active','HaiPhong')
insert into tblCongty values('02','Bkav','Active','HaNoi')
insert into tblCongty values('03','Dolphin','Active','HaUI')

insert into tblSanpham values ('11','Car','red',50,10000) -- 10000 $
insert into tblSanpham values ('12','Bphone','Black',50,400) -- 400 $
insert into tblSanpham values ('13','website','blue',50,200) -- 200 $

insert into tblCungung values ('01','11',10,'2018-12-12')
insert into tblCungung values ('02','12',10,'2018-12-12')
insert into tblCungung values ('03','13',10,'2018-12-12')
insert into tblCungung values ('02','13',10,'2018-12-12')

select *from tblCongty
select * from tblSanpham
select * from tblCungung

/*
	Câu 2 : Viết hàm đưa ra tổng tiền của 1 công ty cung ứng trong 
	1 năm nào đó với TenCT va Năm cung ứng nhập vào từ bàn phím
	trong đó TienCU = slcungung * giaban_1sp 
*/
create function TK_TCU_Congty(@TenCT nvarchar(10) , @Nam int)
returns int 
as
	begin
		declare @TienCU int 
			select @TienCU = sum(Slcungung*Giaban)
			from tblSanpham inner join tblCungung on tblSanpham.MaSP = tblCungung.MaSP 
			inner join tblCongty on tblCongty.MaCT = tblCungung.MaCT
			where tblCongty.TenCT = @TenCT and Year(Ngaycungung) = @Nam
		return @TienCU
	end
go
--drop function TK_TCU_Congty
-- test
select dbo.TK_TCU_Congty('Bkav',2018)
/*
	Câu 3 : Viết hàm thủ tục Thêm mới 1 cung ứng với TenCT
	, TenSP , Slcungung , Ngaycungung nhập từ bàn phím
*/
/*
	tblCungung ( @MaCT , @MaSP ,@Slcungung , @Ngaycungung )
	1 Congty -> 1 MaCT
	1 SanPham -> 1 MaSP
*/
create PROCEDURE Insert_tblCungung(@TenCT nvarchar(10) , @TenSP nvarchar(10) , @Slcungung int , @Ngaycungung date)
as
	begin
	 -- Lấy mã sản phẩm -- Lấy mã công ty
		declare @MaSP char(10)
		declare @MaCT char(10)
			select @MaSP = MaSP ,  @MaCT = MaCT
			from tblSanpham ,tblCongty
			where TenSP = @TenSP and TenCT = @TenCT
		insert into tblCungung values (@MaCT,@MaSP,@Slcungung,@Ngaycungung)
	end
go
--drop PROCEDURE Insert_tblCungung
--test
select * from tblCungung
exec Insert_tblCungung 'Bkav','Car',10,'2018-12-13' -- đã test
select * from tblCungung
/*
-- tham khảo
create Proc Cau3(@TenCT nvarchar(30),@TenSP nvarchar(30),@SoLuongCungUng int,@NgayCU date)
As
	Begin
		if(exists(select * from CONGTY where TenCT=@TenCT)and exists(select * from SANPHAM where TenSP=@TenSP))
			Begin
				declare @MaCT char(10)
				declare @MaSP char(10)
				select @MaCT=MaCT from CONGTY where TenCT=@TenCT
				select @MaSP=MaSP from SANPHAM where TenSP=@TenSP
				insert into CUNGUNG values(@MaCT,@MaSP,@SoLuongCungUng,@NgayCU)
			End
		else
			print(N'Không thể thêm')
	End

*/
/*
	Câu 4 : Tạo trigger insert cho tblCungung để thêm mới 1 sản
	phẩm cung ứng . Kiểm tra xem Slcungung <= soluong ? 
	true : cập nhập tblSanpham
	false : đưa ra thông báo lỗi 
*/
create trigger Insert_tblCungung_tg 
on tblCungung
for insert
as
	begin
		declare @Slcungung int
		declare @MaSP char(10)
		if(exists (select * from tblSanpham inner join inserted on tblSanpham.MaSP = inserted.MaSP where inserted.Slcungung <= tblSanpham.Soluong))
			begin
				select @Slcungung = inserted.Slcungung from inserted 
				select @MaSP = inserted.MaSP from inserted
				update tblSanpham set Soluong = Soluong - @Slcungung where MaSP = @MaSP
			end
		else
			begin
				raiserror('Khong dap ung du so luong cung ung ',16,1)
				rollback transaction 
			end
	end
go
select * from tblCungung
select * from tblSanpham
insert into tblCungung values ('01','13',20,'2018-12-13') -- true :  đã test 
insert into tblCungung values ('01','12',100,'2018-12-13') -- false : đã test