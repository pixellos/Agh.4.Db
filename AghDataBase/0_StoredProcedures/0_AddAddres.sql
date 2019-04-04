/*
    Założenia
	Ta procedura będzie używana przez naszego pracownika, ufamy danym, które wprowadzi, będą one zawsze poprawne.
	Przyjmuje krotkę z danymi adresowymi
	Zwraca nic.
*/
CREATE OR ALTER  PROCEDURE AddAddress
	@Street nvarchar(50),
	@ApartmentNumber int NULL,
	@BuildingNumber int,
	@ZipCode nvarchar(6),
	@City nvarchar(50),
	@Province nvarchar(50),
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
   IF NOT EXISTS (SELECT * FROM [dbo].Provinces WHERE Name = @Province and CountryId = @country_id)
   BEGIN
       INSERT INTO [dbo].[Provinces](Name, CountryId)
       VALUES (@Province, @country_id)
   END
END

DECLARE @province_id int;
SET @province_id =  (SELECT MIN(Id) FROM [dbo].[Provinces] WHERE Name = @Province and CountryId = @country_id);

BEGIN
   IF NOT EXISTS (SELECT * FROM [dbo].Cities WHERE Name = @City and ProvinceId = @province_id)
   BEGIN
       INSERT INTO [dbo].Cities(Name, ProvinceId)
       VALUES (@City, @province_id)
   END
END

DECLARE @city_id int;
SET @city_id = (SELECT MIN(Id) FROM [dbo].[Cities] WHERE Name = @City and ProvinceId = @province_id);

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
