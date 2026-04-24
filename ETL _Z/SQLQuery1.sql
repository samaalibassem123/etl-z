use STAGING
go
-- 1. Staging table for Kiwa
DROP TABLE IF EXISTS [STAGING].dbo.[STG_Kiwa];
GO

CREATE TABLE [STG_Kiwa] (
    [Organisme] NVARCHAR(100),
    [Code] NVARCHAR(100),
    [Projet] NVARCHAR(255),
    [Gouvernorat] NVARCHAR(100),
    [Nom reponsable] NVARCHAR(255),
    [Contact mail] NVARCHAR(255),
    [Telephone1] NVARCHAR(100),
    [Telephone2] NVARCHAR(100),
    [Fax] NVARCHAR(100),
    [Activité] NVARCHAR(255),
    [Spéculation]  NTEXT,
    [Superficie] NVARCHAR(255),
    [Nombre des opérateurs] INT,
    [Estimation] NVARCHAR(MAX),
    [Producteur] INT,
    [Ceuilleur] INT,       -- Matches Kiwa file spelling
    [Transfo] INT,
    [Exporter] INT,
    [aquaculteur] INT
);
GO

-- 2. Staging table for CCPB
DROP TABLE IF EXISTS [STG_CCPB];
GO

CREATE TABLE [STG_CCPB] (
    [Organisme] NVARCHAR(100),
    [Code] NVARCHAR(100),
    [Projet] NVARCHAR(255),
    [Gouvernorat] NVARCHAR(100),
    [Nom reponsable] NVARCHAR(255),
    [Contact mail] NVARCHAR(255),
    [Telephone1] NVARCHAR(100),
    [Telephone2] NVARCHAR(100),
    [Fax] NVARCHAR(100),
    [Activité] NVARCHAR(255),
    [Spéculation] NTEXT,
    [Superficie] NVARCHAR(255),
    [Nombre des opérateurs] INT,
    [Estimation] NVARCHAR(MAX),
    [Producteur] INT,
    [Ceuilleir] INT,       -- Matches CCPB file spelling
    [Transfo] INT,
    [Exporter] INT,
    [aquacultuer] INT      -- Matches CCPB file spelling
);
GO

-- 3. Staging table for Ecocert
DROP TABLE IF EXISTS [STG_Ecocert];
GO

CREATE TABLE [STG_Ecocert] (
    [Organisme] NVARCHAR(100),
    [Code] NVARCHAR(100),
    [Projet] NVARCHAR(255),
    [Gouvernorat] NVARCHAR(100),
    [Nom reponsable] NVARCHAR(255),
    [Contact mail] NVARCHAR(255),
    [Telephone1] NVARCHAR(100),
    [Telephone2] NVARCHAR(100),
    [Fax] NVARCHAR(100),
    [Activité] NVARCHAR(255),
    [Spéculation] NTEXT,
    [Superficie] NVARCHAR(255),
    [Nombre des opérateurs] INT,
    [Estimation] NVARCHAR(MAX),
    [Producteur] INT,
    [Ceuilleir] INT,       -- Matches Ecocert file spelling
    [Transfo] INT,
    [Exporter] INT,
    [aquaculteur] INT
);
GO