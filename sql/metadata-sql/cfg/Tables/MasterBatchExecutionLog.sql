CREATE TABLE [cfg].[MasterBatchExecutionLog] (
    [master_batch_id]   INT            IDENTITY (1, 1) NOT NULL,
    [master_batch_ts]   VARCHAR (100)  NOT NULL,
    [StartDateTime]     DATETIME       CONSTRAINT [DF_MasterBatchExecutionLog_StartDateTime] DEFAULT (getutcdate()) NOT NULL,
    [EndDateTime]       DATETIME       NULL,
    [MasterBatchStatus] NVARCHAR (200) CONSTRAINT [DF_MasterBatchExecutionLog_MasterBatchStatus] DEFAULT (N'Started') NOT NULL,
    [master_batch_type] VARCHAR (50)   NULL,
    CONSTRAINT [PK_MasterBatchExecutionLog] PRIMARY KEY CLUSTERED ([master_batch_id] ASC)
);

