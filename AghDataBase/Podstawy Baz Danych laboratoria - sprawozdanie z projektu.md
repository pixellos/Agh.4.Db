# Podstawy Baz Danych laboratoria - sprawozdanie z projektu

------

##### AGH IET 2019 - Mateusz Popielarz, Michał Flak



## Opis funkcjonalności bazy

lorem ipsum

## Użytkownicy i role

- ### customerservice

  Osoba obsługująca klientów indywidualnych i korporacyjnych. Zajmuje się zapisywaniem uczestników na konferencje i warsztaty, oraz obsługuje płatności.

  ```mssql
  CREATE ROLE [customerservice]
  GRANT SELECT ON GetAttendantsAtConferenceDay TO customerservice
  GRANT SELECT ON GetAttendantsAtWorkshopsOnConferenceDay TO customerservice
  GRANT SELECT ON GetConferenceStart TO customerservice
  GRANT SELECT ON GetIndividualClientOrThrow TO customerservice
  GRANT SELECT ON GetConferenceWithPriceAccordingToDate TO customerservice
  GRANT SELECT ON LoyalClientsView TO customerservice
  GRANT EXECUTE ON AddAddress TO customerservice
  GRANT EXECUTE ON AddClient TO customerservice
  GRANT EXECUTE ON AddCorporateClient TO customerservice
  GRANT EXECUTE ON AddStudent TO customerservice
  GRANT EXECUTE ON AssignEmployerToEmployee TO customerservice
  GRANT EXECUTE ON MakeReservation TO customerservice
  GRANT EXECUTE ON MakeReservationCorporation TO customerservice
  GRANT EXECUTE ON PayForReservationWithADate TO customerservice
  GRANT EXECUTE ON DeleteUnpaidReservations TO customerservice
  GRANT EXECUTE ON ReserveAPlaceForAWorkshop TO customerservice
  ```

  

- ### organizer

  Tworzy konferencje oraz warsztaty, nadaje im ceny za uczestnictwo.

```mssql
  CREATE ROLE [organizer]
  GRANT SELECT ON GetAttendantsAtConferenceDay TO customerservice
  GRANT SELECT ON GetAttendantsAtWorkshopsOnConferenceDay TO customerservice
  GRANT SELECT ON GetConferenceStart TO customerservice
  GRANT SELECT ON LoyalClientsView TO customerservice
  GRANT EXECUTE ON DeleteUnpaidReservations TO customerservice
  GRANT EXECUTE ON AddPriceToConference TO customerservice
  GRANT EXECUTE ON AddConference TO customerservice
  GRANT EXECUTE ON AddConferenceDay TO customerservice
  GRANT EXECUTE ON AddWorkshop TO customerservice
  GRANT EXECUTE ON AddPriceToWorkshop TO customerservice
```

  

## Schemat bazy danych

- ### Schemat UML

- ### Definicje tabel wraz z warunkami integracyjnymi

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

- ### GetIndividualClientOrThrow

  Zwraca ID klienta po PESEL-u.

  ```mssql
  
  CREATE FUNCTION GetIndividualClientOrThrow(@PersonalNumber nvarchar(50))
  RETURNS INT
  AS
  BEGIN
  
  	DECLARE @client_id int;
  	SELECT @client_id = Min(Id) FROM IndividualClients WHERE PersonalNumber = @PersonalNumber;
  
  	IF @client_id IS NULL 
  	BEGIN
  		 RETURN CAST('Client canont be found.' AS INT);
  	END	
  
  	RETURN @client_id;
  END
  GO
  
  ```

  

