
CREATE PROCEDURE [cfg].[UpdateFeedStageExecutionLog]
	(
	@feed_stage_log_id int,
	@UpdateStatus nvarchar(50),
	@RowsRead int = null,
	@RowsCopied int = null
	)
AS
BEGIN
	SET NOCOUNT ON;	
	BEGIN TRY

    	begin transaction
		
		UPDATE
			cfg.DataFeedStagesExecutionLog
		SET
			FeedStageStatus = @UpdateStatus,
			EndDateTime = GETUTCDATE(),
			RowsRead = @RowsRead,
			RowsCopied = @RowsCopied
		WHERE
			feed_stage_log_id = @feed_stage_log_id;


		-- Feed stage = Failed then fail the Feed execution as well
		if (@UpdateStatus = 'Failed')
		begin

			-- Getting feed batch id
				declare @feed_batch_id int;
				select @feed_batch_id = batch_id from cfg.DataFeedStagesExecutionLog where feed_stage_log_id = @feed_stage_log_id
				print @feed_batch_id

			-- Getting master batch id (if the feed_id is part of the daily master batch)
				declare @master_batch_id int;
				select @master_batch_id = master_batch_id from cfg.DataFeedDependencyExecutionLog where feed_batch_id = @feed_batch_id
				print @master_batch_id

			-- Mark Master Batch as Complete
			execute [cfg].[UpdateFeedExecutionLog] @feed_batch_id, @UpdateStatus, @master_batch_id, '{"frequency":"daily","hour":1,"minute":0}'
		end
		
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