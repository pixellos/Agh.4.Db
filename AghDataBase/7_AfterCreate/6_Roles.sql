USE [AghDataBase]
GO

/****** Object:  ApplicationRole [customerservice]    Script Date: 5/16/2019 2:45:25 AM ******/
/* To avoid disclosure of passwords, the password is generated in script. */
declare @idx as int
declare @randomPwd as nvarchar(64)
declare @rnd as float
select @idx = 0
select @randomPwd = N''
select @rnd = rand((@@CPU_BUSY % 100) + ((@@IDLE % 100) * 100) + 
       (DATEPART(ss, GETDATE()) * 10000) + ((cast(DATEPART(ms, GETDATE()) as int) % 100) * 1000000))
while @idx < 64
begin
   select @randomPwd = @randomPwd + char((cast((@rnd * 83) as int) + 43))
   select @idx = @idx + 1
select @rnd = rand()
end
declare @statement nvarchar(4000)
select @statement = N'CREATE APPLICATION ROLE [customerservice] WITH DEFAULT_SCHEMA = [dbo], ' + N'PASSWORD = N' + QUOTENAME(@randomPwd,'''')
EXEC dbo.sp_executesql @statement
GRANT CONTROL ON GetAttendantsAtConferenceDay TO customerserviceGRANT SELECT ON GetAttendantsAtConferenceDay TO customerserviceGRANT CONTROL ON GetAttendantsAtWorkshopsOnConferenceDay TO customerserviceGRANT SELECT ON GetAttendantsAtWorkshopsOnConferenceDay TO customerserviceGRANT EXECUTE ON AddAddress TO customerserviceGRANT EXECUTE ON AddClient TO customerserviceGRANT EXECUTE ON AddCorporateClient TO customerserviceGRANT EXECUTE ON AddStudent TO customerserviceGRANT EXECUTE ON AssignEmployerToEmployee TO customerserviceGRANT EXECUTE ON MakeReservation TO customerserviceGRANT EXECUTE ON MakeReservationCorporation TO customerserviceGRANT EXECUTE ON PayForReservationWithADate TO customerserviceGRANT EXECUTE ON DeleteUnpaidReservations TO customerservice
GO


