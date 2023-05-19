
CREATE PROCEDURE [cfg].[CreateFeedStageExecution]
	(
	@batch_id int,
	@batch_ts varchar(100),
	@DataFeedId int,
	@DataStage nvarchar(20),
	@PipelineName nvarchar(100),
	@PipelineRunID nvarchar(100)
	)
AS
BEGIN
	SET NOCOUNT ON;
	
		BEGIN TRY

    	begin transaction
			
			INSERT INTO cfg.DataFeedStagesExecutionLog
				(
				  batch_id
				, batch_ts
				, DataFeedId
				, DataStage
				, FeedStageStatus
				, PipelineName
				, PipelineRunID
				)
			SELECT
				@batch_id,
				@batch_ts,
				@DataFeedId,
				@DataStage,
				'Started',				
				@PipelineName,
				@PipelineRunID			

			SELECT
				@@IDENTITY AS feed_stage_log_id;
			
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