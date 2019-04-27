/*
   Tworzymy rezerwację dla osoby o numerze PESEL @PersonalNumber
   Gdy rezerwacja jest stworzona zwracamy już istniejącą
   Ta procedura jest przeznaczona dla studentów i klientów indywidualnych, dla korporacji 
*/
CREATE OR ALTER PROCEDURE MakeReservation
	@PersonalNumber varchar(50),
	@ConferenceDayId int
AS

DECLARE @client_id INT;
SELECT @client_id =  Min(Id)
FROM IndividualClients
WHERE PersonalNumber = @PersonalNumber;

DECLARE @reservation_id int;
SELECT @reservation_id = Min(Id)
FROM Reservations
WHERE ClientId = @client_id and ConferenceDayId = @ConferenceDayId;

IF @reservation_id IS NULL 
	BEGIN
	INSERT INTO Reservations
		(ClientId, ConferenceDayId, ReservationDate)
	VALUES
		(@client_id, @ConferenceDayId, GETDATE() );
	SET @reservation_id = @@IDENTITY;
END

RETURN @reservation_id;
GO

/*
   Tworzymy rezerwację dla firmy o @TaxNumber
   Gdy rezerwacja jest stworzona tworzymy kolejne
*/
CREATE OR ALTER PROCEDURE MakeReservationCorporation
	@TaxNumber varchar(50),
	@ConferenceDayId int,
	@Ammount int
AS
BEGIN
DECLARE @client_id INT;
SELECT @client_id =  Min(Id)
FROM CorporateClients
WHERE TaxNumber = @TaxNumber;

BEGIN TRANSACTION

DECLARE @i int = 0
WHILE @i < @Ammount
BEGIN
    SET @i = @i + 1

	INSERT INTO Reservations (ClientId, ConferenceDayId) VALUES (@client_id, @ConferenceDayId)
    /* your code*/
END

COMMIT;
END

GO

/*
	Rejestrujemy dzień konferencji do konferencji
*/
CREATE OR ALTER PROCEDURE AddConferenceDay
@ConferenceId int, 
@Date datetime,
@Capacity int
AS
DECLARE @id int;

select TOP(1) @id = id from ConferenceDays where CONVERT(datE, Date) = CONVERT(DATE, @Date); 

IF @id IS NULL
BEGIN
	INSERT INTO ConferenceDays(Capacity, ConferenceId, Date) VALUES (@Capacity, @ConferenceId, CONVERT(DATE, @Date));
	SET @id = @@IDENTITY;
END

return @id;
GO