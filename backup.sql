backup database Test1 to disk = 'd:\test.bak';
go 

restore database Test1 file = 'test1' from disk = 'd:\test.bak';
go