- ### GetAttendantsAtConferenceDay

  Podaje listę osób zarejestrowanych na dany dzień konferencji.

  ```mssql
  CREATE FUNCTION GetAttendantsAtConferenceDay (
  	@ConferenceId int,
  	@ConferenceDay int
  	)  
  RETURNS TABLE  
  AS  
  RETURN   
  (  
      SELECT CDC.Id as ConferenceDayId, A.FirstName, A.LastName, A.PersonalNumber, S.StudentId, CC.CompanyName
  	from (
  		SELECT * FROM ConferenceDays CD 
  		where CD.ConferenceId = @conferenceId
  		ORDER BY CD.Date ASC
  		OFFSET @ConferenceDay ROWS
  		FETCH NEXT 1 ROW ONLY
  	) AS CDC
  
  	LEFT JOIN IndividualClientConferenceDay ICCD
  	ON CDC.Id = ICCD.ConferenceDays_Id
  
  	LEFT JOIN IndividualClients A
  	ON A.Id = ICCD.IndividualClientConferenceDay_ConferenceDay_Id
  
  	LEFT JOIN Students S
  	ON S.Id = A.Id
  
  	LEFT JOIN CorporateClientEmployes CCE
  	ON A.Id = CCE.Id
  
  	LEFT JOIN CorporateClients CC
  	ON CC.Id = CCE.CorporateClientId
  );  
  ```

  

- ### GetConferenceStart

  Zwraca datę początku konferencji.

  ```mssql
  /*
      Zwraca Datę początku konferencji (Za początek konferencji przyjmujemy pierwszy dzień konferencji przypisany doń)
  */
  CREATE OR ALTER FUNCTION GetConferenceStart(@ConferenceIds int)
  RETURNS DATETIME
  AS
  BEGIN
  	DECLARE @date datetime;
  	SELECT @date = [Date]
  	FROM ConferenceDays
  	WHERE ConferenceId = @ConferenceIds
  	ORDER BY [Date];
  	RETURN @date;
  END
  GO
  ```

  

- ### GetConferenceWithPriceAccordingToDate

  Zwraca cenę konferencji biorąc pod uwagę datę zaksięgowania przelewu.

  ```mssql
  /*
      Zwraca cenę konferencji biorąc pod uwagę datę zaksięgowania przelewu
  */
  CREATE OR ALTER FUNCTION GetConferenceWithPriceAccordingToDate(@ConferenceId int, @PaymentDate datetime)
  RETURNS decimal
  AS
  BEGIN
  	DECLARE @result decimal;
  
  SELECT TOP(1) @result = Price
  	FROM ConferencePrices
  	WHERE @ConferenceId = ConferenceId AND DATEADD(DD, -TillConferenceStart, dbo.GetConferenceStart(ConferenceId)) < DATEADD(DD, 0, @PaymentDate)
  	ORDER BY TillConferenceStart
  	
  	RETURN @result;
  END
  GO
  
  ```

  

- ### GetConferencePriceId

  Zwraca id conferenceprice biorąc pod uwagę datę zaksięgowania przelewu.

  ```mssql
  /*
      Zwraca id conference price biorąc pod uwagę datę zaksięgowania przelewu
  */
  CREATE OR ALTER FUNCTION GetConferencePriceId(@ConferenceId int, @PaymentDate datetime)
  RETURNS int
  AS
  BEGIN
  	DECLARE @result int;
  
  	SELECT TOP(1) @result = Id
  	FROM ConferencePrices
  	WHERE @ConferenceId = ConferenceId AND DATEADD(DD, -TillConferenceStart, dbo.GetConferenceStart(ConferenceId)) < DATEADD(DD, 0, @PaymentDate)
  	ORDER BY TillConferenceStart
  	RETURN @result;
  END
  GO
  
  ```

  

- ### GetConferencePrice

  Zwraca cenę konferencji i bierze pod uwagę, czy jest się studentem.

  ```mssql
  /*
  	Zwraca cenę konferencji i bierze pod uwagę, czy jest studentem.
  */
  CREATE OR ALTER FUNCTION GetConferencePrice(
  	@ConferenceId int, 
  	@PersonalNumber nvarchar(50),
  	@PaymentDate DateTime)
  	RETURNS decimal
  	AS 
  BEGIN
  	DECLARE @conference_price decimal;
  	SELECT @conference_price = dbo.GetConferenceWithPriceAccordingToDate(@ConferenceId, @PaymentDate)
  
  	DECLARE @client_id int
  	SELECT @client_id = dbo.GetIndividualClientOrThrow(@PersonalNumber);
  
  	DECLARE @student_id int
  	SELECT TOP(1)
  		@student_id = [Id]
  	FROM Students
  	WHERE Id = @client_id;
  
  	DECLARE @student_discount int;
  	SELECT TOP(1) @student_discount = StudentDiscount FROM Conferences where Id = @ConferenceId;
  
  	IF @student_discount is NULL OR @student_discount = 0
  	BEGIN
  		RETURN @conference_price;
  	END
  
  	IF @student_discount <= 100
  	BEGIN
  		RETURN @conference_price * (@student_discount / 100);
  	END
  	   
  	RETURN Cast('Never should be there' as int)
  END
  GO
  ```

  

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

