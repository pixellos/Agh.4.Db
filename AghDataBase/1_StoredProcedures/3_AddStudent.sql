
/*
    Dodaj studenta
*/
CREATE PROCEDURE AddStudent 
	@FirstName nvarchar(50),
	@LastName nvarchar(50),
	@PersonalNumber nvarchar(50),
	@StudentId nvarchar(50),
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
		
	DECLARE @student_id int;

	BEGIN
	SET @student_id = (SELECT Min(Id) FROM [dbo].Students WHERE StudentId = @StudentId);
	   IF @student_id IS NULL
	   BEGIN
		EXEC @student_id = AddClient @FirstName, @LastName, @PersonalNumber, @Telephone, @Street, @ApartmentNumber, @BuildingNumber, @ZipCode, @City, @Province, @Country
		INSERT INTO [dbo].Students(Id, StudentId) VALUES (@student_id, @StudentId);
	   END
	END

	COMMIT;
	RETURN @student_id;
