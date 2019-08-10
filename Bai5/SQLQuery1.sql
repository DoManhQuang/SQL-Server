Create database QLSV
on primary (name = 'QLSV_dat', filename = 'E:\SQL Sever\Bai5#QLSV.mdf', size = 5mb, maxsize = 10mb, filegrowth = 20% )
log on (
	name = 'QLSV_log',filename ='E:\SQL Sever\Bai5\QLSV.lgf', size = 1mb, maxsize = 5mb, filegrowth = 1mb
)
go
use QLSV 
go
create table Lop
(
	MaLop char(10) primary key,
	Tenlop nvarchar(15) not null,
	Phong char(10) not null,
)
go
create table SinhVien
(
	MaSV char(10) primary key,
	TenSV nvarchar(20) not null,
	MaLop char(10) not null,
	constraint FK_SinhVien foreign key (MaLop) references Lop(MaLop) on update cascade on delete cascade 
)
go

insert into SinhVien values ('1','A','1')
insert into SinhVien values ('2','B','2')
insert into SinhVien values ('3','C','1')
insert into SinhVien values ('4','D','3')

insert into Lop values ('1','CD','1')
insert into Lop values ('2','DH','2')
insert into Lop values ('3','LT','2')
insert into Lop values ('4','xy','4')


-- Câu 1 : Viết hàm thông kê xem mỗi lớp có bao nhiêu sinh viên với mã lớp là tham số truyền .
alter function thongke(@MaLop char(10))
returns int
as
begin 
	declare @soLuong int 
	declare @tenLop nvarchar(20)  
	select @tenLop = Lop.Tenlop, @soLuong = COUNT(SinhVien.MaSV)
	from SinhVien , Lop
	Where SinhVien.MaLop = Lop.MaLop and Lop.MaLop = @maLop
	group by Lop.tenLop
	return @soLuong
end

-- TEST
Select dbo.thongke('1')
-- Câu 2 : Đưa ra DS Sinh viên (Masv , tensv) học lớp với tên lớp được truyền vào từ hàm 
create function DSSinhvien(@Tenlop nvarchar(20) )
returns @Table_DS table
	(
		MaSV char(10),
		TenSV nvarchar(20)
	)
as
begin 
	insert into @Table_DS
	select MaSV , TenSV 
	from SinhVien, Lop
	Where SinhVien.MaLop = Lop.MaLop and Lop.Tenlop = @Tenlop
	return 
end

select * from DSSinhvien('CD')

-- Câu 3 : Đưa ra hàm thống kê sinh viên : Malop , Tenlop , Soluong sinh viên trong lớp của 
-- lớp với tên lớp được nhập từ bàn phím . Nếu lớp đó chưa tồn tại thì thống kê tất cả các lớp , 
-- ngược lại nếu lớp đó đã tồn tại thì chỉ thống kê mỗi lớp đó thôi.

create function ThongkeSV(@Tenlop nvarchar(10))
returns @Table_SV table(
	
		MaLop char(10),
		Tenlop nvarchar(20),
		soLuong int 
)
as
begin
	if( not exists (select MaLop from Lop where Tenlop = @Tenlop)) -- nếu như giá trị sai là đúng
		insert into @Table_SV
		select Lop.MaLop , Lop.Tenlop , COUNT(SinhVien.MaSV)
		from SinhVien , Lop
		Where SinhVien.MaLop = Lop.MaLop
		group by Lop.MaLop , Lop.Tenlop
	else 
		insert into @Table_SV
		select Lop.MaLop, Lop.Tenlop , COUNT(sinhvien.MaSV)
		from Lop, SinhVien
		Where SinhVien.MaLop = Lop.MaLop and Lop.Tenlop = @Tenlop
		group by Lop.MaLop,Lop.Tenlop
		return 
end

select * from ThongkeSV('CD')
select * from ThongkeSV('Khong co')

-- Câu 4 : Đưa ra phòng học của tên sinh viên nhập từ hàm 
create function Tenphonghoc(@TenSV nvarchar(20))
returns @Table_Phonghoc table 
	(
		TenSV nvarchar(20),
		Phong char(10)
	)
as 
begin 
	insert into @Table_Phonghoc
	select TenSV , Phong
	from SinhVien , Lop
	Where SinhVien.MaLop = Lop.MaLop and SinhVien.TenSV = @TenSV
	return 
end

select * from Tenphonghoc('B')

/* Câu 5 : Đưa ra thống kê MaSV , Ten SV , Tenlop với tham biến là phòng . Nếu phòng không tồn tại thì 
	đưa ra tất cả các sinh viên và các phòng . Nếu phòng tồn tai thì đưa ra các sinh viên của các lớp 
	học phòng đó ( Nhiều lớp học cùng phòng)
*/
create function ThongkePhonghoc(@Phong char(10))
returns @Table_Phong table 
(
	MaSV char(10),
	TenSV nvarchar(20),
	Tenlop nvarchar (10)
)
as
begin 
	if(not exists (select Phong from Lop where Lop.Phong = @Phong))
		insert into @Table_Phong
		select MaSV , TenSV , Tenlop
		from SinhVien , Lop
		Where SinhVien.MaLop = Lop.MaLop
		group by SinhVien.MaSV, SinhVien.TenSV,Lop.Tenlop
	else
		insert into @Table_Phong
		select MaSV , TenSV , Tenlop
		from SinhVien , Lop
		Where SinhVien.MaLop = Lop.MaLop and Lop.Phong = @Phong
		group by SinhVien.MaSV, SinhVien.TenSV,Lop.Tenlop
		return 
end

select * from ThongkePhonghoc('1') -- Trùng nhau
select * from ThongkePhonghoc('2') -- Khác Nhau
select * from ThongkePhonghoc('khong co') -- not

/*
	Bài 6 : Viết hàm thống kê xem mỗi phòng có bao nhiêu lóp học . Nếu phòng không tồn tại 
	trả về giá trị 0
*/

alter function TKsoLuonglop(@Phong char(10))
returns char
as
begin 
	if(not exists (select Phong from Lop where Lop.Phong = @Phong))
		return 0
	else
		declare @soLuong char
		select  @soLuong = COUNT(Lop.Malop)
		from Lop 
		Where Lop.Phong = @Phong 
		group by Phong
		return @soLuong
end

select * from dbo.TKsoLuonglop('1')