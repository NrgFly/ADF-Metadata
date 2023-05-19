CREATE TABLE [stg].[SalesOrderDetail] (
    [SalesOrderID]       INT              NOT NULL,
    [SalesOrderDetailID] INT              NOT NULL,
    [OrderQty]           SMALLINT         NOT NULL,
    [ProductID]          INT              NOT NULL,
    [UnitPrice]          MONEY            NOT NULL,
    [UnitPriceDiscount]  MONEY            NOT NULL,
    [LineTotal]          NUMERIC (38, 6)  NOT NULL,
    [rowguid]            UNIQUEIDENTIFIER NOT NULL,
    [ModifiedDate]       DATETIME         NOT NULL,
    [source_system]      VARCHAR (20)     NULL,
    [batch_id]           INT              NULL,
    [batch_ts]           VARCHAR (14)     NULL
);

