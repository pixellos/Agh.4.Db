/*
    Add a client that is a company
*/
CREATE OR ALTER PROCEDURE AddClient 
	@FirstName nvarchar(50),
	@LastName nvarchar(50),
	@PersonalNumber nvarchar(50),
	@Telephone nvarchar(50),
	@Street nvarchar(50),
	@ApartmentNumber int,
	@BuildingNumber int,
	@ZipCode nvarchar(6),
	@City nvarchar(50),
	@Province nvarchar(50),
	@Country nvarchar(50)
	AS

	DECLARE @individual_client_id int;
	
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
	SET @individual_client_id = (SELECT Min(Id) FROM [dbo].IndividualClients WHERE FirstName = @FirstName and LastName = @LastName and PersonalNumber = @PersonalNumber);
	   IF @individual_client_id IS NULL
	   BEGIN
			INSERT INTO [dbo].Clients(Telephone, BuildingId) VALUES (@Telephone, @building_id);
			INSERT INTO [dbo].IndividualClients(Id, FirstName, LastName, PersonalNumber) VALUES (@@IDENTITY, @FirstName, @LastName, @PersonalNumber)  
			SET @individual_client_id = @@IDENTITY;
	   END
	END

	COMMIT;
	RETURN @individual_client_id;
	GO