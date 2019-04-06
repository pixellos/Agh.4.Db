/*
   Tworzymy konferencje dla danego pracodawcy 
   ze znaną zniżką studencką, 
   z domyślną ceną za konferencję 
*/
CREATE PROCEDURE AddConference 
		@IssuerCompanyTaxNumber nvarchar(50),
		@ConferenceName nvarchar(50),
		@StudentDiscount decimal,
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

		DECLARE @company_id int = (SELECT Min(Id) FROM CorporateClients WHERE TaxNumber = @IssuerCompanyTaxNumber);

		INSERT INTO Conferences(BuildingId, Name, StudentDiscount, Issuer) values (@address, @ConferenceName, @StudentDiscount, @company_id);
		SET @conference_id = @@IDENTITY;

		DECLARE @int16 INT;
		SELECT @int16 = dbo.ConstantInt16();

		EXEC AddPriceToConference @Price, @int16, @conference_id;
	COMMIT;
	
	RETURN @conference_id;
GO