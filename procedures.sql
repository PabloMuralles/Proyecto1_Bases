--Procedure to import data from a csv file
create or alter procedure usp_insert_from_csv
@path varchar(100)
as
begin
	declare @bulk_exec varchar(max)
	set @bulk_exec =
	'bulk insert "USER"
	from ''' + @path + '''
	with (
		format = ''CSV'',
		firstrow = 2,
		fieldterminator = '','',
		rowterminator = ''\n''
	)'

	exec(@bulk_exec)
end
----------------------------------------------------------------

--Trigger to create friendship relations within the new user and
--all of users that have the same lastname
create or alter trigger ut_verify_lastname
on "USER"
after insert
as
	declare @userid int
	declare @lastname varchar(50)
	declare @cont int

	select @userid = USERID, @lastname = LASTNAME from inserted

	select @cont = COUNT(*) from "USER"
	where LASTNAME = @lastname

	if (@cont = 2)
	begin		
		insert into FRIENDSHIP values ((select USERID from "USER" where LASTNAME = @lastname and USERID != @userid),@userid)
	end
	
	else if (@cont > 2)
	begin
		drop table if exists temp
		select * into temp from "USER" where LASTNAME = @lastname and USERID != @userid
			declare @id int
			declare c_create_friendship cursor for 
			select USERID from temp
			open c_create_friendship
			fetch c_create_friendship into @id
			while (@@FETCH_STATUS = 0)
			begin
				insert into FRIENDSHIP values (@id,@userid)
				FETCH NEXT FROM c_create_friendship into @id
			end
			close c_create_friendship
			deallocate c_create_friendship
	end
----------------------------------------------------------------
