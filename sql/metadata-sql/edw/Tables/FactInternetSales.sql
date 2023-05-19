﻿CREATE TABLE [edw].[FactInternetSales] (
    [ProductKey]            INT           NOT NULL,
    [OrderDateKey]          INT           NOT NULL,
    [DueDateKey]            INT           NOT NULL,
    [ShipDateKey]           INT           NOT NULL,
    [CustomerKey]           INT           NOT NULL,
    [SalesOrderNumber]      NVARCHAR (20) NOT NULL,
    [SalesOrderLineNumber]  TINYINT       NOT NULL,
    [RevisionNumber]        TINYINT       NOT NULL,
    [OrderQuantity]         SMALLINT      NOT NULL,
    [UnitPrice]             MONEY         NOT NULL,
    [ExtendedAmount]        MONEY         NOT NULL,
    [UnitPriceDiscountPct]  FLOAT (53)    NOT NULL,
    [DiscountAmount]        FLOAT (53)    NOT NULL,
    [ProductStandardCost]   MONEY         NOT NULL,
    [TotalProductCost]      MONEY         NOT NULL,
    [SalesAmount]           MONEY         NOT NULL,
    [TaxAmt]                MONEY         NOT NULL,
    [Freight]               MONEY         NOT NULL,
    [CarrierTrackingNumber] NVARCHAR (25) NULL,
    [CustomerPONumber]      NVARCHAR (25) NULL,
    [OrderDate]             DATETIME      NULL,
    [DueDate]               DATETIME      NULL,
    [ShipDate]              DATETIME      NULL,
    [batch_ts]              VARCHAR (14)  NULL,
    [source_system]         VARCHAR (20)  NULL,
    [batch_id]              INT           NULL,
    CONSTRAINT [PK_FactInternetSales_SalesOrderNumber_SalesOrderLineNumber] PRIMARY KEY CLUSTERED ([SalesOrderNumber] ASC, [SalesOrderLineNumber] ASC),
    CONSTRAINT [FK_FactInternetSales_DimCustomer] FOREIGN KEY ([CustomerKey]) REFERENCES [edw].[DimCustomer] ([CustomerKey]),
    CONSTRAINT [FK_FactInternetSales_DimProduct] FOREIGN KEY ([ProductKey]) REFERENCES [edw].[DimProduct] ([ProductKey])
);
