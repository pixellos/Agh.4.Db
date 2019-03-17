
-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, 2012 and Azure
-- --------------------------------------------------
-- Date Created: 03/17/2019 15:23:36
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
IF OBJECT_ID(N'[dbo].[FK_WorkshopPriceWorkshop]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[WorkshopPrices] DROP CONSTRAINT [FK_WorkshopPriceWorkshop];
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
    [Id] int IDENTITY(1,1) NOT NULL
);
GO

-- Creating table 'WorkshopPrices'
CREATE TABLE [dbo].[WorkshopPrices] (
    [Id] int IDENTITY(1,1) NOT NULL
);
GO

-- Creating table 'Conferences'
CREATE TABLE [dbo].[Conferences] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Name] nvarchar(max)  NOT NULL,
    [Date] time  NOT NULL,
    [BuildingId] int  NOT NULL
);
GO

-- Creating table 'ConferencePrices'
CREATE TABLE [dbo].[ConferencePrices] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [ConferenceId] int  NOT NULL
);
GO

-- Creating table 'Students1'
CREATE TABLE [dbo].[Students1] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Discount] nvarchar(max)  NOT NULL,
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
    [ConferenceId] int  NOT NULL
);
GO

-- Creating table 'Countries'
CREATE TABLE [dbo].[Countries] (
    [Id] int IDENTITY(1,1) NOT NULL
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

-- Creating primary key on [Id] in table 'Students1'
ALTER TABLE [dbo].[Students1]
ADD CONSTRAINT [PK_Students1]
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

-- Creating foreign key on [Id] in table 'Students1'
ALTER TABLE [dbo].[Students1]
ADD CONSTRAINT [FK_StudentIndividualClient]
    FOREIGN KEY ([Id])
    REFERENCES [dbo].[IndividualClients]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating foreign key on [Id] in table 'WorkshopPrices'
ALTER TABLE [dbo].[WorkshopPrices]
ADD CONSTRAINT [FK_WorkshopPriceWorkshop]
    FOREIGN KEY ([Id])
    REFERENCES [dbo].[Workshops]
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

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------