- ### AddWorkshop

  Dodaje warsztat i przypisuje go do dnia konferencji.

  ```mssql
    /*
     Tworzymy warsztat
  */
  CREATE PROCEDURE AddWorkshop 
  	@ConferenceDayId int,
  	@StartDate datetime,
  	@EndDate datetime,
  	@Name nvarchar(50)
  	AS
  	DECLARE @workshop_id int;
  
  	BEGIN TRANSACTION
  		INSERT INTO Workshops(StartTime, EndTime, ConferenceDayId, Name) VALUES 
  		(@StartDate, @EndDate, @ConferenceDayId, @Name);
  			
  		SET @workshop_id = @@IDENTITY;
  	COMMIT;
  	
  	RETURN @workshop_id;
  GO
  ```

  

- ### AddPriceToWorkshop

  Ustanawia cenę udziału w warsztacie.

  ```mssql
  CREATE PROCEDURE AddPriceToWorkshop
  	@Price decimal,
  	@WorkshopId int
  	as 
  
  	IF @Price < 0
  	BEGIN
  		RETURN -1;
  	END
  
  	INSERT INTO WorkshopPrices(Id, Price) VALUES (@WorkshopId, @Price);
  
  	RETURN @@IDENTITY;
  GO
  ```

  

- ### ReserveAPlaceForAWorkshop

  Rezerwuje udział w warsztacie dla klienta.

  ```mssql
  CREATE PROCEDURE ReserveAPlaceForAWorkshop
  	@WorkshopId int,
  	@ClientId int
  	as 
  
      INSERT INTO WorkshopReservations(ClientId, WorkshopId) VALUES (@ClientId, @WorkshopId)
  
  	RETURN @@IDENTITY;
  GO
  ```

  

## Triggery

- ### DISALLOW_WORKSHOP_RESERVATION_FOR_SAME_CLIENT

  Zapewnia, że klient nie zarejestruje się na równocześnie trwające warsztaty.

  ```mssql
  CREATE TRIGGER DISALLOW_WORKSHOP_RESERVATION_FOR_SAME_CLIENT
  ON [WorkshopReservations]
  AFTER INSERT
  AS
  
  IF EXISTS (
  SELECT * FROM inserted i INNER JOIN Workshops WI ON i.Id = WI.Id where 
  	(SELECT COUNT(*) FROM WorkshopReservations INNER JOIN Workshops WRW ON WorkshopReservations.Id = WRW.Id 
  		WHERE  WI.StartTime <= WRW.StartTime AND WI.EndTime <= WRW.EndTime AND WI.EndTime >= WRW.StartTime
  	)
  	> 0
  )
  BEGIN
  RAISERROR ('Same client can not have overlapping time.', 16, 1);
  ROLLBACK TRANSACTION;
  RETURN 
  END;
  
  GO
  ```

  

## Dane



## Generator danych

Generator danych został stworzony z użyciem biblioteki Bogus.

Generujemy ` return conferenceFaker.GenerateLazy(2 * 3 * 12 + 5).ToList();` konferencji, co odpowiada 2 konferencjom przez trzy lata.

Każda konferencja ma regułę, że posiada do 100 miejsc
`conferenceDayFaker.RuleFor(x => x.Capacity, x => x.Random.Number(100));`
ponadto
`var r = f.Random.Number(1, 5);` 
odpowiada za liczbę dni na konferencję, biblioteka gwarantuje nam rozkład normalny generowanych wartości, więc średnio będzie to 2,3 dni.

Za warsztaty odpowiada ` var r2 = f.Random.Number(0, 8);` - średnio będzie 4 warsztaty na dzień, na każdy będzie od 0 do 8 warsztatów.

