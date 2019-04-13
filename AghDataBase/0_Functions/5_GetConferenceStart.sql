/*
    Zwraca Datę początku konferencji (Za początek konferencji przyjmujemy pierwszy dzień konferencji przypisany doń)
*/
CREATE OR ALTER FUNCTION GetConferenceStart(@ConferenceIds int)
RETURNS DATETIME
AS
BEGIN
	DECLARE @date datetime;
	SELECT @date = [Date]
	FROM ConferenceDays
	WHERE ConferenceId = @ConferenceIds
	ORDER BY [Date];
	RETURN @date;
END
GO

/*
    Zwraca cenę konferencji biorąc pod uwagę datę zaksięgowania przelewu
*/
CREATE OR ALTER FUNCTION GetConferenceWithPriceAccordingToDate(@ConferenceId int, @PaymentDate datetime)
RETURNS decimal
AS
BEGIN
	DECLARE @result decimal;

	SELECT TOP(1) @result = Price 
	FROM ConferencePrices
	WHERE @ConferenceId = ConferenceId AND DATEADD(DD, -TillConferenceStart, dbo.GetConferenceStart(ConferenceId)) <= DATEADD(DD, 0, @PaymentDate)
	ORDER BY DATEADD(DD, -TillConferenceStart, dbo.GetConferenceStart(ConferenceId))
	
	RETURN @result;
END
GO

/*
	Zwraca cenę konferencji i bierze pod uwagę, czy jest studentem.
*/
CREATE OR ALTER FUNCTION GetConferencePrice(
	@ConferenceId int, 
	@PersonalNumber nvarchar(50),
	@PaymentDate DateTime)
	RETURNS INT
	AS 
BEGIN
	DECLARE @conference_price decimal;
	SELECT @conference_price = dbo.GetConferenceWithPriceAccordingToDate(@ConferenceId, @PaymentDate)

	DECLARE @client_id int
	SELECT @client_id = dbo.GetIndividualClientOrThrow(@PersonalNumber);

	DECLARE @student_discount int
	SELECT TOP(1)
		@student_discount = [Id]
	FROM Students
	WHERE Id = @client_id;

	IF @student_discount is NULL OR @student_discount = 0
	BEGIN
		RETURN @conference_price;
	END

	IF @student_discount <= 100
	BEGIN
		RETURN @conference_price * @student_discount / 100;
	END

	RETURN Cast('Never should be there' as int)
END
GO