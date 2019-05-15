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
      W tinyint NOT NULL
    )
	/* https://pl.wikipedia.org/wiki/PESEL#Cyfra_kontrolna_i_sprawdzanie_poprawno.C5.9Bci_numeru */
  INSERT INTO @vals VALUES (1), (3), (7), (9), (1), (3), (7), (9), (1), (3), (1)

  IF (SELECT SUM(CONVERT(INT, SUBSTRING(@number, Pos, 1)) * W) % 10 FROM @vals ) = 0
  BEGIN
	DECLARE @month int = CONVERT(INT, SUBSTRING(@number, 3, 2))
	DECLARE @day int = CONVERT(INT, SUBSTRING(@number, 5, 2))
	IF(@month < 13 AND @day < 32)
	RETURN 1
  END
  RETURN 0
END

GO

CREATE FUNCTION IsDateBefore(
@before DATETIME,
@after DATETIME)
RETURNS bit
AS 
BEGIN
	IF  (@before < @after)
		BEGIN
			RETURN 1;
		END
	RETURN 0;
END

GO

/* Warunki integralnościowe dla unikalnego numeru pesel w tabeli, walidacja pesel według sumy kontrolnej i poprawności daty. Dla studenta  */
ALTER TABLE dbo.IndividualClients ADD CONSTRAINT PersonalNumberCheck CHECK (dbo.IsValidPesel(PersonalNumber) = 1 )
ALTER TABLE dbo.IndividualClients ADD CONSTRAINT UC_PersonalNumber UNIQUE (PersonalNumber)
ALTER TABLE dbo.Students ADD CONSTRAINT UC_StudentId Unique (StudentId)

GO

ALTER TABLE dbo.CorporateClients ADD CONSTRAINT UC_TaxNumber UNIQUE (TaxNumber)
ALTER TABLE dbo.CorporateClients ADD CONSTRAINT UC_CompanyNumber UNIQUE (TaxNumber)

GO
/* Warunki integralnościowe dla niepowtarzających się krotek adresu. */

ALTER TABLE dbo.Countries ADD CONSTRAINT UC_Country UNIQUE (Name);
ALTER TABLE dbo.Provinces ADD CONSTRAINT UC_Province UNIQUE (Name, CountryId);
ALTER TABLE dbo.Cities ADD CONSTRAINT UC_City UNIQUE (Name, ProvinceId);
ALTER TABLE dbo.Streets ADD CONSTRAINT UC_Street UNIQUE (Name, ZipCode, CityId);
ALTER TABLE dbo.Buildings ADD CONSTRAINT UC_Buildings UNIQUE (StreetId, Number, ApartmentNumber);
GO

/* Ceny dla konferencji powinny być unikalne dla krotki Konferencja, Dzień Od którego obowiązuje próg cenowy  */

ALTER TABLE dbo.ConferencePrices ADD CONSTRAINT UC_Price_Stage UNIQUE (ConferenceId, TillConferenceStart)
GO

--/*  Jeden klient może mieć tylko jedną rezerwację na daną konferencji */

--ALTER TABLE dbo.Reservations ADD CONSTRAINT UC_Client_ConferenceId UNIQUE (ClientId, )
--GO

/* Dla warsztatu upewnijmy się, że nigdy data zakończenia nie będzie poprzedzała daty rozpoczęcia */
ALTER TABLE dbo.Workshops ADD CONSTRAINT C_IsEndDateAfter CHECK (dbo.IsDateBefore(StartTime, EndTime) = 1)
GO

/* Nie można zarejestrować się na konferencję */
CREATE FUNCTION CanReservationBePlaced
(
	@conferenceDayId int  
)
RETURNS bit
AS
BEGIN

DECLARE @capacity int;
SELECT @capacity = Capacity from ConferenceDays WHERE Id = @conferenceDayId;

DECLARE @already int;
SELECT @already = COUNT(*) FROM Reservations Where ConferenceDayId = @conferenceDayId

IF (@capacity >= @already)
	RETURN 1;
RETURN 0;

END
GO

ALTER TABLE dbo.Reservations ADD CONSTRAINT C_IsEnoughtCapacity CHECK (dbo.CanReservationBePlaced(ConferenceDayId) = 1);
ALTER TABLE dbo.Reservations ADD CONSTRAINT DF_ReservationDate DEFAULT GETDATE() FOR ReservationDate;
GO