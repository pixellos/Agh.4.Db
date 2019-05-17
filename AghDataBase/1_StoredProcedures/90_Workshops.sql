  /*
   Tworzymy warsztat
*/
CREATE PROCEDURE AddWorkshop 
	@ConferenceDayId int,
	@StartDate datetime,
	@EndDate datetime,
	@Name nvarchar(50)
	AS
	DECLARE @workshop_id int;

	BEGIN TRANSACTION
		INSERT INTO Workshops(StartTime, EndTime, ConferenceDayId, Name) VALUES 
		(@StartDate, @EndDate, @ConferenceDayId, @Name);
			
		SET @workshop_id = @@IDENTITY;
	COMMIT;
	
	RETURN @workshop_id;
GO

CREATE PROCEDURE AddPriceToWorkshop
	@Price decimal,
	@WorkshopId int
	as 

	IF @Price < 0
	BEGIN
		RETURN -1;
	END

	INSERT INTO WorkshopPrices(Id, Price) VALUES (@WorkshopId, @Price);

	RETURN @@IDENTITY;
GO

CREATE PROCEDURE ReserveAPlaceForAWorkshop
	@WorkshopId int,
	@ClientId int
	as 

    INSERT INTO WorkshopReservations(ClientId, WorkshopId) VALUES (@ClientId, @WorkshopId)

	RETURN @@IDENTITY;
GO