-- creates a schedule named DailyJobs.   
-- Jobs that use this schedule execute every day when the time on the server is 01:00.   
EXEC sp_add_schedule  
    @schedule_name = N'DailyJobs' ,  
    @freq_type = 4,  
    @freq_interval = 1,  
    @active_start_time = 010000 ;  
GO  
-- attaches the schedule to the job BackupDatabase  
EXEC sp_attach_schedule  
   @job_name = N'BackupDatabase',  
   @schedule_name = N'NightlyJobs',
   @command = N'EXEC 9_DeleteUnpaidReservations()';
GO  