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
			drop table temp
			close c_create_friendship
			deallocate c_create_friendship
	end
----------------------------------------------------------------
--Trigger to verify if a friendship already exists,
--if it does the friendship is not inserted
create or alter trigger ft_verify_friendship
on FRIENDSHIP
instead of insert
as
	declare @user1 int
	declare @user2 int
	declare @cont int

	select @user1 = USERID, @user2 = FRIENDID from inserted

	select @cont = COUNT(*) from FRIENDSHIP
	where (USERID = @user1 and FRIENDID = @user2) or (USERID = @user2 and FRIENDID = @user1)

	if (@cont = 0)
	begin		
		insert into FRIENDSHIP values (@user1,@user2)
	end

	else
	begin
		print 'El usuario ' + CAST(@user1 as varchar) + ' y el usuario ' +CAST(@user2 as varchar) + ' ya son amigos.'
	end
----------------------------------------------------------------
--Procedure to create a random number of posts
--for a random number of random users
create or alter procedure psp_gen_random_posts
as
declare @random1 int
declare @random2 int
declare @cont1 int
declare @cont2 int
declare @total_users int
declare @userid int
declare @deviceid int
begin
	select @cont1 = 0
	select @cont2 = 0
	select @total_users = COUNT(*) from "USER"
	select @random1 = FLOOR(RAND()*(@total_users))+1;
	select @random2 = FLOOR(RAND()*(20))+1;
	print @random1
	print @random2
	print @total_users

	while @cont1 != @random1
	begin
			select top 1 @userid = USERID from "USER" order by NEWID()
			
			while @cont2 != @random2
			begin
					begin tran
					select top 1 @deviceid = DEVICEID from DEVICE order by NEWID()
					insert into POST values (@userid,1,@deviceid,'255.255.255.255',GETDATE(),'Post generado aleatoriamente :)')
					select @cont2 = @cont2 + 1

					if @@ERROR <> 0
					begin
							print 'No se pudo realizar la transacción.'
							rollback
					end

					else
					begin
							commit
					end
			end
			select @cont1 = @cont1 + 1
	end
end
----------------------------------------------------------------
--Procedure to delete a comment
create or alter procedure csp_delete_comment
@commentid int
as
begin
	delete from COMMENT where COMMENTID = @commentid
end

--Trigger to update selected queued comments to active
create or alter trigger ct_queue_comments
on COMMENT
instead of delete
as
	declare @newcomment int
	declare @postid int
	declare @commentid int
	declare @total_comments int

	select @commentid = COMMENTID from deleted

	if (@commentid is not NULL)
	begin
		select @postid = POSTID from COMMENT where COMMENTID = @commentid
		delete from COMMENT where COMMENTID = @commentid
		select top 1 @newcomment = COMMENTID from COMMENT where (status = 0) and POSTID = @postid order by COMMENTDATETIME desc

		if (@newcomment is not NULL)
		begin
			update COMMENT set STATUS = 1 where COMMENTID = @newcomment
		end	
	end

	else
	begin
		print 'El comentario ' + CAST(@commentid as varchar) + ' no existe.'
	end
----------------------------------------------------------------
--trigger para validar las inserciones de las interacciones
 create or alter trigger Interaction_tiInteractionValidation
on INTERACTION 
instead of insert 
AS
DECLARE @idPost int,
        @idUser int,
		@isLike bit,
        @interactionRegister int,
		@deviceIp varchar(15),
		@dateTime datetime,
		@idFriend int,
		@qty int


	SELECT @idPost = USERID, @idUser = POSTID, @isLike = ISLIKE, @deviceIp = DEVICEIP, @dateTime = INTERECTIONDATETIME
	FROM inserted

	select @idFriend = USERID
	from POST
	where POSTID = @idPost

	select @qty = COUNT(1) 
	from FRIENDSHIP
	where (USERID = @idUser and FRIENDID = @idFriend) or (USERID = @idFriend and FRIENDID = @idUser)
 

	select @interactionRegister = COUNT(1)
	from INTERACTION 
	where POSTID  = @idPost and USERID = @idUser

	if (@interactionRegister is null and @qty = 1)
	begin
		insert into INTERACTION values (@idUser,@idPost,@deviceIp,@dateTime,@isLike)
	end 
	else
	begin
		if(@qty != 1)
		begin 
			print 'Los usuarios no son amigos'
		end 
		else 
		begin 
			print 'Ya existe una interaccion'
		end
	end