Za przypisanie uczestników do konferencji odpowiada fragment 
```c#
        foreach (var conference in context.Conferences)
            {
                foreach (var day in conference.ConferenceDays)
                {
                    foreach (var reservation in day.Reservations)
                    {
                        if(faker.Random.Bool() && conference.ConferencePrices.Any())
                        {
                            var price = faker.PickRandom(conference.ConferencePrices);
                            reservation.ReservationPayment = new ReservationPayment()
                            {
                                Client = reservation.Client,
                                Amount = price.Price,
                                ConferencePrice = price,
                            };
                        }
                    }
                }
            }
```
Dla każdej stworzonej konferencji, która ma cenę (mogą być darmowe) tworzymy prezentacje i losową spłacamy.
Fragment 
```c#
    var workshops = context.Workshops.ToArray();
            foreach (var workshop in workshops)
            {
                var prices = faker.Random.Number(500);

                if (faker.Random.Bool())
                {
                    var toAdd = new WorkshopPrice
                    {
                        Price = faker.Random.Number(1, 400),
                    };
                    workshop.WorkshopPrice = toAdd;

                    foreach (var res in workshop.WorkshopReservations)
                    {
                        res.WorkshopReservationPayment = new WorkshopReservationPayment
                        {
                            Amount = workshop.WorkshopPrice.Price,
                        };
                    }
                }
            }
```
wykonuje analogiczną operację dla warsztatu.

Stworzone zostały też metody `PopulateBuildings`, `PopulateIndividualClient`, `PopulateCorporateClient`,
 `PopulateStudents`, które losują poszczególne adresy, klientów, klientów korporacyjnych i studentów.

Dla klientów indywidualnych został zaimplementowany generator pesel.

```C#
using System;
using System.Text;

namespace AghDataBase
{
    public class PeselGenerator
    {
        private readonly Random _random;

        public PeselGenerator()
        {
            this._random = new Random();
        }

        public string Generate()
        {
            var peselStringBuilder = new StringBuilder();
            var birthDate = this.GenerateDate(1900, 2099);

            this.AppendPeselDate(birthDate, peselStringBuilder);

            peselStringBuilder.Append(this.GenerateRandomNumbers(4));

            peselStringBuilder.Append(PeselCheckSumCalculator.Calculate(peselStringBuilder.ToString()));

            return peselStringBuilder.ToString();
        }

        public static string GetPeselMonthShiftedByYear(DateTime date)
        {
            if (date.Year < 1900 || date.Year > 2299)
            {
                throw new NotSupportedException(System.String.Format("PESEL for year: {0} is not supported", date.Year));
            }

            var monthShift = (int)((date.Year - 1900) / 100) * 20;

            return (date.Month + monthShift).ToString("00");
        }

        private DateTime GenerateDate(int yearFrom, int yearTo)
        {
            var year = this._random.Next(yearFrom, yearTo + 1);
            var month = this._random.Next(12) + 1;
            var day = this._random.Next(DateTime.DaysInMonth(year, month)) + 1;

            return new DateTime(year, month, day);
        }

        private void AppendPeselDate(DateTime date, StringBuilder builder)
        {
            builder.Append((date.Year % 100).ToString("00"));
            builder.Append(GetPeselMonthShiftedByYear(date));
            builder.Append(date.Day.ToString("00"));
        }

        private string GenerateRandomNumbers(int numbersCount)
        {
            var maxValue = (int)Math.Pow(10, numbersCount);
            var format = "D" + numbersCount;

            return this._random.Next(maxValue).ToString(format);
        }
    }
}
```


