/*
	Założenie: Klient w treści przelewu wpisuje numer konferencji, gdy przelew był zły dzwonimy do klienta i 
	Założenie: Gdy rezerwacja nie istnieje rzucamy wyjątek 'RESERVATION DOES NOT EXISTS' o kluczu 1- oznacza, że płatność ma zostać zwrócona klientowi
	Założenie: Płacimy zawsze za całość konferencji 
	Założenie: Gdy płatność już istnieje rzucamy wyjątek 'RESERVATION HAS BEEN ALREADY PAID FOR' o kluczu 2
	Założenie:Gdy klient zapłaci za dużo/za mało 'RESERVATION HAS BEEN ALREADY PAID FOR' o kluczu 2

	Klient wpłacił płatność w dniu podanym
	W przypadku odrzucenia rzucany jest wyjątek

	ZAŁOŻENIE - 
*/
CREATE OR ALTER PROCEDURE PayForReservationWithADate
	@PersonalNumber varchar(50),
	@ConferenceId int,
	@PaymentDate datetime,
	@Ammount decimal
AS

DECLARE @clientId INT;
SELECT @clientId = dbo.GetIndividualClientOrThrow(@PersonalNumber);

DECLARE @price decimal;
select @price = dbo.GetConferencePrice(@ConferenceId, @PersonalNumber, @PaymentDate);


DECLARE @priceId int;
select @priceId = dbo.GetConferencePriceId(@ConferenceId, @PersonalNumber, @PaymentDate);

DECLARE @reservationId int;
SELECT @reservationId = Id FROM Reservations WHERE ConferenceId = @ConferenceId and ClientId = @clientId;

if @reservationId = null 
BEGIN
	;THROW 51001, 'RESERVATION DOES NOT EXISTS', 1;
END

DECLARE @reservationPaymentId int;
SELECT @reservationPaymentId = Id FROM ReservationPayments 
WHERE Id = @reservationId;

IF @reservationPaymentId != null
BEGIN
	;THROW 51002, 'RESERVATION HAS BEEN ALREADY PAID FOR', 2;
END

IF @price != @Ammount
BEGIN
	DECLARE @msg NVARCHAR(2048) = 'RESERVATION CANNOT BE PLACED - AMMOUNT DIFFERS WITH PRICE: ' + @price;   
	THROW 51003, @msg, 3;
END	

INSERT INTO ReservationPayments(Id, ClientId, Ammount, ConferencePricesId) VALUES(@reservationId ,@clientId, @price, @priceId)
RETURN @reservationId;

GO