----------------------------------------------------------------
--trigger para verificar la insercion de los comentarios
create or alter trigger Comments_tiCommentsValidation
on COMMENT 
instead of insert 
AS
DECLARE @idPost int,
        @idUser int,
		@deviceIp varchar(15),
		@dateTime datetime,
		@idFriend int,
		@qty int,
		@content varchar(200),
		@deviceId int

	SELECT @idPost = USERID, @idUser = POSTID,@deviceId = DEVICEID ,@deviceIp = DEVICEIP, @dateTime = COMMENTDATETIME, @content = COMMENTCONTENT
	FROM inserted

	select @idFriend = USERID
	from POST
	where POSTID = @idPost

	print CAST(@idFriend as varchar)

	select @qty = COUNT(1) 
	from FRIENDSHIP
	where (USERID = @idUser and FRIENDID = @idFriend) or (USERID = @idFriend and FRIENDID = @idUser)


	if (@qty = 1)
	begin
		insert into COMMENT values (@idPost,@idUser,@deviceId,@deviceIp,@dateTime,@content)
	end 
	else
	begin
		 
		 print 'No se puede realizar la accion'
	end
----------------------------------------------------------------
--Procedure to add one to max_friends of users that have posts
--with 15 likes or more in a given day
create or alter procedure pincrement_max_friends
as
	declare @userid int
	declare @maxfriends int

	drop table if exists temp2
	select U.USERID, U.MAXFRIENDS into temp2 from "USER" U
	inner join POST P on P.USERID = U.USERID
	inner join INTERACTION I on I.POSTID = P.POSTID
	where (DAY(P.POSTDATETIME) = DAY(GETDATE())) and (I.ISLIKE = 1)
	group by U.USERID, U.MAXFRIENDS, P.POSTID
	having COUNT(P.POSTID) >= 15
	
	declare c_inc_friends cursor for 
	select USERID from temp2
	open c_inc_friends
	fetch c_inc_friends into @userid
	while (@@FETCH_STATUS = 0)
		begin
			select @maxfriends = MAXFRIENDS from "USER" where USERID = @userid
			update "USER" set MAXFRIENDS = @maxfriends + 1
			where USERID = @userid
			FETCH NEXT FROM c_inc_friends into @userid
		end
	drop table temp2
	close c_inc_friends
	deallocate c_inc_friends
-------------------------------------------------------------------------
-- procedimiento para las inserciones de interaciones(comentario o likes)
-- si like o dislike es nulo y el contenido del comentario no lo es inserta el comentario si es al reves inseta un like o dislile
create or alter procedure Interacton_upsinsertion
@pUserId int, 
@pPostId int,
@pDeviceId int,
@pDeviceIp varchar(15),
@pIsLike bit,
@pComment varchar(200)
as
begin
	if(@pIsLike is not null and @pComment is null)
	begin
				if(@pIsLike = 0)
				begin
					set transaction isolation level serializable

					begin tran;

					declare @cantidadM int
					declare @cantidadN int 

					select @cantidadM = COUNT(1) 
					from INTERACTION
					where ISLIKE = 1 and POSTID = @pPostId
					

					select @cantidadN = COUNT(1) 
					from INTERACTION
					where ISLIKE = 0 and POSTID = @pPostId
					

					if (@cantidadN < @cantidadM)
					begin 
						insert into INTERACTION values (@pUserId,@pPostId,@pDeviceId,@pDeviceIp, GETDATE(), @pIsLike)
						commit;
					end 
					else
					begin
						print 'La cantidad de me gusta no es sufienta para insertar un no me gusta'
						commit;
					end 
				end
				else
				begin
					insert into INTERACTION values (@pUserId,@pPostId,@pDeviceId,@pDeviceIp, GETDATE(), @pIsLike)
				end 
	end
	else
	begin
				set transaction isolation level serializable

				begin tran;

				if((select COUNT(1) from "COMMENT" where POSTID = 1 and ACTIVE = 1) >= 3)
				begin
					INSERT INTO COMMENT VALUES(@pPostId,@pUserId,@pDeviceId,@pDeviceIp,GETDATE(),@pComment,0)
					commit;
				end
				else
				begin 
					INSERT INTO COMMENT VALUES(@pPostId,@pUserId,@pDeviceId,@pDeviceIp,GETDATE(),@pComment,1)
					commit;
				end
	end 

end 