

CREATE PROCEDURE [cfg].[CreateMasterBatch]
	(
		@master_batch_ts varchar(100),
		@master_batch_type varchar(50)
	)
AS
BEGIN
	SET NOCOUNT ON;
	
		BEGIN TRY

	    begin transaction
			
			-- Check if a record with the same @master_batch_ts alredy exists 
			declare @duplicate_master_batch_id int;
			declare @retired_status varchar(20) = 'Retired';
			select @duplicate_master_batch_id = master_batch_id from cfg.MasterBatchExecutionLog where master_batch_ts = @master_batch_ts and MasterBatchStatus <> @retired_status;
			
			-- Then Retire [cfg].[MasterBatchExecutionLog] and [cfg].[DataFeedDependencyExecutionLog] table records for this @master_batch_ts
			if @duplicate_master_batch_id is not null 
			begin 
				execute [cfg].[UpdateMasterBatch] @duplicate_master_batch_id, @retired_status;
				update [cfg].[DataFeedDependencyExecutionLog] set [FeedDependencyStatus] = @retired_status where master_batch_id = @duplicate_master_batch_id;
			end;

			-- Add a new record
			INSERT INTO cfg.MasterBatchExecutionLog
				(
				master_batch_ts, 				
				MasterBatchStatus,
				master_batch_type
				)
			SELECT
				@master_batch_ts,				
				'Started',
				@master_batch_type

			SELECT @@IDENTITY AS master_batch_id, @master_batch_ts as batch_ts, @master_batch_type as master_batch_type;

		commit transaction

		END TRY

	BEGIN CATCH
		-- Output few key error statistics in the case of exception or termination

		rollback transaction;
		SELECT
			ERROR_NUMBER() AS ERR_NUMBER,
			ERROR_STATE() AS ERR_STATE,
			ERROR_LINE() AS ERR_LINE,
			ERROR_PROCEDURE() AS ERR_PROCEDURE,
			ERROR_MESSAGE() AS ERR_MESSAGE;

	END CATCH
END;