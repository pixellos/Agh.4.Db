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
	DECLARE @conference_price INT = (SELECT TOP(1)
		[Price]
	FROM ConferencePrices
	WHERE ConferenceId = @ConferenceId AND DATEADD(DD,TillConferenceStart,@PaymentDate) < (SELECT dbo.GetConferenceStart(@ConferenceId))
	ORDER BY TillConferenceStart DESC);

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