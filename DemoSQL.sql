create database demo
use demo
create table Product(pid char(30) primary key,
pname nvarchar(100) not null, quantity int, price money, description nvarchar(max),
status bit default 1)
select * from Product
select pid,pname
from Product

select * from Product where quantity=0

insert into Product values('p01','Apple Iphone X',10,1000,'new iphone',1)
insert into Product values('p04','nokia',10,100,'new nokia')
insert into Product(pid,pname,quantity,price,description,status) 
  values('p02','Apple Iphone XS',2,1200,'new iphone XS',1)

insert into Product(pid,pname,quantity,price,description) 
  values('p03','Samsung note9',2,1200,'new samsung  mobile')

update Product set pname='Black berry',quantity=10,price=300,description='new moblie', status=0
 where pid='p08'

