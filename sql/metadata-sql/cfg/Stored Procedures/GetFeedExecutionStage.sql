CREATE PROCEDURE [cfg].[GetFeedExecutionStage]
	(
	@DataFeedId int,
	@batch_id int,
	@DataStage varchar(20)
	)
AS
BEGIN
	SET NOCOUNT ON;
	
		BEGIN TRY

	    begin transaction
		
		-- Pull Data Feed Stage execution details
		select [feed_stage_log_id], [batch_id], [batch_ts], [DataFeedId], [DataStage], [StartDateTime], [EndDateTime], [FeedStageStatus], [RowsRead], [RowsCopied], [RowsSkipped], [PipelineName], [PipelineRunID] 
		from [cfg].[DataFeedStagesExecutionLog]
		where DataFeedId = @DataFeedId
		  and batch_id = @batch_id
		  and DataStage = @DataStage;

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