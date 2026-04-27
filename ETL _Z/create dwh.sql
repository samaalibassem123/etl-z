USE DWH;
GO

/* =========================================================
   1) Drop foreign keys first (avoid dependency errors)
========================================================= */
DECLARE @sql NVARCHAR(MAX) = '';

SELECT @sql += 'ALTER TABLE [' + SCHEMA_NAME(t.schema_id) + '].[' + t.name + '] DROP CONSTRAINT [' + fk.name + '];' + CHAR(10)
FROM sys.foreign_keys fk
JOIN sys.tables t ON fk.parent_object_id = t.object_id
WHERE t.name IN (
    'FactCertification',
    'DimProjet',
    'DimSpeculation',
    'DimActivite',
    'DimGouvernorat',
    'DimOrganisme'
);

IF (@sql <> '')
    EXEC sp_executesql @sql;
GO

/* =========================================================
   2) Drop tables (dbo only)
========================================================= */
DROP TABLE IF EXISTS FactCertification;
DROP TABLE IF EXISTS DimProjet;
DROP TABLE IF EXISTS DimSpeculation;
DROP TABLE IF EXISTS DimActivite;
DROP TABLE IF EXISTS DimGouvernorat;
DROP TABLE IF EXISTS DimOrganisme;
GO

/* =========================================================
   3) Dimensions
========================================================= */
CREATE TABLE DimOrganisme
(
    OrganismeKey   INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    OrganismeName  NVARCHAR(100) NOT NULL,
    LoadDtm        DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT UQ_DimOrganisme UNIQUE (OrganismeName)
);
GO

CREATE TABLE DimGouvernorat
(
    GouvernoratKey   INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    GouvernoratName  NVARCHAR(100) NOT NULL,
    LoadDtm          DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT UQ_DimGouvernorat UNIQUE (GouvernoratName)
);
GO

CREATE TABLE DimActivite
(
    ActiviteKey   INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ActiviteName  NVARCHAR(255) NOT NULL,
    LoadDtm       DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT UQ_DimActivite UNIQUE (ActiviteName)
);
GO

CREATE TABLE DimSpeculation
(
    SpeculationKey   INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    SpeculationName  NVARCHAR(MAX) NOT NULL,
    LoadDtm          DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

CREATE TABLE DimProjet
(
    ProjetKey        INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    OrganismeKey     INT NOT NULL,
    Code             NVARCHAR(100) NOT NULL,
    ProjetName       NVARCHAR(255) NOT NULL,
    NomResponsable   NVARCHAR(255) NULL,
    ContactMail      NVARCHAR(255) NULL,
    Telephone1       NVARCHAR(100) NULL,
    Telephone2       NVARCHAR(100) NULL,
    Fax              NVARCHAR(100) NULL,
    LoadDtm          DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_DimProjet_DimOrganisme
        FOREIGN KEY (OrganismeKey) REFERENCES DimOrganisme(OrganismeKey),

    CONSTRAINT UQ_DimProjet UNIQUE (OrganismeKey, Code)
);
GO

/* =========================================================
   4) Fact table
========================================================= */
CREATE TABLE FactCertification
(
    FactCertificationKey  BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,

    OrganismeKey          INT NULL,
    ProjetKey             INT NULL,
    GouvernoratKey        INT NULL,
    ActiviteKey           INT NULL,
    SpeculationKey        INT NULL,

    Superficie            DECIMAL(18,2) NULL,
    NombreOperateurs      INT NULL,
    Estimation            DECIMAL(18,2) NULL,

    Producteur            INT NULL,
    Ceuilleur             INT NULL,
    Transfo               INT NULL,
    Exporter              INT NULL,
    Aquaculteur           INT NULL,

    LoadDtm               DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_FactCertification_DimOrganisme
        FOREIGN KEY (OrganismeKey) REFERENCES DimOrganisme(OrganismeKey),

    CONSTRAINT FK_FactCertification_DimProjet
        FOREIGN KEY (ProjetKey) REFERENCES DimProjet(ProjetKey),

    CONSTRAINT FK_FactCertification_DimGouvernorat
        FOREIGN KEY (GouvernoratKey) REFERENCES DimGouvernorat(GouvernoratKey),

    CONSTRAINT FK_FactCertification_DimActivite
        FOREIGN KEY (ActiviteKey) REFERENCES DimActivite(ActiviteKey),

    CONSTRAINT FK_FactCertification_DimSpeculation
        FOREIGN KEY (SpeculationKey) REFERENCES DimSpeculation(SpeculationKey)
);
GO

/* =========================================================
   5) Indexes (safe creation)
========================================================= */
CREATE INDEX IX_FactCertification_OrganismeKey   ON FactCertification(OrganismeKey);
CREATE INDEX IX_FactCertification_ProjetKey      ON FactCertification(ProjetKey);
CREATE INDEX IX_FactCertification_GouvernoratKey ON FactCertification(GouvernoratKey);
CREATE INDEX IX_FactCertification_ActiviteKey    ON FactCertification(ActiviteKey);
CREATE INDEX IX_FactCertification_SpeculationKey ON FactCertification(SpeculationKey);
GO