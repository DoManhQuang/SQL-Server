create database QLKH
on primary ( name = 'QLKH_dat' , filename = 'E:\SQL Sever\QLKH_dat.mdf', size = 5 , maxsize = 10 , filegrowth = 20%)
log on ( name = 'QLKH_log' , filename = 'E:\SQL Sever\QLKH_log.ldf', size = 1 , maxsize = 5 , filegrowth = 20%)
go
use QLKH
go

create table tblKhachhang
(
	CustomersID varchar(10) primary key,
	CustomersName varchar(20) not null,
	CustomersBirthday date not null,
	CustomersAddress varchar(20) not null,
	CustomersJob varchar(20) not null,
)

insert into tblKhachhang values ('001' , 'Jame','1985/05/22','Roma' , 'Computer Vision')
insert into tblKhachhang values ('002' , 'Mary','1985/06/21','Roma' , 'Computer Vision')
insert into tblKhachhang values ('003' , 'Sherlock','1985/08/21','London' , 'Delective')
insert into tblKhachhang values ('004' , 'Kudo Shinichi','1998/12/22','Tokio' , 'Delective')
insert into tblKhachhang values ('005' , 'Ran Mori','1998/05/22','Tokio' , 'Students')
