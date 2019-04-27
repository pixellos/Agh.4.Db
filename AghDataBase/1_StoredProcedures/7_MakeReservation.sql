/*
   Tworzymy rezerwację dla osoby o numerze PESEL @PersonalNumber i firmy o numerze podatkowym @CompanyTax,
   Gdy rezerwacja jest stworzona zwracamy już istniejącą
*/
CREATE OR ALTER PROCEDURE MakeReservation
	@PersonalNumber varchar(50),
	@ConferenceId int
AS

DECLARE @client_id INT;
SELECT @client_id =  Min(Id)
FROM IndividualClients
WHERE PersonalNumber = @PersonalNumber;

DECLARE @reservation_id int;
SELECT @reservation_id = Min(Id)
FROM Reservations
WHERE ClientId = @client_id and ConferenceId = @ConferenceId;

IF @reservation_id IS NULL 
	BEGIN
	INSERT INTO Reservations
		(ClientId, ConferenceId, ReservationDate)
	VALUES
		(@client_id, @ConferenceId, GETDATE() );
	SET @reservation_id = @@IDENTITY;
END

RETURN @reservation_id;
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