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

/*
   Tworzymy konferencje dla danego pracodawcy 
   ze znaną zniżką studencką, 
   z domyślną ceną za konferencję 
*/
CREATE OR ALTER  PROCEDURE CreateConference 
		@IssuerCompanyTaxNumber nvarchar(50),
		@ConferenceName nvarchar(50),
		@StudentDiscount decimal,
		@Name nvarchar(50),
		@Price int,
		@Street nvarchar(50),
		@ApartmentNumber int NULL,
		@BuildingNumber int,
		@ZipCode nvarchar(6),
		@City nvarchar(50),
		@Province nvarchar(50),
		@Country nvarchar(50)
	AS
	DECLARE @conference_id int;

	BEGIN TRANSACTION
		DECLARE @address int;
		EXEC @address = AddAddress @Street, @ApartmentNumber, @BuildingNumber, @ZipCode, @City, @Province, @Country;

		INSERT INTO Conferences(BuildingId, Name, StudentDiscount) values (@address, @Name, @StudentDiscount);
		SET @conference_id = @@IDENTITY;

		DECLARE @int16 INT;
		SELECT @int16 = dbo.ConstantInt16();

		EXEC AddPriceToConference @Price, @int16, @conference_id;
	COMMIT;
	
	RETURN @conference_id;
GO