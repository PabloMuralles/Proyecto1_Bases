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
		insert into INTERACTION values (@pUserId,@pPostId,@pDeviceId,@pDeviceIp, GETDATE(), @pIsLike)
	end
	else
	begin
		INSERT INTO COMMENT VALUES(@pPostId,@pUserId,@pDeviceId,@pDeviceIp,GETDATE(),@pComment,0)
	end 

end 
-----------------------
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

exec Interacton_upsinsertion 2,2,1,'223dfh',1,null

exec Interacton_upsinsertion 2,2,1,'fasdfm12',1,null

exec Interacton_upsinsertion 3,2,1,'fasdfm12',0,null

exec Interacton_upsinsertion 3,2,1,'fasdfm12',1,null

exec Interacton_upsinsertion 4,2,1,'fasdfm12',0,null

exec Interacton_upsinsertion 4,2,1,'fasdfm12',1,null

exec Interacton_upsinsertion  
--- preguntarle a fercho si en las inserciones normales se tiene que hacer un triggre para validar eso----si
-- preguntar si son dos procedimientos uno para likes y otro para comentarios---no
-- que informacion debe de llevar los likes -- igual que los comentario 

select * from POST where POSTID = 2

select * from FRIENDSHIP where USERID = 45

insert into FRIENDSHIP values (78,4)

delete from FRIENDSHIP where FRIENDSHIPID = 11

select * from INTERACTION 

select ISLIKE from INTERACTION where USERID = 3 and POSTID = 2
----------------------------
exec Interacton_upsinsertion 2,1,1,'fasdfm12',null,'hola'

exec Interacton_upsinsertion 2,58,1,'fasdfm12',null,'hola'

exec Interacton_upsinsertion 2,58,1,'fasdfm12',null,'hola'


exec Interacton_upsinsertion  58,3,1,'fasdfm12',null,'hola'

select * from COMMENT where POSTID = 3

select * from POST where POSTID = 3


insert into FRIENDSHIP values (41,58)

select * from FRIENDSHIP

select POSTID
from "COMMENT"
where ACTIVESTATUS = 1
group by POSTID
having (COUNT(1) < 3)

--probamos que inserta 0 cuando ya hay 3 comentarios activos
--probasmos que no se inserte si no son amigos
--inserta correctamente cuando hay menos de 3 comentarios activos

--------------------------------------------------------------------------------------------------------------------------------------------------------
---- actualizar para que cuando se meta la interacion opuesta del mismo usuario solo se actulice
create or alter TRIGGER Interaction_tiInteractionValidation
on INTERACTION 
instead of insert 
AS
DECLARE @idPost int,
        @idUser int,
		@isLike bit,
        @interactionRegister int,
		@deviceId int,
		@deviceIp varchar(15),
		@dateTime datetime,
		@idFriend int,
		@qty int,
		@cantidadM int,
		@cantidadN int,
		@tempInteraction bit,
		@tempIdInteraction int

	set transaction isolation level serializable

	begin tran;

	SELECT @idPost = POSTID, @idUser = USERID, @isLike = ISLIKE, @deviceId = DIVICEID ,@deviceIp = DEVICEIP, @dateTime = INTERACTIONDATETIME
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

	select @cantidadM = COUNT(1) 
	from INTERACTION
	where ISLIKE = 1 and POSTID = @idPost
					

	select @cantidadN = COUNT(1) 
	from INTERACTION
	where ISLIKE = 0 and POSTID = @idPost

	if (@interactionRegister = 0 and @qty = 1)
	begin
		if(@isLike = 0)
		begin 
			if (@cantidadN <= @cantidadM)
			begin 
				insert into INTERACTION values (@idUser,@idPost,@deviceId,@deviceIp,@dateTime,@isLike)
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
			insert into INTERACTION values (@idUser,@idPost,@deviceId,@deviceIp,@dateTime,@isLike)
			commit;
		end 
	end 
	else
	begin
		if(@qty < 1)
		begin 
			print 'Los usuarios no son amigos'
			commit;
		end 
		else 
		begin 
			if(@interactionRegister = 1)
			begin
				select @tempInteraction = ISLIKE from INTERACTION where USERID = @idUser and POSTID = @idPost
				if(@tempInteraction = @isLike)
				begin
						print 'Ya existe una interaccion'
						commit;
				end
				else
				begin
					select @tempIdInteraction = INTERACTIONID
					from INTERACTION 
					where POSTID  = @idPost and USERID = @idUser
					if(@isLike = 0)
					begin
						set @cantidadM = @cantidadM -1 
						set @cantidadN = @cantidadN + 1
						if (@cantidadN <= @cantidadM)
						begin
							update INTERACTION
							set ISLIKE = @isLike, INTERACTIONDATETIME = GETDATE()
							where INTERACTIONID = @tempIdInteraction
							commit;
						end 
						else 
						begin 
							print 'No se puede actualizar ya que la cantidad de no me gusta es mayor a la de me gusta'
							commit;
						end
					end
					else
					begin 
						update INTERACTION
						set ISLIKE = @isLike, INTERACTIONDATETIME = GETDATE()
						where INTERACTIONID = @tempIdInteraction
						commit;
					end

				end
			end
			else
			begin
				print 'Ya existe una interaccion'
				commit;
			end
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

