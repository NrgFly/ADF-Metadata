CREATE TABLE [cfg].[DataFeedStagesExecutionLog] (
    [feed_stage_log_id] INT            IDENTITY (1, 1) NOT NULL,
    [batch_id]          INT            NOT NULL,
    [batch_ts]          NVARCHAR (100) NOT NULL,
    [DataFeedId]        INT            NOT NULL,
    [DataStage]         NVARCHAR (20)  NOT NULL,
    [StartDateTime]     DATETIME       CONSTRAINT [DF_BatchExecutionLog_StartDateTime] DEFAULT (getutcdate()) NOT NULL,
    [EndDateTime]       DATETIME       NULL,
    [FeedStageStatus]   NVARCHAR (50)  NOT NULL,
    [RowsRead]          INT            NULL,
    [RowsCopied]        INT            NULL,
    [RowsSkipped]       AS             ([RowsRead]-[RowsCopied]),
    [PipelineName]      NVARCHAR (100) NOT NULL,
    [PipelineRunID]     NVARCHAR (100) NOT NULL,
    CONSTRAINT [PK_BatchExecutionLog] PRIMARY KEY CLUSTERED ([feed_stage_log_id] ASC)
);

