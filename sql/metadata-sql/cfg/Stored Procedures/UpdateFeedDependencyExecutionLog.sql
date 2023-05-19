

CREATE PROCEDURE [cfg].[UpdateFeedDependencyExecutionLog]
	(
	@master_batch_id int,
	@feed_batch_id int,
	@DataObjectChild nvarchar(200),
	@FeedDependencyStatus nvarchar(50)
	)
AS
BEGIN
	SET NOCOUNT ON;	
	BEGIN TRY
		
		begin transaction

		declare @Saved_FeedDependencyStatus varchar(20);		
		declare @error_message varchar(200);

		if not exists(select null from [cfg].[DataFeedDependencyExecutionLog] where master_batch_id = @master_batch_id) 
		throw 51000, 'master_batch_id value does not exist.', 1; 
	
		if not exists(select null from [cfg].[DataFeedDependencyExecutionLog] where master_batch_id = @master_batch_id and DataObjectChild = @DataObjectChild) 
		throw 52000, 'DataObjectChild value does not exist.', 1; 		

		-- Checking the existing FeedDependencyStatus from the log table
		select top 1 @Saved_FeedDependencyStatus = FeedDependencyStatus 
		 from cfg.DataFeedDependencyExecutionLog 
		WHERE master_batch_id = @master_batch_id 
		  and DataObjectChild = @DataObjectChild;

		if left(@DataObjectChild,3) = 'edw' and @Saved_FeedDependencyStatus = @FeedDependencyStatus and @Saved_FeedDependencyStatus = 'Started'
		/*
			if DataObjectChild is EDW schema Fact or Dim table
			if data log entry alredy has 'Started' status
			if requested update status is 'Started' too
			then fail and don't start execution of the data object processing stored procedure
		*/
		begin
			set @error_message = @DataObjectChild + ' EDW object processing has already started.';
			throw 53000, @error_message, 1;
		end
		
		if left(@DataObjectChild,3) = 'edw' and @FeedDependencyStatus = 'Started' and @Saved_FeedDependencyStatus <> 'Start Pending'
		/*
			if DataObjectChild is EDW schema Fact or Dim table
			if data log entry alredy has 'Started' status
			if requested update status is 'Started' too but the saved status doesn't equal 'Start Pending'
			then fail and don't start execution of the data object processing stored procedure
		*/
		begin
			set @error_message = @DataObjectChild + ' EDW object processing has already finished.';
			throw 53000, @error_message, 1;
		end

		-- If 'Started'
		if @FeedDependencyStatus = 'Started'
		BEGIN		
			UPDATE
				cfg.DataFeedDependencyExecutionLog
			SET
				  FeedDependencyStatus = @FeedDependencyStatus
				, feed_batch_id = @feed_batch_id
				, StartDateTime = getutcdate()				
			WHERE master_batch_id = @master_batch_id 
				and DataObjectChild = @DataObjectChild;
		END
		ELSE
		BEGIN -- Othe Status values
			UPDATE
				cfg.DataFeedDependencyExecutionLog
			SET
				  FeedDependencyStatus = @FeedDependencyStatus
				, feed_batch_id = @feed_batch_id
				, EndDateTime = getutcdate()
			WHERE master_batch_id = @master_batch_id 
				and DataObjectChild = @DataObjectChild;
		END

		-- Successfull result		
		
		commit transaction
		
		-- If Update step was done for Dim or Fact table, then Err_Number = 0, OK result
		if left(@DataObjectChild,3) = 'edw'
		begin 
			SELECT 0 AS ERR_NUMBER;
		end

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
END