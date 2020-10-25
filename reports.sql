--Procedure to report daily users gain and increase percentage
create or alter procedure pu_daily_users_gain
as
declare @total_users int
declare @new_users int
declare @increase_pct float
begin
	select @total_users = COUNT(*) from "USER"
	select @new_users = COUNT(*) from "USER" where DAY(REGISTRATIONDATE) = DAY(GETDATE())	

	if (@total_users - @new_users) != 0
	begin
		print 'Se han registrado ' + CAST(@new_users as varchar) + ' nuevos en el día.'
		select @increase_pct = 100 * @new_users/(@total_users-@new_users)
		print 'El porcentaje de crecimiento en el día es de ' + CAST(@increase_pct as varchar) + '%'
	end
	else
	begin
		print 'No se han registrado nuevos usuarios en el día.'
	end	
end
----------------------------------------------------------------
--Reports likes between two dates, and if they are not specified
--the report is from current day
create or alter procedure plikes_history
@postID int,
@startDate date,
@endDate date
as
begin
    if (@startDate is null)
    begin
		select @startDate = GETDATE()
    end

    if (@endDate is null)
    begin
		select @endDate = GETDATE()
    end

    select INTERACTIONID, USERID, ISLIKE, INTERACTIONDATETIME
    from INTERACTION
    where (POSTID = @postID) and (INTERACTIONDATETIME between @startDate and @endDate)
end
--------------------------------------------------------------------------
--Reporte de la cantidad de post que llegaron a su cantidad maxima de comentarios en base a un año se desplica cantidad por cada mes del mismo 
--parametros: @pYear año en el que se desea saber los reportes del mes y si se envia nulo se toma el año en el que se encuentra
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
----------------------------------------------------------------------------------------