
/*
    Przypisuje pracownika do firmy o <see @tax_number> numerze  podatkowym </see> 
	Jeżeli nie ma pracownika w naszej bazie, tworzymy go.
	Jeżeli pracownik już był wcześniej zarejestrowany 
	Jeżeli nie ma firmy, trzeba ją najpierw stworzyć.
*/
CREATE   PROCEDURE AssignEmployerToEmployee 
		@tax_number nvarchar(50),
		@EmployeeTitle nvarchar(50),
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
	DECLARE @employee_employer  int;

	BEGIN TRANSACTION
		DECLARE @employee_id int;
		EXEC @employee_id = AddClient @FirstName, @LastName, @PersonalNumber, @Telephone, @Street, @ApartmentNumber, @BuildingNumber, @ZipCode, @City, @Country;
	
		SET @employee_employer = (SELECT Min(Id) FROM [dbo].CorporateClientEmployes WHERE Id = @employee_id);
		IF @employee_employer is NULL 
		BEGIN
			DECLARE @employer_id int;
			SET @employer_id = (SELECT Min(Id) FROM [dbo].CorporateClients WHERE TaxNumber = @tax_number);
			INSERT INTO [dbo].CorporateClientEmployes(Id, Title, CorporateClientId) VALUES (@employee_id, @EmployeeTitle, @employer_id);
			SET @employee_employer = @employee_id;
		END;
	COMMIT;
	RETURN @employee_employer;