```c#
using Bogus;
using System.Collections.Generic;
using System.Linq;

namespace AghDataBase
{
    internal class Program
    {
        private static PeselGenerator peselGenerator = new PeselGenerator();


        private static void Main(string[] args)
        {
            var context = new Model1Container();
            var availableBuildings = PopulateBuildings();
            var randomizeIndividualClient = PopulateIndividualClient(availableBuildings);
            var randomizeCorporateClient = PopulateCorporateClient(availableBuildings);
            var students = PopulateStudents(availableBuildings);
            var randomizeConferences = PopulateConferences(availableBuildings, randomizeCorporateClient, students, randomizeIndividualClient);

            var employeRelation = new Faker<CorporateClientEmploye>().RuleFor(x => x.Title, f => f.Company.CatchPhrase())
                .RuleFor(x => x.CorporateClient, f => f.PickRandom(randomizeCorporateClient))
                .RuleFor(x => x.IndividualClients, f => f.PickRandom(randomizeIndividualClient));

            context.IndividualClients.AddRange(randomizeIndividualClient);
            context.CorporateClients.AddRange(randomizeCorporateClient);
            context.Conferences.AddRange(randomizeConferences);
            context.Students.AddRange(students);
            context.CorporateClientEmployes.AddRange(employeRelation.GenerateLazy(700));
            context.SaveChanges();

            var faker = new Faker();
            var conferences = context.Conferences.ToArray();
            foreach (var conference in conferences)
            {
                var prices = faker.Random.Number(5);
                var tillDays = 0;
                var price = 0;

                for (var p = 0; p < prices; p++)
                {
                    tillDays += faker.Random.Number(1, 14);
                    var priceAddition = faker.Random.Number(1, 200);
                    price += priceAddition;
                    var toAdd = new ConferencePrices
                    {
                        TillConferenceStart = (short)tillDays,
                        Price = price
                    };
                    conference.ConferencePrices.Add(toAdd);
                }
            }
            context.SaveChanges();

            foreach (var conference in context.Conferences)
            {
                foreach (var day in conference.ConferenceDays)
                {
                    foreach (var reservation in day.Reservations)
                    {
                        if(faker.Random.Bool() && conference.ConferencePrices.Any())
                        {
                            var price = faker.PickRandom(conference.ConferencePrices);
                            reservation.ReservationPayment = new ReservationPayment()
                            {
                                Client = reservation.Client,
                                Amount = price.Price,
                                ConferencePrice = price,
                            };
                        }
                    }
                }
            }

            var workshops = context.Workshops.ToArray();
            foreach (var workshop in workshops)
            {
                var prices = faker.Random.Number(500);

                if (faker.Random.Bool())
                {
                    var toAdd = new WorkshopPrice
                    {
                        Price = faker.Random.Number(1, 400),
                    };
                    workshop.WorkshopPrice = toAdd;

                    foreach (var res in workshop.WorkshopReservations)
                    {
                        res.WorkshopReservationPayment = new WorkshopReservationPayment
                        {
                            Amount = workshop.WorkshopPrice.Price,
                        };
                    }
                }
            }
            context.SaveChanges();


        }

        private static List<Conference> PopulateConferences(List<Building> buildings, List<CorporateClient> corporateClients, IEnumerable<Student> clients, IEnumerable<IndividualClient> individualClients)
        {
            var conferenceDayFaker = new Faker<ConferenceDay>();
            conferenceDayFaker.RuleFor(x => x.Capacity, x => x.Random.Number(100));

            var workshopFaker = new Faker<Workshop>()
                .RuleFor(x => x.Name, f => new string(f.Hacker.Verb().Take(48).ToArray()))
                .RuleFor(x => x.WorkshopPrice, f => f.Random.Bool() ? new WorkshopPrice() { Price = (int)f.Random.Decimal(800) } : null);

            var cls = individualClients.Concat(clients.Select(x => x.IndividualClient)).Select(x => x.Client).ToList();

            var conferenceFaker = new Faker<Conference>();
            conferenceFaker
                .RuleFor(x => x.Building, f => buildings[f.Random.Number(buildings.Count - 1)])
                .RuleFor(x => x.Name, f => f.Lorem.Word())
                .RuleFor(x => x.StudentDiscount, f => (byte)f.Random.Number(99))
                .RuleFor(x => x.ConferenceDays, f =>
                {

                    var list = new List<ConferenceDay>();
                    var r = f.Random.Number(1, 5);
                    var r2 = f.Random.Number(0, 8);
                    for (var i = 0; i < r; i++)
                    {
                        var date = f.Date.PastOffset(3);
                        var day = conferenceDayFaker.Generate();
                        for (var res = 0; res < f.Random.Number(day.Capacity); res++)
                        {
                            var reservation = new Reservation();
                            reservation.Client = f.PickRandom(cls);
                            day.Reservations.Add(reservation);
                        }

                        var randomDate = f.Date.RecentOffset(r, date);
                        day.Date = randomDate.Date;
                        if (list.All(x => x.Date != day.Date))
                        {
                            for (var w = 0; w < r2; w++)
                            {
                                var workshop = workshopFaker.Generate();
                                workshop.StartTime = f.Date.Between(day.Date, day.Date.AddDays(1));
                                workshop.EndTime = f.Date.Between(workshop.StartTime, day.Date.AddDays(1));
                                day.Workshops.Add(workshop);

                                var r3 = f.Random.Int(0, 7);
                                for (var rr3 = 0; rr3 < r3; rr3++)
                                {
                                    workshop.WorkshopReservations.Add(new WorkshopReservation
                                    {
                                        Client = f.PickRandom(cls)
                                    });
                                }
                            }

                            list.Add(day);
                        }
                    }
                    return list;
                })
                .RuleFor(x => x.CorporateClient, f => corporateClients[f.Random.Number(corporateClients.Count - 1)]);

            return conferenceFaker.GenerateLazy(2 * 3 * 12 + 5).ToList();
        }

        private static List<CorporateClient> PopulateCorporateClient(List<Building> buildings)
        {
            var clientFaker = new Faker<Client>()
                .RuleFor(x => x.Telephone, f => f.Person.Phone)
                .RuleFor(x => x.Building, f => buildings[f.Random.Number(buildings.Count - 1)]);

            var conferenceDay = new Faker<ConferenceDay>()
                .RuleFor(x => x.Date, f => f.Date.Future());

            var peselGenerator = new PeselGenerator();

            var icFaker = new Faker<CorporateClient>()
                .RuleFor(x => x.CompanyName, f => f.Company.CompanyName())
                .RuleFor(x => x.TaxNumber, f => f.Finance.Account(29))
                .RuleFor(x => x.Client, f => clientFaker.Generate());

            return icFaker.GenerateLazy(40).ToList();
        }

        private static List<IndividualClient> PopulateIndividualClient(List<Building> buildings)
        {
            var clientFaker = new Faker<Client>()
                .RuleFor(x => x.Telephone, f => f.Person.Phone)
                .RuleFor(x => x.Building, f => buildings[f.Random.Number(buildings.Count - 1)]);


            var icFaker = new Faker<IndividualClient>();
            icFaker.RuleFor(x => x.FirstName, f => f.Name.FirstName())
            .RuleFor(x => x.LastName, f => f.Name.LastName())
            .RuleFor(x => x.PersonalNumber, f => peselGenerator.Generate())
            .RuleFor(x => x.Client, f => clientFaker.Generate());

            return icFaker.GenerateLazy(100).ToList();
        }

        private static List<Student> PopulateStudents(List<Building> buildings)
        {
            var studentFaker = new Faker<Student>();
            studentFaker
                .RuleFor(x => x.StudentId, f => new string(f.Random.Chars('0', '9', 9)))
                .RuleFor(x => x.IndividualClient, f => PopulateIndividualClient(buildings).First());
            return studentFaker.GenerateLazy(500).ToList();
        }

        private static List<Building> PopulateBuildings()
        {
            var availableBuildings = new List<Building>();

            var countryFaker = new Faker<Country>()
                .RuleFor(o => o.Name, f => f.Address.Country());

            var cityFaker = new Faker<City>()
                .RuleFor(o => o.Name, f => f.Address.City());

            var streetFaker = new Faker<Street>()
                .RuleFor(o => o.ZipCode, f => f.Address.ZipCode())
                .RuleFor(o => o.Name, f => f.Address.StreetName());

            var buildingFaker = new Faker<Building>()
                .RuleFor(o => o.ApartmentNumber, f => f.Random.Number(100))
                .RuleFor(o => o.Number, f => f.Address.BuildingNumber());

            var countries = countryFaker.Generate(4);

            foreach (var country in countries)
            {
                foreach (var cf in cityFaker.Generate(8))
                {
                    cf.Country = country;
                    foreach (var sf in streetFaker.Generate(5))
                    {
                        sf.City = cf;
                        foreach (var bf in buildingFaker.Generate(2))
                        {
                            bf.Street = sf;
                            availableBuildings.Add(bf);
                        }
                    }
                }
            }
            return availableBuildings;
        }


    }
}
```



## Podsumowanie i wnioski

