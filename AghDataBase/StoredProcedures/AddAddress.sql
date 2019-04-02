/*
    Założenia
	Ta procedura będzie używana przez naszego pracownika, ufamy danym, które wprowadzi, będą one zawsze poprawne.
	Przyjmuje krotkę z danymi adresowymi
	Zwraca nic.

*/
CREATE OR ALTER PROCEDURE AddAddress
	@Street nvarchar(50),
	@ApartmentNumber int,
	@BuildingNumber int,
	@ZipCode nvarchar(6),
	@City nvarchar(50),
	@Province nvarchar(50),
	@Country nvarchar(50)
AS

BEGIN
   IF NOT EXISTS (SELECT * FROM [dbo].[Countries] WHERE Name = @Country)
   BEGIN
       INSERT INTO [dbo].[Countries](Name)
       VALUES (@Country)
   END
END

BEGIN
   IF NOT EXISTS (SELECT * FROM [dbo].Provinces WHERE Name = @Province)
   BEGIN
       INSERT INTO [dbo].[Provinces](Name, CountryId)
       VALUES (@Province, (SELECT MIN(Id) FROM [dbo].[Countries] WHERE Name = @Country))
   END
END


BEGIN
   IF NOT EXISTS (SELECT * FROM [dbo].Provinces WHERE Name = @Province)
   BEGIN
       INSERT INTO [dbo].[Provinces](Name, CountryId)
       VALUES (@Province, (SELECT MIN(Id) FROM [dbo].[Countries] WHERE Name = @Country))
   END
END


BEGIN
   IF NOT EXISTS (SELECT * FROM [dbo].Cities WHERE Name = @City)
   BEGIN
       INSERT INTO [dbo].Cities(Name, ProvinceId)
       VALUES (@City, (SELECT MIN(Id) FROM [dbo].[Provinces] WHERE Name = @Province))
   END
END

BEGIN
   IF NOT EXISTS (SELECT * FROM [dbo].Streets WHERE Name = @Street and ZipCode = @ZipCode)
   BEGIN
       INSERT INTO [dbo].Streets(Name, ZipCode, CityId)
       VALUES (@Street, @ZipCode, (SELECT MIN(Id) FROM [dbo].[Cities] WHERE Name = @City))
   END
END

BEGIN
   IF NOT EXISTS (SELECT * FROM [dbo].Buildings WHERE Number = @BuildingNumber and ApartmentNumber = @ApartmentNumber)
   BEGIN
       INSERT INTO [dbo].Buildings(Number, ApartmentNumber, StreetId)
       VALUES (@BuildingNumber, @ApartmentNumber, (SELECT MIN(Id) FROM [dbo].[Streets] WHERE Name = @Street and ZipCode = @ZipCode))
   END
END

RETURN;