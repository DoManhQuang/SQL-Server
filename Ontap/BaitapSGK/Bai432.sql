create database DBBai1
on primary ( name = 'DBbai1_dat', filename = 'G:\SQL Sever\Ontap\BaitapSGK.mdf', size = 5mb, maxsize = 10mb, filegrowth = 20%)
log on ( name = 'DBbai1_log', filename = 'G:\SQL Sever\Ontap\BaitapSGK.ldf', size = 1mb, maxsize = 5mb, filegrowth = 20%)
go

create table tblNCC
(
	MSNCC varchar(10) primary key not null,
	Ten_CC nvarchar(30) not null,
	DCCC varchar(30) not null
)
create table tblMH
(
	MSNCC varchar(10) not null,
	MSMH varchar(10) not null,
	Soluong int not null,
	constraint PK_tblMH primary key (MSNCC,MSMH)
)

insert into tblNCC values ('NCC001', 'tencc001', 'dc0001')
insert into tblNCC values ('NCC002', 'tencc002', 'dc0002')
insert into tblNCC values ('NCC003', 'tencc003', 'dc0003')
insert into tblNCC values ('NCC004', 'tencc004', 'dc0004')
insert into tblNCC values ('NCC005', 'tencc005', 'dc0005')

insert into tblMH values ('NCC001', 'MH001', '10')
insert into tblMH values ('NCC001', 'MH002', '10')
insert into tblMH values ('NCC001', 'MH003', '10')
insert into tblMH values ('NCC001', 'MH004', '10')
insert into tblMH values ('NCC001', 'MH005', '10')
insert into tblMH values ('NCC001', 'MH0012', '10')
insert into tblMH values ('NCC001', 'MH0013', '10')
insert into tblMH values ('NCC001', 'MH0015', '10')
insert into tblMH values ('NCC002', 'MH003', '10')
insert into tblMH values ('NCC002', 'MH004', '10')
insert into tblMH values ('NCC005', 'MH0015', '10')
insert into tblMH values ('NCC005', 'MH0012', '10')
insert into tblMH values ('NCC003', 'MH0013', '20')

select * from tblNCC
select * from tblMH

-- Cau a : Hiện số người cung cấp đã cung cấp ít nhất 1 mặt hàng
select tblMH.MSNCC 
from tblMH inner join tblNCC on tblMH.MSNCC = tblNCC.MSNCC
group by tblMH.MSNCC

-- Cau b : Hiện mã số người cung cấp không chup cấp mặt hàng nào
select tblNCC.MSNCC
from tblNCC left join tblMH on tblNCC.MSNCC = tblMH.MSNCC
where Soluong is null
group by tblNCC.MSNCC

-- Cau c : Hiện mã số người cung cấp mặt hàng có mã số là 15

select tblMH.MSNCC 
from tblMH inner join tblNCC on tblMH.MSNCC = tblNCC.MSNCC
where tblMH.MSMH = 'MH0015'

-- Cau d : Hiện mã số NCC đã cung cấp ít nhất 1 mặt hàng nhưng không có mặt hàng 15
select tblMH.MSNCC 
from tblMH inner join tblNCC on tblMH.MSNCC = tblNCC.MSNCC
where tblMH.MSMH != 'MH0015'
group by tblMH.MSNCC

-- Cau e : Hiện địa chỉ nhà cung cấp cung ứng mặt hàng 12 hoặc 13
select tblMH.MSNCC 
from tblMH inner join tblNCC on tblMH.MSNCC = tblNCC.MSNCC
where tblMH.MSMH = 'MH0012' or tblMH.MSMH = 'MH0013'
group by tblMH.MSNCC

-- Cau f : Hiện tên NCC cung cấp tất cả các mặt hàng có giá trên 2000 // khả năng đề sai


-- Cau g : Hiện NCC ở hà nội cung cấp số lượng mặt hàng trên 10
select tblMH.MSNCC
from tblMH inner join tblNCC on tblMH.MSNCC = tblNCC.MSNCC
where DCCC = 'dc0003' and Soluong > 10 -- giả sử hà nội là dc0003
group by tblMH.MSNCC
