drop table if exists Products;
go

create table Products(
	productId int not null primary key identity(1, 1),
	nombre varchar(100),
	barCode varchar(50) null,
);
go

drop table if exists Products_hist;
go

create table Products_hist(
	hist int not null primary key identity(1, 1),
	productId int,
	nombre varchar(100),
	barCode varchar(50) null,
	typeMove int,
	userChange nvarchar(50),
	host nvarchar(50),
	dateChange datetime
)
go

drop trigger if exists tr_audit_product;
go

create  trigger tr_audit_product on Products
for
	insert, update, delete
as
begin
	if exists (select '' from Inserted I inner join Deleted D on D.productId = I.productId)
	begin
		insert into Products_hist(productId, nombre, barCode, typeMove, userChange, host, dateChange)
		select I.productId, I.nombre, I.barCode, 
		2 as typeMove,
		USER_NAME() as userChange,
		HOST_NAME() as host,
		getdate() as dateChange
		from Inserted I
	end
	else if exists (select '' from Inserted I)
	begin
		insert into Products_hist(productId, nombre, barCode, typeMove, userChange, host, dateChange)
		select I.productId, I.nombre, I.barCode, 
		1 as typeMove,
		USER_NAME() as userChange,
		HOST_NAME() as host,
		getdate() as dateChange
		from Inserted I
	end
	else 
		begin
			insert into Products_hist(productId, nombre, barCode, typeMove, userChange, host, dateChange)
			select D.productId, D.nombre, D.barCode, 
			1 as typeMove,
			USER_NAME() as userChange,
			HOST_NAME() as host,
			getdate() as dateChange
			from Deleted D
		end
end
go

insert into Products( nombre, barCode) values ( 'sdsd', 'wewe');
select * from Products_hist