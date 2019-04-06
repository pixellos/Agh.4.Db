/*
    Add a client that is a company
*/
CREATE PROCEDURE AddCorporateClient 
	@CompanyName nvarchar(50),
	@TaxNumber nvarchar(50),
	@Telephone nvarchar(50),
	@Street nvarchar(50),
	@ApartmentNumber int,
	@BuildingNumber int,
	@ZipCode nvarchar(6),
	@City nvarchar(50),
	@Province nvarchar(50),
	@Country nvarchar(50)
	AS
	
	BEGIN TRANSACTION
	DECLARE @building_id int;
	EXEC @building_id = AddAddress
	@Street,
	@ApartmentNumber,
	@BuildingNumber,
	@ZipCode,
	@City,
	@Province,
	@Country
	
	BEGIN
	   IF NOT EXISTS (SELECT * FROM [dbo].CorporateClients WHERE TaxNumber = @TaxNumber)
	   BEGIN
			INSERT INTO [dbo].Clients(Telephone, BuildingId) VALUES (@Telephone, @building_id);
			INSERT INTO [dbo].CorporateClients(Id, CompanyName, TaxNumber) VALUES (@@IDENTITY, @CompanyName, @TaxNumber)  
	   END
	END

	COMMIT;
	RETURN 0;
	GO