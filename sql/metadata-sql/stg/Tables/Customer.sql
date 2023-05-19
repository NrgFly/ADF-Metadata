CREATE TABLE [stg].[Customer] (
    [CustomerID]    INT              NOT NULL,
    [NameStyle]     BIT              NOT NULL,
    [Title]         NVARCHAR (8)     NULL,
    [FirstName]     NVARCHAR (50)    NOT NULL,
    [MiddleName]    NVARCHAR (50)    NULL,
    [LastName]      NVARCHAR (50)    NOT NULL,
    [Suffix]        NVARCHAR (10)    NULL,
    [CompanyName]   NVARCHAR (128)   NULL,
    [SalesPerson]   NVARCHAR (256)   NULL,
    [EmailAddress]  NVARCHAR (50)    NULL,
    [Phone]         NVARCHAR (25)    NULL,
    [PasswordHash]  VARCHAR (128)    NOT NULL,
    [PasswordSalt]  VARCHAR (10)     NOT NULL,
    [rowguid]       UNIQUEIDENTIFIER NOT NULL,
    [ModifiedDate]  DATETIME2 (7)    NOT NULL,
    [source_system] VARCHAR (20)     NULL,
    [batch_id]      INT              NULL,
    [batch_ts]      VARCHAR (14)     NULL
);

