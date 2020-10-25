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
