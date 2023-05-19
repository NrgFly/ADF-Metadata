CREATE TABLE [cfg].[DataFeed] (
    [DataFeedId]          INT            NOT NULL,
    [DataFeedName]        NVARCHAR (200) NOT NULL,
    [DataFeedDescription] NVARCHAR (50)  NULL,
    [SourceSystem]        NVARCHAR (50)  NULL,
    [DataFeedType]        NVARCHAR (50)  NULL,
    [TimestampColumn]     VARCHAR (50)   NULL,
    [TimestampValue]      DATETIME2 (7)  NULL,
    [Enabled]             BIT            CONSTRAINT [DF_DataFeed_Enabled] DEFAULT ((1)) NOT NULL,
    [CustomScript]        NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_DataFeed] PRIMARY KEY CLUSTERED ([DataFeedId] ASC)
);

