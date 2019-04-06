/*
Dodaje cenę do konferencji, która zaczyna się @DaysToConferenceStart od dni startu
*/
CREATE PROCEDURE AddPriceToConference
	@Price decimal,
	@DaysToConferenceStart int,
	@ConferenceId int
	AS
	
	DECLARE @price_id int;
	SET @price_id = (SELECT Min(Id) FROM ConferencePrices WHERE Price = @Price and @DaysToConferenceStart = TillConferenceStart and ConferenceId = @ConferenceId)

	IF @price_id IS NULL
	BEGIN
		INSERT INTO ConferencePrices(Price, TillConferenceStart, ConferenceId) VALUES (@Price, @DaysToConferenceStart, @ConferenceId)
		SET @price_id = @@IDENTITY;
	END
	RETURN @price_id;
GO