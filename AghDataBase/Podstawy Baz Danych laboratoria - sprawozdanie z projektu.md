# Podstawy Baz Danych laboratoria - sprawozdanie z projektu

------

##### AGH IET 2019 - Mateusz Popielarz, Michał Flak



## Opis funkcjonalności bazy

lorem ipsum

## Użytkownicy i role

lorem ipsum

## Schemat bazy danych

tutaj bobrazek

## Widoki

- ### LoyalClientsView

  Wyświetla listę 1000 najlepszych klientów uszeregowanych malejąco pod względem sumy opłat za udział w konferencjach.

  ```mssql
  CREATE OR ALTER VIEW LoyalClientsView
    AS
  	SELECT TOP 1000 IC.FirstName, IC.LastName, CC.CompanyName, sum(RP.Amount) as TotalPaid
  		FROM IndividualClients IC
  	RIGHT JOIN Clients C
  		ON IC.Id = C.Id
  	LEFT JOIN CorporateClients CC
  		ON CC.Id = C.Id
  	INNER JOIN Reservations R
  		ON C.Id = R.ClientId
  	INNER JOIN ReservationPayments RP
  		ON R.Id = RP.Id
  	GROUP BY IC.FirstName, IC.LastName, CC.CompanyName
  	ORDER BY TotalPaid DESC;
  ```

  

## Funkcje

lorem ipsum

## Procedury

- ### AddAddress

  Zapisuje adres klienta rejestrującego się na konferencję. Rozbija go na tabele: Country, City, Street, Building. Zwraca ID Building.

  ```mssql
  /*
      Założenia
  	Ta procedura będzie używana przez naszego pracownika, ufamy danym, które wprowadzi, będą one zawsze poprawne.
  	Przyjmuje krotkę z danymi adresowymi
  */
  CREATE PROCEDURE AddAddress
  	@Street nvarchar(50),
  	@ApartmentNumber int NULL,
  	@BuildingNumber int,
  	@ZipCode nvarchar(6),
  	@City nvarchar(50),
  	@Country nvarchar(50)
  AS
  
  BEGIN TRANSACTION
  
  BEGIN
     IF NOT EXISTS (SELECT * FROM [dbo].[Countries] WHERE Name = @Country)
     BEGIN
         INSERT INTO [dbo].[Countries](Name)
         VALUES (@Country)
     END
  END
  
  DECLARE @country_id int;
  SET @country_id = (SELECT MIN(Id) FROM [dbo].[Countries] WHERE Name = @Country);
  
  BEGIN
     IF NOT EXISTS (SELECT * FROM [dbo].Cities WHERE Name = @City and @country_id = CountryId)
     BEGIN
         INSERT INTO [dbo].Cities(Name, CountryId)
         VALUES (@City, @country_id)
     END
  END
  
  DECLARE @city_id int;
  SET @city_id = (SELECT MIN(Id) FROM [dbo].[Cities] WHERE Name = @City and CountryId = @country_id);
  
  BEGIN
     IF NOT EXISTS (SELECT * FROM [dbo].Streets WHERE Name = @Street and ZipCode = @ZipCode and CityId = @city_id)
     BEGIN
         INSERT INTO [dbo].Streets(Name, ZipCode, CityId)
         VALUES (@Street, @ZipCode, @city_id)
     END
  END
  
  DECLARE @street_id int;
  SET @street_id =  (SELECT MIN(Id) FROM [dbo].[Streets] WHERE Name = @Street and ZipCode = @ZipCode and CityId = @city_id);
  
  BEGIN
     IF NOT EXISTS (SELECT * FROM [dbo].Buildings WHERE Number = @BuildingNumber and (ApartmentNumber = @ApartmentNumber or (ApartmentNumber is NULL and @ApartmentNumber is NULL)) and StreetId = @street_id)
     BEGIN
         INSERT INTO [dbo].Buildings(Number, ApartmentNumber, StreetId)
         VALUES (@BuildingNumber, @ApartmentNumber, @street_id)
     END
  END
  
  COMMIT;
  
  RETURN (SELECT MIN(Id) FROM [dbo].Buildings WHERE Number = @BuildingNumber and (ApartmentNumber = @ApartmentNumber or (ApartmentNumber is NULL and @ApartmentNumber is NULL)) and StreetId = @street_id)
  
  ```

  

- ### AddClient

  Dodaje indywidualnego klienta przy rezerwacji na konferencję. Zwraca jego ID.

  ```mssql
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
  ```
  
- ### AddCorporateClient

  Dodaje klienta korporacyjnego przy rezerwacji na konferencję.

  ```mssql
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
  ```

  

