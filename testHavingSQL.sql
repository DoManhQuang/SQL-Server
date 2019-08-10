use QLHang
go

select * from Hangxuat
select * from HDBan
select * from Vattu


select HDBan.Mahd , sum(Dongia*SLBan) as 'TongTien'
from HDBan inner join Hangxuat on HDBan.Mahd = Hangxuat.Mahd inner join Vattu on Vattu.Mavt = Hangxuat.Mavt
group by HDBan.Mahd
having sum(Dongia*SLBan) >= ALL ( 
		select sum(Dongia*SLBan)
from HDBan inner join Hangxuat on HDBan.Mahd = Hangxuat.Mahd inner join Vattu on Vattu.Mavt = Hangxuat.Mavt
group by HDBan.Mahd
)


