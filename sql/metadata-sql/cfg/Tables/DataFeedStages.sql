CREATE TABLE [cfg].[DataFeedStages] (
    [DataFeedStageId]     INT            NOT NULL,
    [DataFeedId]          INT            NULL,
    [DataStage]           NVARCHAR (20)  NOT NULL,
    [SourceSchema]        NVARCHAR (20)  NULL,
    [SourceEntity]        NVARCHAR (200) NOT NULL,
    [DestinationSchema]   NVARCHAR (20)  NULL,
    [DestinationEntity]   NVARCHAR (200) NOT NULL,
    [PipelineName]        NVARCHAR (200) NULL,
    [PipelineParameteres] NVARCHAR (MAX) NULL,
    [Enabled]             BIT            CONSTRAINT [DF_DataLoadContro_Enabled] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_DataLoadControl] PRIMARY KEY CLUSTERED ([DataFeedStageId] ASC)
);

