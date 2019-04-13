/*
	Założenie: Klient w treści przelewu wpisuje numer konferencji, gdy przelew był zły dzwonimy do klienta i 

	Klient wpłacił płatność w dniu podanym
	W przypadku odrzucenia rzucany jest wyjątek

*/
CREATE OR ALTER PROCEDURE PayForReservationWithADate
	@PersonalNumber varchar(50),
	@ConferenceId int,
	@PaymentDate datetime,
	@Ammount decimal
AS

DECLARE @clientId INT;
SELECT @clientId = dbo.GetIndividualClientOrThrow(@PersonalNumber);
	
	DECLARE @conferenceDate DATETIME;

	SELECT @conferenceDate = Date FROM dbo.ConferenceDays WHERE ConferenceId = @ConferenceId ORDER BY Date;

	SELECT * FROM dbo.ConferencePrices WHERE @ConferenceId = ConferenceId AND  DATEADD(day, TillConferenceStart, @conferenceDate) > @PaymentDate;

	RETURN 0
GO