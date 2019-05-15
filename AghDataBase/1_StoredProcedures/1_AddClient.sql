/*
    Add a client that is a individual client
	Założenia:
	Numer telefonu jest unikatowy dla każdego użytkownika, nie może być pusty (musimy się jakoś kontaktować z uczestnikami)	
*/
CREATE PROCEDURE AddClient 
	@FirstName nvarchar(50),
	@LastName nvarchar(50),
	@PersonalNumber nvarchar(50),
	@Telephone nvarchar(50),
	@Street nvarchar(50),
	@ApartmentNumber int,
	@BuildingNumber int,
	@ZipCode nvarchar(6),
	@City nvarchar(50),
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
	@Country
	
	BEGIN
	SET @individual_client_id = (SELECT Min(Id) FROM [dbo].IndividualClients WHERE FirstName = @FirstName and LastName = @LastName and PersonalNumber = @PersonalNumber);
	   IF @individual_client_id IS NULL
	   BEGIN
			INSERT INTO [dbo].Clients(Telephone, BuildingId) VALUES (@Telephone, @building_id);
			SET @individual_client_id = SCOPE_IDENTITY()
			INSERT INTO [dbo].IndividualClients(Id, FirstName, LastName, PersonalNumber) VALUES (@individual_client_id, @FirstName, @LastName, @PersonalNumber)  
	   END
	END

	COMMIT;
	RETURN @individual_client_id;
	GO