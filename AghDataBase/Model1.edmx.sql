
-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, 2012 and Azure
-- --------------------------------------------------
-- Date Created: 03/16/2019 18:51:20
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

-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

-- Creating table 'Clients'
CREATE TABLE [dbo].[Clients] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Telephone] nvarchar(max)  NOT NULL
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
    [Date] time  NOT NULL
);
GO

-- Creating table 'ConferencePrices'
CREATE TABLE [dbo].[ConferencePrices] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [ConferenceId] int  NOT NULL
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

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------