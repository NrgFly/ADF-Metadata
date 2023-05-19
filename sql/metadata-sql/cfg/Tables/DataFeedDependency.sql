CREATE TABLE [cfg].[DataFeedDependency] (
    [DataFeedDependencyId] INT            NOT NULL,
    [DataObject]           NVARCHAR (200) NOT NULL,
    [DataObjectDependency] NVARCHAR (MAX) NOT NULL,
    [ProcessingRoutine]    NVARCHAR (200) CONSTRAINT [DF_DataFeedDependency_ProcessingRoutine] DEFAULT ('N/A') NOT NULL,
    [Enabled]              BIT            CONSTRAINT [DF_DataFeedDependency_Enabled] DEFAULT ((1)) NOT NULL,
    [master_batch_type]    VARCHAR (50)   NULL,
    CONSTRAINT [PK_DataFeedDependency] PRIMARY KEY CLUSTERED ([DataFeedDependencyId] ASC)
);

