﻿CREATE PROCEDURE [cfg].[UpdateFeedExecutionLog]
	(
	@batch_id int,
	@UpdateStatus nvarchar(50),
	@master_batch_id int,
	@ScheduleDefinition varchar(500)
	)
AS
BEGIN
	SET NOCOUNT ON;	
		BEGIN TRY

    	begin transaction
				
		UPDATE
			cfg.DataFeedExecutionLog
		SET
			[DataFeedStatus] = @UpdateStatus,
			[EndDateTime] = GETUTCDATE()
		WHERE
			batch_id = @batch_id;

		-- if it's a daily feed and master batch has started then we update this feed in the dependency table
		--if @ScheduleDefinition like '%daily%' and @master_batch_id > 0
		-- if it's a master batch has started then we update this feed in the dependency table
		if @master_batch_id > 0
			begin

				-- Getting STG schema object name to be matched
				declare @DataObjectChild varchar(100);
				select @DataObjectChild = concat(DestinationSchema, '.', DestinationEntity) from [cfg].[DataFeedStages] where DataStage = 'L1_SQL_STG' and DataFeedId = (select DataFeedId from [cfg].[DataFeedExecutionLog] where batch_id = @batch_id)

				-- if it's empty, throw an error				
				if @DataObjectChild is null throw 51000, '@DataObjectChild is empty.', 1; 
				
				-- otherwise update the dependency for this child feed				
				if (select count(*) from [cfg].[DataFeedDependencyExecutionLog] where master_batch_id = @master_batch_id and DataObjectChild = @DataObjectChild) > 0
				begin
					DECLARE	@return_value int
					execute @return_value = [cfg].[UpdateFeedDependencyExecutionLog] @master_batch_id, @batch_id, @DataObjectChild, @UpdateStatus;
					if @return_value <> 0 throw 52000, 'Error updating Dependency Execution.', 1; 				
				end
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