- ### AddStudent

  Dodaje studenta, umożliwiając skorzystanie ze zniżki studenckiej. Zwraca jego ID w tabeli Students.

  ```mssql
  
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
  	@Country nvarchar(50)
  	AS
  
  	DECLARE @individual_client_id int;
  	
  	BEGIN TRANSACTION
  		
  	DECLARE @student_id int;
  
  	BEGIN
  	SET @student_id = (SELECT Min(Id) FROM [dbo].Students WHERE StudentId = @StudentId);
  	   IF @student_id IS NULL
  	   BEGIN
  		EXEC @student_id = AddClient @FirstName, @LastName, @PersonalNumber, @Telephone, @Street, @ApartmentNumber, @BuildingNumber, @ZipCode, @City, @Country
  		INSERT INTO [dbo].Students(Id, StudentId) VALUES (@student_id, @StudentId);
  	   END
  	END
  
  	COMMIT;
  	RETURN @student_id;
  
  ```

  

- ### AssignEmployerToEmployee

  ```mssql
  
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
  
  ```

  

- ### AddPriceToConference

  Dodaje cenę do konferencji, która zaczyna się @DaysToConferenceStart od dni startu. Pozwala to na ustalanie niższych cen dla kupujących z wyprzedzeniem.

  ```mssql
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
  ```

  

- ### AddConference

  Tworzymy konferencje dla danego pracodawcy  ze znaną zniżką studencką,  z domyślną ceną za konferencję .

  ```mssql
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
  		@Country nvarchar(50)
  	AS
  	DECLARE @conference_id int;
  
  	BEGIN TRANSACTION
  		DECLARE @address int;
  		EXEC @address = AddAddress @Street, @ApartmentNumber, @BuildingNumber, @ZipCode, @City, @Country;
  
  		DECLARE @company_id int = (SELECT Min(Id) FROM CorporateClients WHERE TaxNumber = @IssuerCompanyTaxNumber);
  
  		INSERT INTO Conferences(BuildingId, Name, StudentDiscount, Issuer) values (@address, @ConferenceName, @StudentDiscount, @company_id);
  		SET @conference_id = @@IDENTITY;
  
  		DECLARE @int16 INT;
  		SELECT @int16 = dbo.ConstantInt16();
  
  		EXEC AddPriceToConference @Price, @int16, @conference_id;
  	COMMIT;
  	
  	RETURN @conference_id;
  GO
  ```

  

- ### MakeReservation

  Tworzymy rezerwację dla osoby o numerze PESEL @PersonalNumber. Gdy rezerwacja jest stworzona zwracamy już istniejącą. Ta procedura jest przeznaczona dla studentów i klientów indywidualnych.

  ```mssql
  CREATE OR ALTER PROCEDURE MakeReservation
  	@PersonalNumber varchar(50),
  	@ConferenceDayId int
  AS
  
  DECLARE @client_id INT;
  SELECT @client_id =  Min(Id)
  FROM IndividualClients
  WHERE PersonalNumber = @PersonalNumber;
  
  DECLARE @reservation_id int;
  SELECT @reservation_id = Min(Id)
  FROM Reservations
  WHERE ClientId = @client_id and ConferenceDayId = @ConferenceDayId;
  
  IF @reservation_id IS NULL 
  	BEGIN
  	INSERT INTO Reservations
  		(ClientId, ConferenceDayId, ReservationDate)
  	VALUES
  		(@client_id, @ConferenceDayId, GETDATE() );
  	SET @reservation_id = @@IDENTITY;
  END
  
  RETURN @reservation_id;
  GO
  ```

  

- ### MakeReservationCorporation

  Powyższe, ale dla klienta korporacyjnego.

  ```mssql
  /*
     Tworzymy rezerwację dla firmy o @TaxNumber
     Gdy rezerwacja jest stworzona tworzymy kolejne
  */
  CREATE OR ALTER PROCEDURE MakeReservationCorporation
  	@TaxNumber varchar(50),
  	@ConferenceDayId int,
  	@Ammount int
  AS
  BEGIN
  DECLARE @client_id INT;
  SELECT @client_id =  Min(Id)
  FROM CorporateClients
  WHERE TaxNumber = @TaxNumber;
  
  BEGIN TRANSACTION
  
  DECLARE @i int = 0
  WHILE @i < @Ammount
  BEGIN
      SET @i = @i + 1
  
  	INSERT INTO Reservations (ClientId, ConferenceDayId) VALUES (@client_id, @ConferenceDayId)
      /* your code*/
  END
  
  COMMIT;
  END
  
  GO
  ```

  

