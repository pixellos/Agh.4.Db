
/*
   Tworzymy konferencje dla danego pracodawcy 
   ze znaną zniżką studencką, 
   z domyślną ceną za konferencję 
*/
CREATE   PROCEDURE CreateConference 
		@IssuerCompanyTaxNumber nvarchar(50),
		@ConferenceName nvarchar(50),
		@Price decimal,
		@Street nvarchar(50),
		@ApartmentNumber int NULL,
		@BuildingNumber int,
		@ZipCode nvarchar(6),
		@City nvarchar(50),
		@Province nvarchar(50),
		@Country nvarchar(50)
	AS

	BEGIN TRANSACTION
	DECLARE @address int;
	EXEC @address = AddAddress @Street, @ApartmentNumber, @BuildingNumber, @ZipCode, @City, @Province, @Country;
	DECLARE @result int;
	
	EXEC 


	COMMIT;
	RETURN @result;