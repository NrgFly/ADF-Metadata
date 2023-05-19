CREATE TABLE [cfg].[DataFeedExecutionLog] (
    [batch_id]       INT            IDENTITY (1, 1) NOT NULL,
    [batch_ts]       VARCHAR (100)  NOT NULL,
    [DataFeedId]     INT            NOT NULL,
    [ScheduleId]     INT            NOT NULL,
    [StartDateTime]  DATETIME       CONSTRAINT [DF_DataFeedExecutionLog_StartDateTime] DEFAULT (getutcdate()) NOT NULL,
    [EndDateTime]    DATETIME       NULL,
    [DataFeedStatus] NVARCHAR (200) NOT NULL,
    CONSTRAINT [PK_DataFeedExecutionLog] PRIMARY KEY CLUSTERED ([batch_id] ASC)
);

