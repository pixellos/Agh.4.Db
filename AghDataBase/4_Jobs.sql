--Jobs not available on the server

--EXEC msdb.dbo.sp_delete_job  
--    @job_name = N'DeleteUnpaidReservations' ;  
--GO  

--EXEC msdb.dbo.sp_delete_jobstep
--    @step_name = N'DeleteUnpaidReservations' ;  
--GO  

--EXEC msdb.dbo.sp_delete_schedule  
--    @schedule_name = N'DailyJobs' ;  
--GO  



--EXEC msdb.dbo.sp_add_job  
--    @job_name = N'DeleteUnpaidReservations' ;  
--GO  

--EXEC msdb.dbo.sp_add_jobstep  
--    @job_name = N'DeleteUnpaidReservations',  
--    @step_name = N'DeleteUnpaidReservations',  
--    @subsystem = N'TSQL',
--    @command = N'EXEC DeleteUnpaidReservations',   \
--    @retry_attempts = 5,  
--    @retry_interval = 5 ;  
--GO  

---- creates a schedule named DailyJobs.   
---- Jobs that use this schedule execute every day when the time on the server is 01:00.   
--EXEC msdb.dbo.sp_add_schedule  
--    @schedule_name = N'DailyJobs' ,  
--    @freq_type = 4,  
--    @freq_interval = 1,  
--    @active_start_time = 010000 ;  
--GO  
---- attaches the schedule to the job BackupDatabase  
--EXEC msdb.dbo.sp_attach_schedule  
--   @job_name = N'DeleteUnpaidReservations',  
--   @schedule_name = N'DailyJobs';
--GO  