
-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, 2012 and Azure
-- --------------------------------------------------
-- Date Created: 03/16/2019 17:46:46
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


-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------


-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

-- Creating table 'Clients'
CREATE TABLE [dbo].[Clients] (
    [Id] int IDENTITY(1,1) NOT NULL
);
GO

-- Creating table 'CorporateClients'
CREATE TABLE [dbo].[CorporateClients] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [CorporateClientEmployeId] int  NOT NULL,
    [Client_Id] int  NOT NULL
);
GO

-- Creating table 'IndividualClients'
CREATE TABLE [dbo].[IndividualClients] (
    [Id] int  NOT NULL,
    [Client_Id] int  NOT NULL,
    [CorporateClientEmploye_Id] int  NOT NULL
);
GO

-- Creating table 'CorporateClientEmployes'
CREATE TABLE [dbo].[CorporateClientEmployes] (
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

-- Creating foreign key on [CorporateClientEmployeId] in table 'CorporateClients'
ALTER TABLE [dbo].[CorporateClients]
ADD CONSTRAINT [FK_CorporateClientEmployeCorporateClient]
    FOREIGN KEY ([CorporateClientEmployeId])
    REFERENCES [dbo].[CorporateClientEmployes]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_CorporateClientEmployeCorporateClient'
CREATE INDEX [IX_FK_CorporateClientEmployeCorporateClient]
ON [dbo].[CorporateClients]
    ([CorporateClientEmployeId]);
GO

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------