create or alter procedure Interacton_upsinsertion
@pUserId int, 
@pPostId int,
@pDeviceId varchar(15),
@pInteraction bit
as
begin
	
	if(@pInteraction = 0)
	begin
		set transaction isolation level serializable

		begin tran;

		declare @cantidadM int
		declare @cantidadN int 

		select @cantidadM = COUNT(1) 
		from INTERACTION
		where ISLIKE = 1 and POSTID = @pUserId
		group by POSTID

		select @cantidadN = COUNT(1) 
		from INTERACTION
		where ISLIKE = 0 and POSTID = @pUserId
		group by POSTID

		if (@cantidadN < @cantidadM)
		begin 
			insert into INTERACTION values (@pUserId,@pPostId,@pDeviceId, GETDATE(), @pInteraction)
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
		insert into INTERACTION values (@pUserId,@pPostId,@pDeviceId, GETDATE(), @pInteraction)
	end 

end 


 
select COUNT(1) 
from INTERACTION
where ISLIKE = 1 and POSTID = 69
group by POSTID

select COUNT(1) 
from INTERACTION
where ISLIKE = 0 and POSTID = 69
group by POSTID


select * from INTERACTION where POSTID = 69

delete from INTERACTION where INTERACTIONID = 126

INSERT INTO INTERACTION VALUES(54,69,'Mercer','2001-10-17 05:08:55',1)
INSERT INTO INTERACTION VALUES(1,69,'Mercer','2001-10-17 05:08:55',0)
INSERT INTO INTERACTION VALUES(2,69,'Mercer','2001-10-17 05:08:55',0)
INSERT INTO INTERACTION VALUES(3,69,'Mercer','2001-10-17 05:08:55',0)

exec Interacton_upsinsertion 3,69,'ola',1

exec Interacton_upsinsertion 50,69,'ola',1

select * from POST where POSTID = 69

--- preguntarle a fercho si en las inserciones normales se tiene que hacer un triggre para validar eso----si
-- preguntar si son dos procedimientos uno para likes y otro para comentarios---no
-- que informacion debe de llevar los likes -- igual que los comentario 

----------------------------------------------------------------------------------------------------------------------------------------------
---- actualizar para que cuando se meta la interacion opuesta del mismo usuario solo se actulice
create or alter TRIGGER Interaction_tiInteractionValidation
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

--duda fercho si a la hora de insertar una interacion sea lo opuesto se actualice el registro -- si
--duda saber si los like deben de contar con la misma informacion que un comentario--si
-- duda si personas que no sean amigos le pueden dar like o comentar post---no


select * from INTERACTION

select *
from FRIENDSHIP F
	inner join POST P on P.POSTID = @idPost

insert into FRIENDSHIP values(1,2)
insert into FRIENDSHIP values(1,3)
insert into FRIENDSHIP values(2,3)

----------------------------------------------------------------------------------------------------------------------------------------
create or alter TRIGGER Comments_tiCommentsValidation
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

-----------------------------

	select * from COMMENT
	SELECT * FROM DEVICE

	SELECT * FROM POST WHERE USERID = 2
	SELECT * FROM FRIENDSHIP

	INSERT INTO COMMENT VALUES(50,69,2,'HOLA',GETDATE(),'BRENNER HUECO')
	INSERT INTO COMMENT VALUES(1,80,2,'HOLA',GETDATE(),'BRENNER HUECO')

	select COUNT(1) 
	from FRIENDSHIP
	where (USERID = 2 and FRIENDID = 1) or (USERID = 1 and FRIENDID = 2)


-----------------------------------------------------------------------------------------------------------------------------------