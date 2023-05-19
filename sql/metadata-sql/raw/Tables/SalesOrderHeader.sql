﻿CREATE TABLE [raw].[SalesOrderHeader] (
    [SalesOrderID]           INT              NOT NULL,
    [RevisionNumber]         TINYINT          NOT NULL,
    [OrderDate]              DATETIME         NOT NULL,
    [DueDate]                DATETIME         NOT NULL,
    [ShipDate]               DATETIME         NULL,
    [Status]                 TINYINT          NOT NULL,
    [OnlineOrderFlag]        BIT              NOT NULL,
    [SalesOrderNumber]       NVARCHAR (25)    NOT NULL,
    [PurchaseOrderNumber]    NVARCHAR (25)    NULL,
    [AccountNumber]          NVARCHAR (15)    NULL,
    [CustomerID]             INT              NOT NULL,
    [ShipMethod]             NVARCHAR (50)    NOT NULL,
    [CreditCardApprovalCode] VARCHAR (15)     NULL,
    [SubTotal]               MONEY            NOT NULL,
    [TaxAmt]                 MONEY            NOT NULL,
    [Freight]                MONEY            NOT NULL,
    [TotalDue]               MONEY            NOT NULL,
    [Comment]                NVARCHAR (MAX)   NULL,
    [rowguid]                UNIQUEIDENTIFIER NOT NULL,
    [ModifiedDate]           DATETIME         NOT NULL,
    [source_system]          VARCHAR (20)     NULL,
    [batch_id]               INT              NULL,
    [batch_ts]               VARCHAR (14)     NULL
);

