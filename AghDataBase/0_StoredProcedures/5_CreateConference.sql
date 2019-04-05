
/*
   Tworzymy konferencje dla danego pracodawcy 
   ze znaną zniżką studencką, 
   z domyślną ceną za konferencję 
*/
CREATE   PROCEDURE AssignEmployerToEmployee 
		@IssuerCompanyTaxNumber nvarchar(50),
		@ConferenceName nvarchar(50),
		@Street nvarchar(50),
		@ApartmentNumber int NULL,
		@BuildingNumber int,
		@ZipCode nvarchar(6),
		@City nvarchar(50),
		@Province nvarchar(50),
		@Country nvarchar(50)
	AS
	DECLARE @employee_employer  int;

	BEGIN TRANSACTION
		DECLARE @employee_id int;
		EXEC @employee_id = AddClient @FirstName, @LastName, @PersonalNumber, @Telephone, @Street, @ApartmentNumber, @BuildingNumber, @ZipCode, @City, @Province, @Country;
	
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
