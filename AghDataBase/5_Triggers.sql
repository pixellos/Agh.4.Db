CREATE TRIGGER DISALLOW_WORKSHOP_RESERVATION_FOR_SAME_CLIENT
ON [WorkshopReservations]
AFTER INSERT
AS

IF EXISTS (
SELECT * FROM inserted i INNER JOIN Workshops WI ON i.Id = WI.Id where 
	(SELECT COUNT(*) FROM WorkshopReservations INNER JOIN Workshops WRW ON WorkshopReservations.Id = WRW.Id 
		WHERE  WI.StartTime <= WRW.StartTime AND WI.EndTime <= WRW.EndTime AND WI.EndTime >= WRW.StartTime
	)
	> 0
)
BEGIN
RAISERROR ('Same client can not have overlapping time.', 16, 1);
ROLLBACK TRANSACTION;
RETURN 
END;

GO