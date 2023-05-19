CREATE TABLE [cfg].[DataFeedDependencyExecutionLog_History] (
    [feed_dependency_log_id] INT            NOT NULL,
    [master_batch_id]        INT            NOT NULL,
    [master_batch_ts]        VARCHAR (100)  NOT NULL,
    [feed_batch_id]          INT            NULL,
    [DataObjectParent]       NVARCHAR (200) NOT NULL,
    [DataObjectChild]        NVARCHAR (200) NOT NULL,
    [StartDateTime]          DATETIME       NULL,
    [EndDateTime]            DATETIME       NULL,
    [FeedDependencyStatus]   NVARCHAR (200) NOT NULL,
    [ValidFrom]              DATETIME2 (7)  NOT NULL,
    [ValidTo]                DATETIME2 (7)  NOT NULL
);


GO
CREATE CLUSTERED INDEX [ix_DataFeedDependencyExecutionLog_History]
    ON [cfg].[DataFeedDependencyExecutionLog_History]([ValidTo] ASC, [ValidFrom] ASC);

