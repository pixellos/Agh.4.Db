/*
    When IndividualClient is saved PESEL is parsed
*/

CREATE FUNCTION IsValidPesel
(
  @number nchar(11)
)
RETURNS bit
AS
BEGIN
  IF ISNUMERIC(@number) = 0
    RETURN 0
  DECLARE
    @vals AS TABLE
    (
      Pos tinyint IDENTITY(1,1) NOT NULL,
      Weight tinyint NOT NULL
    )
	/* https://pl.wikipedia.org/wiki/PESEL#Cyfra_kontrolna_i_sprawdzanie_poprawno.C5.9Bci_numeru */
  INSERT INTO @vals VALUES (1), (3), (7), (9), (1), (3), (7), (9), (1), (3), (1)

  IF (SELECT SUM(CONVERT(INT, SUBSTRING(@number, Pos, 1)) * Weight) % 10 FROM @vals ) = 0
  BEGIN
	DECLARE @month int = CONVERT(INT, SUBSTRING(@number, 3, 2))
	DECLARE @day int = CONVERT(INT, SUBSTRING(@number, 5, 2))
	IF(@month < 13 AND @day < 32)
	RETURN 1
  END
  RETURN 0
END

GO
ALTER TABLE dbo.IndividualClients ADD CONSTRAINT PersonalNumberCheck CHECK (dbo.IsValidPesel(PersonalNumber) = 1 )
GO

ALTER TABLE dbo.Countries ADD CONSTRAINT UC_Country UNIQUE (Name);
GO

ALTER TABLE dbo.Provinces ADD CONSTRAINT UC_Province UNIQUE (Name, CountryId);
GO

ALTER TABLE dbo.Cities ADD CONSTRAINT UC_City UNIQUE (Name, ProvinceId);
GO

ALTER TABLE dbo.Streets ADD CONSTRAINT UC_Street UNIQUE (Name, ZipCode, CityId);
GO

ALTER TABLE dbo.Buildings ADD CONSTRAINT UC_Buildings UNIQUE (StreetId, Number, ApartmentNumber);
GO
