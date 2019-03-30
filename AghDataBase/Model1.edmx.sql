
-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, 2012 and Azure
-- --------------------------------------------------
-- Date Created: 03/30/2019 11:01:55
-- Generated from EDMX file: C:\Users\rogoz\source\repos\AghDataBase\AghDataBase\Model1.edmx
-- --------------------------------------------------

SET QUOTED_IDENTIFIER OFF;
GO
USE [AghDataBase];
GO
IF SCHEMA_ID(N'dbo') IS NULL EXECUTE(N'CREATE SCHEMA [dbo]');
GO

-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[FK_Client_CorporateClient]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[CorporateClients] DROP CONSTRAINT [FK_Client_CorporateClient];
GO
IF OBJECT_ID(N'[dbo].[FK_Client_IndividualClient]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[IndividualClients] DROP CONSTRAINT [FK_Client_IndividualClient];
GO
IF OBJECT_ID(N'[dbo].[FK_CorporateClientEmployeIndividualClient]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[IndividualClients] DROP CONSTRAINT [FK_CorporateClientEmployeIndividualClient];
GO
IF OBJECT_ID(N'[dbo].[FK_CorporateClientCorporateClientEmploye]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[CorporateClientEmployes] DROP CONSTRAINT [FK_CorporateClientCorporateClientEmploye];
GO
IF OBJECT_ID(N'[dbo].[FK_ConferenceConferencePrices]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[ConferencePrices] DROP CONSTRAINT [FK_ConferenceConferencePrices];
GO
IF OBJECT_ID(N'[dbo].[FK_StudentIndividualClient]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Students1] DROP CONSTRAINT [FK_StudentIndividualClient];
GO
IF OBJECT_ID(N'[dbo].[FK_CityStreet]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Streets] DROP CONSTRAINT [FK_CityStreet];
GO
IF OBJECT_ID(N'[dbo].[FK_ProvinceCity]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Cities] DROP CONSTRAINT [FK_ProvinceCity];
GO
IF OBJECT_ID(N'[dbo].[FK_StreetBuilding]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Buildings] DROP CONSTRAINT [FK_StreetBuilding];
GO
IF OBJECT_ID(N'[dbo].[FK_CountryProvince]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Provinces] DROP CONSTRAINT [FK_CountryProvince];
GO
IF OBJECT_ID(N'[dbo].[FK_ClientBuilding]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Clients] DROP CONSTRAINT [FK_ClientBuilding];
GO
IF OBJECT_ID(N'[dbo].[FK_ConferenceBuilding]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Conferences] DROP CONSTRAINT [FK_ConferenceBuilding];
GO
IF OBJECT_ID(N'[dbo].[FK_ConferenceDayConference]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[ConferenceDays] DROP CONSTRAINT [FK_ConferenceDayConference];
GO
IF OBJECT_ID(N'[dbo].[FK_WorkshopReservationWorkshop]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[WorkshopReservations] DROP CONSTRAINT [FK_WorkshopReservationWorkshop];
GO
IF OBJECT_ID(N'[dbo].[FK_ReservationClient]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Reservations] DROP CONSTRAINT [FK_ReservationClient];
GO
IF OBJECT_ID(N'[dbo].[FK_ConferenceReservation]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Reservations] DROP CONSTRAINT [FK_ConferenceReservation];
GO
IF OBJECT_ID(N'[dbo].[FK_IndividualClientConferenceDay]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[ConferenceDays] DROP CONSTRAINT [FK_IndividualClientConferenceDay];
GO
IF OBJECT_ID(N'[dbo].[FK_IndividualClientWorkshopReservation]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[WorkshopReservations] DROP CONSTRAINT [FK_IndividualClientWorkshopReservation];
GO
IF OBJECT_ID(N'[dbo].[FK_WorkshopWorkshopPrice]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Workshops] DROP CONSTRAINT [FK_WorkshopWorkshopPrice];
GO

-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[Clients]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Clients];
GO
IF OBJECT_ID(N'[dbo].[CorporateClients]', 'U') IS NOT NULL
    DROP TABLE [dbo].[CorporateClients];
GO
IF OBJECT_ID(N'[dbo].[IndividualClients]', 'U') IS NOT NULL
    DROP TABLE [dbo].[IndividualClients];
GO
IF OBJECT_ID(N'[dbo].[CorporateClientEmployes]', 'U') IS NOT NULL
    DROP TABLE [dbo].[CorporateClientEmployes];
GO
IF OBJECT_ID(N'[dbo].[Workshops]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Workshops];
GO
IF OBJECT_ID(N'[dbo].[WorkshopPrices]', 'U') IS NOT NULL
    DROP TABLE [dbo].[WorkshopPrices];
GO
IF OBJECT_ID(N'[dbo].[Conferences]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Conferences];
GO
IF OBJECT_ID(N'[dbo].[ConferencePrices]', 'U') IS NOT NULL
    DROP TABLE [dbo].[ConferencePrices];
GO
IF OBJECT_ID(N'[dbo].[Students1]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Students1];
GO
IF OBJECT_ID(N'[dbo].[Cities]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Cities];
GO
IF OBJECT_ID(N'[dbo].[Streets]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Streets];
GO
IF OBJECT_ID(N'[dbo].[Provinces]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Provinces];
GO
IF OBJECT_ID(N'[dbo].[Buildings]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Buildings];
GO
IF OBJECT_ID(N'[dbo].[Countries]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Countries];
GO
IF OBJECT_ID(N'[dbo].[Reservations]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Reservations];
GO
IF OBJECT_ID(N'[dbo].[ConferenceDays]', 'U') IS NOT NULL
    DROP TABLE [dbo].[ConferenceDays];
GO
IF OBJECT_ID(N'[dbo].[WorkshopReservations]', 'U') IS NOT NULL
    DROP TABLE [dbo].[WorkshopReservations];
GO

-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

-- Creating table 'Clients'
CREATE TABLE [dbo].[Clients] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Telephone] nvarchar(max)  NOT NULL,
    [BuildingId] int  NOT NULL
);
GO

-- Creating table 'CorporateClients'
CREATE TABLE [dbo].[CorporateClients] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [CompanyName] nvarchar(max)  NOT NULL,
    [TaxNumber] nvarchar(max)  NOT NULL,
    [Client_Id] int  NOT NULL
);
GO

-- Creating table 'IndividualClients'
CREATE TABLE [dbo].[IndividualClients] (
    [Id] int  NOT NULL,
    [FirstName] nvarchar(max)  NOT NULL,
    [LastName] nvarchar(max)  NOT NULL,
    [PersonalNumber] nvarchar(max)  NOT NULL,
    [Client_Id] int  NOT NULL,
    [CorporateClientEmploye_Id] int  NOT NULL
);
GO

-- Creating table 'CorporateClientEmployes'
CREATE TABLE [dbo].[CorporateClientEmployes] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Title] nvarchar(max)  NOT NULL,
    [CorporateClientId] int  NULL
);
GO

-- Creating table 'Workshops'
CREATE TABLE [dbo].[Workshops] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [StartTime] datetime  NOT NULL,
    [EndTime] datetime  NOT NULL,
    [WorkshopPrice_Id] int  NOT NULL
);
GO

-- Creating table 'WorkshopPrices'
CREATE TABLE [dbo].[WorkshopPrices] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Price] nvarchar(max)  NOT NULL
);
GO

-- Creating table 'Conferences'
CREATE TABLE [dbo].[Conferences] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Name] nvarchar(max)  NOT NULL,
    [BuildingId] int  NOT NULL,
    [Discount] tinyint  NOT NULL
);
GO

-- Creating table 'ConferencePrices'
CREATE TABLE [dbo].[ConferencePrices] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [ConferenceId] int  NOT NULL,
    [TillConferenceStart] datetimeoffset  NOT NULL,
    [Price] nvarchar(max)  NOT NULL
);
GO

-- Creating table 'Students'
CREATE TABLE [dbo].[Students] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [StudentId] nvarchar(max)  NOT NULL
);
GO

-- Creating table 'Cities'
CREATE TABLE [dbo].[Cities] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Name] nvarchar(max)  NOT NULL,
    [ProvinceId] int  NOT NULL
);
GO

-- Creating table 'Streets'
CREATE TABLE [dbo].[Streets] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Name] nvarchar(max)  NOT NULL,
    [ZipCode] nvarchar(max)  NOT NULL,
    [CityId] int  NOT NULL
);
GO

-- Creating table 'Provinces'
CREATE TABLE [dbo].[Provinces] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Name] nvarchar(max)  NOT NULL,
    [CountryId] int  NOT NULL
);
GO

-- Creating table 'Buildings'
CREATE TABLE [dbo].[Buildings] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [StreetId] int  NOT NULL,
    [Number] nvarchar(max)  NOT NULL,
    [ApartmentNumber] int  NULL
);
GO

-- Creating table 'Countries'
CREATE TABLE [dbo].[Countries] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Name] nvarchar(max)  NOT NULL
);
GO

-- Creating table 'Reservations'
CREATE TABLE [dbo].[Reservations] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [ClientId] int  NOT NULL,
    [ConferenceId] int  NOT NULL
);
GO

-- Creating table 'ConferenceDays'
CREATE TABLE [dbo].[ConferenceDays] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Date] nvarchar(max)  NOT NULL,
    [ConferenceId] int  NOT NULL,
    [Capacity] int  NOT NULL,
    [IndividualClientId] int  NOT NULL
);
GO

-- Creating table 'WorkshopReservations'
CREATE TABLE [dbo].[WorkshopReservations] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [WorkshopId] int  NOT NULL,
    [IndividualClientId] int  NOT NULL
);
GO

-- --------------------------------------------------
-- Creating all PRIMARY KEY constraints
-- --------------------------------------------------

-- Creating primary key on [Id] in table 'Clients'
ALTER TABLE [dbo].[Clients]
ADD CONSTRAINT [PK_Clients]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'CorporateClients'
ALTER TABLE [dbo].[CorporateClients]
ADD CONSTRAINT [PK_CorporateClients]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'IndividualClients'
ALTER TABLE [dbo].[IndividualClients]
ADD CONSTRAINT [PK_IndividualClients]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'CorporateClientEmployes'
ALTER TABLE [dbo].[CorporateClientEmployes]
ADD CONSTRAINT [PK_CorporateClientEmployes]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Workshops'
ALTER TABLE [dbo].[Workshops]
ADD CONSTRAINT [PK_Workshops]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'WorkshopPrices'
ALTER TABLE [dbo].[WorkshopPrices]
ADD CONSTRAINT [PK_WorkshopPrices]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Conferences'
ALTER TABLE [dbo].[Conferences]
ADD CONSTRAINT [PK_Conferences]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'ConferencePrices'
ALTER TABLE [dbo].[ConferencePrices]
ADD CONSTRAINT [PK_ConferencePrices]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Students'
ALTER TABLE [dbo].[Students]
ADD CONSTRAINT [PK_Students]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Cities'
ALTER TABLE [dbo].[Cities]
ADD CONSTRAINT [PK_Cities]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Streets'
ALTER TABLE [dbo].[Streets]
ADD CONSTRAINT [PK_Streets]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Provinces'
ALTER TABLE [dbo].[Provinces]
ADD CONSTRAINT [PK_Provinces]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Buildings'
ALTER TABLE [dbo].[Buildings]
ADD CONSTRAINT [PK_Buildings]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Countries'
ALTER TABLE [dbo].[Countries]
ADD CONSTRAINT [PK_Countries]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'Reservations'
ALTER TABLE [dbo].[Reservations]
ADD CONSTRAINT [PK_Reservations]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'ConferenceDays'
ALTER TABLE [dbo].[ConferenceDays]
ADD CONSTRAINT [PK_ConferenceDays]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'WorkshopReservations'
ALTER TABLE [dbo].[WorkshopReservations]
ADD CONSTRAINT [PK_WorkshopReservations]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------

-- Creating foreign key on [Client_Id] in table 'CorporateClients'
ALTER TABLE [dbo].[CorporateClients]
ADD CONSTRAINT [FK_Client_CorporateClient]
    FOREIGN KEY ([Client_Id])
    REFERENCES [dbo].[Clients]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_Client_CorporateClient'
CREATE INDEX [IX_FK_Client_CorporateClient]
ON [dbo].[CorporateClients]
    ([Client_Id]);
GO

-- Creating foreign key on [Client_Id] in table 'IndividualClients'
ALTER TABLE [dbo].[IndividualClients]
ADD CONSTRAINT [FK_Client_IndividualClient]
    FOREIGN KEY ([Client_Id])
    REFERENCES [dbo].[Clients]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_Client_IndividualClient'
CREATE INDEX [IX_FK_Client_IndividualClient]
ON [dbo].[IndividualClients]
    ([Client_Id]);
GO

-- Creating foreign key on [CorporateClientEmploye_Id] in table 'IndividualClients'
ALTER TABLE [dbo].[IndividualClients]
ADD CONSTRAINT [FK_CorporateClientEmployeIndividualClient]
    FOREIGN KEY ([CorporateClientEmploye_Id])
    REFERENCES [dbo].[CorporateClientEmployes]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_CorporateClientEmployeIndividualClient'
CREATE INDEX [IX_FK_CorporateClientEmployeIndividualClient]
ON [dbo].[IndividualClients]
    ([CorporateClientEmploye_Id]);
GO

-- Creating foreign key on [CorporateClientId] in table 'CorporateClientEmployes'
ALTER TABLE [dbo].[CorporateClientEmployes]
ADD CONSTRAINT [FK_CorporateClientCorporateClientEmploye]
    FOREIGN KEY ([CorporateClientId])
    REFERENCES [dbo].[CorporateClients]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_CorporateClientCorporateClientEmploye'
CREATE INDEX [IX_FK_CorporateClientCorporateClientEmploye]
ON [dbo].[CorporateClientEmployes]
    ([CorporateClientId]);
GO

-- Creating foreign key on [ConferenceId] in table 'ConferencePrices'
ALTER TABLE [dbo].[ConferencePrices]
ADD CONSTRAINT [FK_ConferenceConferencePrices]
    FOREIGN KEY ([ConferenceId])
    REFERENCES [dbo].[Conferences]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_ConferenceConferencePrices'
CREATE INDEX [IX_FK_ConferenceConferencePrices]
ON [dbo].[ConferencePrices]
    ([ConferenceId]);
GO

-- Creating foreign key on [Id] in table 'Students'
ALTER TABLE [dbo].[Students]
ADD CONSTRAINT [FK_StudentIndividualClient]
    FOREIGN KEY ([Id])
    REFERENCES [dbo].[IndividualClients]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating foreign key on [CityId] in table 'Streets'
ALTER TABLE [dbo].[Streets]
ADD CONSTRAINT [FK_CityStreet]
    FOREIGN KEY ([CityId])
    REFERENCES [dbo].[Cities]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_CityStreet'
CREATE INDEX [IX_FK_CityStreet]
ON [dbo].[Streets]
    ([CityId]);
GO

-- Creating foreign key on [ProvinceId] in table 'Cities'
ALTER TABLE [dbo].[Cities]
ADD CONSTRAINT [FK_ProvinceCity]
    FOREIGN KEY ([ProvinceId])
    REFERENCES [dbo].[Provinces]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_ProvinceCity'
CREATE INDEX [IX_FK_ProvinceCity]
ON [dbo].[Cities]
    ([ProvinceId]);
GO

-- Creating foreign key on [StreetId] in table 'Buildings'
ALTER TABLE [dbo].[Buildings]
ADD CONSTRAINT [FK_StreetBuilding]
    FOREIGN KEY ([StreetId])
    REFERENCES [dbo].[Streets]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_StreetBuilding'
CREATE INDEX [IX_FK_StreetBuilding]
ON [dbo].[Buildings]
    ([StreetId]);
GO

-- Creating foreign key on [CountryId] in table 'Provinces'
ALTER TABLE [dbo].[Provinces]
ADD CONSTRAINT [FK_CountryProvince]
    FOREIGN KEY ([CountryId])
    REFERENCES [dbo].[Countries]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_CountryProvince'
CREATE INDEX [IX_FK_CountryProvince]
ON [dbo].[Provinces]
    ([CountryId]);
GO

-- Creating foreign key on [BuildingId] in table 'Clients'
ALTER TABLE [dbo].[Clients]
ADD CONSTRAINT [FK_ClientBuilding]
    FOREIGN KEY ([BuildingId])
    REFERENCES [dbo].[Buildings]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_ClientBuilding'
CREATE INDEX [IX_FK_ClientBuilding]
ON [dbo].[Clients]
    ([BuildingId]);
GO

-- Creating foreign key on [BuildingId] in table 'Conferences'
ALTER TABLE [dbo].[Conferences]
ADD CONSTRAINT [FK_ConferenceBuilding]
    FOREIGN KEY ([BuildingId])
    REFERENCES [dbo].[Buildings]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_ConferenceBuilding'
CREATE INDEX [IX_FK_ConferenceBuilding]
ON [dbo].[Conferences]
    ([BuildingId]);
GO

-- Creating foreign key on [ConferenceId] in table 'ConferenceDays'
ALTER TABLE [dbo].[ConferenceDays]
ADD CONSTRAINT [FK_ConferenceDayConference]
    FOREIGN KEY ([ConferenceId])
    REFERENCES [dbo].[Conferences]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_ConferenceDayConference'
CREATE INDEX [IX_FK_ConferenceDayConference]
ON [dbo].[ConferenceDays]
    ([ConferenceId]);
GO

-- Creating foreign key on [WorkshopId] in table 'WorkshopReservations'
ALTER TABLE [dbo].[WorkshopReservations]
ADD CONSTRAINT [FK_WorkshopReservationWorkshop]
    FOREIGN KEY ([WorkshopId])
    REFERENCES [dbo].[Workshops]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_WorkshopReservationWorkshop'
CREATE INDEX [IX_FK_WorkshopReservationWorkshop]
ON [dbo].[WorkshopReservations]
    ([WorkshopId]);
GO

-- Creating foreign key on [ClientId] in table 'Reservations'
ALTER TABLE [dbo].[Reservations]
ADD CONSTRAINT [FK_ReservationClient]
    FOREIGN KEY ([ClientId])
    REFERENCES [dbo].[Clients]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_ReservationClient'
CREATE INDEX [IX_FK_ReservationClient]
ON [dbo].[Reservations]
    ([ClientId]);
GO

-- Creating foreign key on [ConferenceId] in table 'Reservations'
ALTER TABLE [dbo].[Reservations]
ADD CONSTRAINT [FK_ConferenceReservation]
    FOREIGN KEY ([ConferenceId])
    REFERENCES [dbo].[Conferences]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_ConferenceReservation'
CREATE INDEX [IX_FK_ConferenceReservation]
ON [dbo].[Reservations]
    ([ConferenceId]);
GO

-- Creating foreign key on [IndividualClientId] in table 'ConferenceDays'
ALTER TABLE [dbo].[ConferenceDays]
ADD CONSTRAINT [FK_IndividualClientConferenceDay]
    FOREIGN KEY ([IndividualClientId])
    REFERENCES [dbo].[IndividualClients]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_IndividualClientConferenceDay'
CREATE INDEX [IX_FK_IndividualClientConferenceDay]
ON [dbo].[ConferenceDays]
    ([IndividualClientId]);
GO

-- Creating foreign key on [IndividualClientId] in table 'WorkshopReservations'
ALTER TABLE [dbo].[WorkshopReservations]
ADD CONSTRAINT [FK_IndividualClientWorkshopReservation]
    FOREIGN KEY ([IndividualClientId])
    REFERENCES [dbo].[IndividualClients]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_IndividualClientWorkshopReservation'
CREATE INDEX [IX_FK_IndividualClientWorkshopReservation]
ON [dbo].[WorkshopReservations]
    ([IndividualClientId]);
GO

-- Creating foreign key on [WorkshopPrice_Id] in table 'Workshops'
ALTER TABLE [dbo].[Workshops]
ADD CONSTRAINT [FK_WorkshopWorkshopPrice]
    FOREIGN KEY ([WorkshopPrice_Id])
    REFERENCES [dbo].[WorkshopPrices]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_WorkshopWorkshopPrice'
CREATE INDEX [IX_FK_WorkshopWorkshopPrice]
ON [dbo].[Workshops]
    ([WorkshopPrice_Id]);
GO

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------