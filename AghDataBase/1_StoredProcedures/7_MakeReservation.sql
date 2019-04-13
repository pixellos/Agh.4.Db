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


CREATE PROCEDURE PayForReservationWithADate
	@PersonalNumber varchar(50),
	@ConferenceId int,
	@Ammount decimal
AS



RETURN 0;
GO
