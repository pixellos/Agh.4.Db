/*
   Tworzymy rezerwację dla osoby o numerze PESEL @PersonalNumber i firmy o numerze podatkowym @CompanyTax,
   Gdy rezerwacja jest stworzona zwracamy już istniejącą
*/
CREATE PROCEDURE MakeReservation
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
		(ClientId, ConferenceId)
	VALUES
		(@client_id, @ConferenceId);
	SET @reservation_id = @@IDENTITY;
END

RETURN @reservation_id;
GO


/*

*/
CREATE PROCEDURE AddConferenceDay
AS

return 0;
GO

/*
	Założenie: Klient w treści przelewu wpisuje numer konferencji, gdy przelew był zły dzwonimy do klienta i 

	Klient wpłacił płatność w dniu podanym
	W przypadku odrzucenia rzucany jest wyjątek
*/
CREATE PROCEDURE PayForReservationWithADate
	@PersonalNumber varchar(50),
	@ConferenceId int,
	@PaymentDate datetime,
	@Ammount decimal
AS

DECLARE @clientId INT;
SELECT @clientId = dbo.GetIndividualClientOrThrow(@PersonalNumber);
	

RETURN 0;
GO
