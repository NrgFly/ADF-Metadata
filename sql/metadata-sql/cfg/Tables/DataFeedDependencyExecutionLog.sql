CREATE TABLE [cfg].[DataFeedDependencyExecutionLog] (
    [feed_dependency_log_id] INT                                         IDENTITY (1, 1) NOT NULL,
    [master_batch_id]        INT                                         NOT NULL,
    [master_batch_ts]        VARCHAR (100)                               NOT NULL,
    [feed_batch_id]          INT                                         NULL,
    [DataObjectParent]       NVARCHAR (200)                              NOT NULL,
    [DataObjectChild]        NVARCHAR (200)                              NOT NULL,
    [StartDateTime]          DATETIME                                    NULL,
    [EndDateTime]            DATETIME                                    NULL,
    [FeedDependencyStatus]   NVARCHAR (200)                              CONSTRAINT [DF_DataFeedDependencyExecutionLog_DataDependencyStatus] DEFAULT (N'Start Pending') NOT NULL,
    [ValidFrom]              DATETIME2 (7) GENERATED ALWAYS AS ROW START CONSTRAINT [DF_InsurancePolicy_ValidFrom] DEFAULT (sysutcdatetime()) NOT NULL,
    [ValidTo]                DATETIME2 (7) GENERATED ALWAYS AS ROW END   CONSTRAINT [DF_InsurancePolicy_ValidTo] DEFAULT (CONVERT([datetime2],'9999-12-31 23:59:59.9999999')) NOT NULL,
    CONSTRAINT [PK_DataFeedDependencyExecutionLog] PRIMARY KEY CLUSTERED ([feed_dependency_log_id] ASC),
    PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[cfg].[DataFeedDependencyExecutionLog_History], DATA_CONSISTENCY_CHECK=ON));


GO

CREATE TRIGGER [cfg].[trg_update_DataFeedDependencyExecutionLog]
   ON  [cfg].[DataFeedDependencyExecutionLog]
   AFTER UPDATE
AS 
BEGIN
	-- Update Master Batch Status column
	declare @FeedDependencyStatus varchar(20);
	declare @master_batch_id int;

	-- Getting Dependency record Status and its Master Batch ID
	select top 1 @FeedDependencyStatus = FeedDependencyStatus, @master_batch_id = master_batch_id from inserted;  
	
	-- check if the master batch is complete and good
	if (select count(*) as row_count from [cfg].[DataFeedDependencyExecutionLog] where master_batch_id = @master_batch_id and FeedDependencyStatus <> 'Success') = 0
	begin
		-- Mark Master Batch as Complete
		execute [cfg].[UpdateMasterBatch] @master_batch_id, 'Success'
	end

	-- check if a depency object (feed or edw table) failed, then fail the Master Batch
	if (@FeedDependencyStatus = 'Failed')
	begin
		-- Mark Master Batch as Complete
		execute [cfg].[UpdateMasterBatch] @master_batch_id, 'Failed'
	end
END