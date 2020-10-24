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

select COUNT(1)
from "COMMENT"
where POSTID = 1 and ACTIVE = 1

SELECT * FROM POST

select *
from "COMMENT"

INSERT INTO COMMENT VALUES(1,2,1,'HOLA',GETDATE(),'HOLA',1)
INSERT INTO COMMENT VALUES(1,3,1,'HOLA',GETDATE(),'HOLA',1)
INSERT INTO COMMENT VALUES(1,4,1,'HOLA',GETDATE(),'HOLA',0)

select * from INTERACTION

exec Interacton_upsinsertion 4,1,1,'tumascara',null,'prueba buena'
exec Interacton_upsinsertion 3,1,1,'tumascara',0,null
exec Interacton_upsinsertion 1,1,1,'tumascara',1,null


select COUNT(1) 
from INTERACTION
where ISLIKE = 1 and POSTID = 1
--group by POSTID

select  COUNT(1) 
from INTERACTION
where ISLIKE = 0 and POSTID = 1
--group by POSTID

delete from INTERACTION
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

	if (@interactionRegister = 0 and @qty = 1)
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
--trigger para unicamente insertar los comentarios a publicaciones donde sean amigos
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