---------------------------------------------------------------------------------------------------------------------------------------------------------
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

	set transaction isolation level serializable

	begin tran;

	SELECT @idPost = USERID, @idUser = POSTID,@deviceId = DEVICEID ,@deviceIp = DEVICEIP, @dateTime = COMMENTDATETIME, @content = COMMENTCONTENT
	FROM inserted

	select @idFriend = USERID
	from POST
	where POSTID = @idPost

	select @qty = COUNT(1) 
	from FRIENDSHIP
	where (USERID = @idUser and FRIENDID = @idFriend) or (USERID = @idFriend and FRIENDID = @idUser)


	if (@qty = 1)
	begin
		if((select COUNT(1) from "COMMENT" where POSTID = @idPost and ACTIVESTATUS = 1) >= 3)
		begin 
			insert into COMMENT values (@idUser,@idPost,@deviceId,@deviceIp,@dateTime,@content,0)
			commit;
		end
		else 
		begin 
			insert into COMMENT values (@idUser,@idPost,@deviceId,@deviceIp,@dateTime,@content,1)
			commit;
		end
	end 
	else
	begin
		 
		 print 'They are not friends'
		 commit;
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


-------------------------------------------------------------------------------------------------------------------------------------------------------
create or alter procedure summary_upPost
@pYear int
as
begin
	declare @count int
	set @count = 1;
	declare @qty int

	drop table if exists SUMMARYPOST;

	create table SUMMARYPOST(Months varchar(20), Quantity int)

	if(@pYear is not null)
	begin
		if(LEN(@pYear) = 4)
		begin
			while(@count <= 12)
			begin 

				select P.POSTID
				into temp123
				from POST P
				inner join COMMENT C on P.POSTID = C.POSTID
				where (MONTH(COMMENTDATETIME) = @count and YEAR(COMMENTDATETIME) =  @pYear )and ACTIVESTATUS = 1
				group by P.POSTID
				having COUNT(COMMENTID) = 3

				select @qty = COUNT(1) from temp123

				insert into SUMMARYPOST values(DATENAME(month, DATEADD(month, @count-1, CAST('2008-01-01' AS datetime))), @qty)

				set @count = @count + 1 

				drop table if exists temp123

			end 
		 select * from SUMMARYPOST
		end
		else
		begin
			print 'Wrong date format'
		end
	end
	else 
	begin
		set @pYear = YEAR(GETDATE())
		while(@count <= 12)
			begin 

				select P.POSTID
				into temp123
				from POST P
				inner join COMMENT C on P.POSTID = C.POSTID
				where (MONTH(COMMENTDATETIME) = @count and YEAR(COMMENTDATETIME) =  @pYear )and ACTIVESTATUS = 1
				group by P.POSTID
				having COUNT(COMMENTID) = 3

				select @qty = COUNT(1) from temp123

				insert into SUMMARYPOST values(DATENAME(month, DATEADD(month, @count-1, CAST('2008-01-01' AS datetime))), @qty)

				set @count = @count + 1 

				drop table if exists temp123


			end 
		 select * from SUMMARYPOST
	end 
end 
----------------
select COUNT(1)
from POST  P
inner join COMMENT C on P.POSTID = C.POSTID
where MONTH(POSTDATETIME) = 1 and MONTH(COMMENTDATETIME) <= 1

select P.POSTID,COUNT(distinct C.COMMENTID)
from POST  P
inner join COMMENT C on P.POSTID = C.POSTID
where  MONTH(C.COMMENTDATETIME) <= 10 and C.ACTIVESTATUS = 1 
group by P.POSTID
having (COUNT(distinct C.COMMENTID)) = 3

insert into COMMENT values (1,1,1,'asdf', GETDATE(), 'asdf',1)
insert into COMMENT values (2,1,1,'asdf', GETDATE(), 'asdf',1)
insert into COMMENT values (3,1,1,'asdf', GETDATE(), 'asdf',1)

insert into COMMENT values (4,2,1,'asdf', GETDATE(), 'asdf',1)
insert into COMMENT values (5,2,1,'asdf', GETDATE(), 'asdf',1)

insert into COMMENT values (6,58,1,'asdf', GETDATE(), 'asdf',1)
insert into COMMENT values (7,58,1,'asdf', GETDATE(), 'asdf',1)
insert into COMMENT values (8,58,1,'asdf', GETDATE(), 'asdf',1)

delete from COMMENT where COMMENTID = 2

 select * from COMMENT where POSTID = 58

select POSTID
from COMMENT
WHERE (MONTH(COMMENTDATETIME) <= 10 and YEAR(COMMENTDATETIME) = 2020 )and ACTIVESTATUS = 1
group by POSTID
having COUNT(COMMENTID) = 3

select COUNT(POSTID)
from COMMENT
WHERE (MONTH(COMMENTDATETIME) <= 10 and YEAR(COMMENTDATETIME) = 2020 )and ACTIVESTATUS = 1
group by POSTID
having COUNT(COMMENTID) = 3


select P.POSTID
--into temp123
from POST P
inner join COMMENT C on P.POSTID = C.POSTID
where (MONTH(COMMENTDATETIME) <= 10 and YEAR(COMMENTDATETIME) = 2020 )and ACTIVESTATUS = 1
group by P.POSTID
having COUNT(COMMENTID) = 3


 exec summary_upPost 15425


 select * from SUMMARYPOST

 select * from COMMENT where MONTH(COMMENTDATETIME) = 10

  select * from COMMENT where POSTID = 58
  --------------------------------------------------------------------------------------------------------------------------------------------------------