- ### AddConferenceDay

  Dodaje dzień konferencji.

  ```mssql
  /*
  	Rejestrujemy dzień konferencji do konferencji
  */
  CREATE OR ALTER PROCEDURE AddConferenceDay
  @ConferenceId int, 
  @Date datetime,
  @Capacity int
  AS
  DECLARE @id int;
  
  select TOP(1) @id = id from ConferenceDays where CONVERT(datE, Date) = CONVERT(DATE, @Date); 
  
  IF @id IS NULL
  BEGIN
  	INSERT INTO ConferenceDays(Capacity, ConferenceId, Date) VALUES (@Capacity, @ConferenceId, CONVERT(DATE, @Date));
  	SET @id = @@IDENTITY;
  END
  
  return @id;
  GO
  ```

  

- ### PayForReservationWithADate

  Przyjmuje opłatę za udział w konferencji.

  ```mssql
  /*
  	Założenie: Klient w treści przelewu wpisuje numer konferencji, gdy przelew był zły dzwonimy do klienta i 
  	Założenie: Gdy rezerwacja nie istnieje rzucamy wyjątek 'RESERVATION DOES NOT EXISTS' o kluczu 1- oznacza, że płatność ma zostać zwrócona klientowi
  	Założenie: Płacimy zawsze za całość konferencji 
  	Założenie: Gdy płatność już istnieje rzucamy wyjątek 'RESERVATION HAS BEEN ALREADY PAID FOR' o kluczu 2
  	Założenie:Gdy klient zapłaci za dużo/za mało 'RESERVATION HAS BEEN ALREADY PAID FOR' o kluczu 2
  
  	Klient wpłacił płatność w dniu podanym
  	W przypadku odrzucenia rzucany jest wyjątek
  
  	ZAŁOŻENIE - 
  */
  CREATE OR ALTER PROCEDURE PayForReservationWithADate
  	@PersonalNumber varchar(50),
  	@ConferenceDayId int,
  	@PaymentDate datetime,
  	@Ammount decimal
  AS
  
  DECLARE @clientId INT;
  SELECT @clientId = dbo.GetIndividualClientOrThrow(@PersonalNumber);
  
  DECLARE @conferenceId int;
  SELECT @conferenceId = ConferenceId from ConferenceDays Where Id = @ConferenceDayId ;
  
  DECLARE @price decimal;
  select @price = dbo.GetConferencePrice(@ConferenceId, @PersonalNumber, @PaymentDate);
  
  DECLARE @priceId int;
  select @priceId = dbo.GetConferencePriceId(@ConferenceId, @PaymentDate);
  
  DECLARE @reservationId int;
  SELECT @reservationId = Id FROM Reservations WHERE ConferenceDayId = @ConferenceDayId and ClientId = @clientId;
  
  if @reservationId is null 
  BEGIN
  	;THROW 51001, 'RESERVATION DOES NOT EXISTS', 1;
  END
  
  DECLARE @reservationPaymentId int;
  SELECT @reservationPaymentId = Id FROM ReservationPayments 
  WHERE Id = @reservationId;
  
  IF @reservationPaymentId IS NOT null
  BEGIN
  	;THROW 51002, 'RESERVATION HAS BEEN ALREADY PAID FOR', 2;
  END
  
  IF @price != @Ammount
  BEGIN
  	DECLARE @msg NVARCHAR(2048) = ('RESERVATION CANNOT BE PLACED - AMMOUNT DIFFERS WITH PRICE: ' + @price);   
  	THROW 51003, @msg, 3;
  END	
  
  INSERT INTO ReservationPayments(Id, ClientId, Amount, ConferencePricesId) VALUES(@reservationId ,@clientId, @price, @priceId)
  RETURN @reservationId;
  
  GO	
  ```

  

- ### DeleteUnpaidReservations

  Procedura wykonywana codziennie. Na zapłatę klienci mają tydzień od rezerwacji na konferencję. Jeśli do tego czasu nie pojawi się opłata, rezerwacja jest anulowana.

  ```mssql
  /*
  	Procedura wykonywana codziennie. 
  	Na zapłatę klienci mają tydzień od rezerwacji na konferencję. Jeśli do tego czasu
  	nie pojawi się opłata, rezerwacja jest anulowana.
  */
  CREATE OR ALTER PROCEDURE DeleteUnpaidReservations
  AS
  
  	DELETE R FROM Reservations R
  	RIGHT JOIN ReservationPayments RP
  		ON R.Id = RP.Id
  	WHERE RP.Id IS NULL
  		AND DATEADD(week, 1, R.ReservationDate) > GETDATE();
  
  GO	
  ```

  

## Triggery

lorem ipsum

## Dane

lorem ipsum

## Generator danych

lorem ipsum

## Podsumowanie i wnioski