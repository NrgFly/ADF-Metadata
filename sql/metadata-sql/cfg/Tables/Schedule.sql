CREATE TABLE [cfg].[Schedule] (
    [ScheduleId]         INT            NOT NULL,
    [DataFeedId]         INT            NOT NULL,
    [ScheduleDefinition] NVARCHAR (MAX) NOT NULL,
    [Enabled]            BIT            CONSTRAINT [DF_Scheduler_Enabled] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_Schedule] PRIMARY KEY CLUSTERED ([ScheduleId] ASC)
);

