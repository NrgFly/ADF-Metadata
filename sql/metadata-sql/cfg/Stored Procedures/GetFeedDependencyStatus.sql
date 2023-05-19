CREATE PROCEDURE [cfg].[GetFeedDependencyStatus]
	(
	@master_batch_id int,
	@DataObjectParent nvarchar(200)
	)
AS
BEGIN
	SET NOCOUNT ON;	
	BEGIN TRY

    	begin transaction
		
		-- check if @master_batch_id value exists
		if not exists(select null from [cfg].[DataFeedDependencyExecutionLog] where master_batch_id = @master_batch_id) 
			throw 51000, 'Provided master_batch_id value does not exist.', 1; 
	
		-- check if @DataObjectParent value exists
		if not exists(select null from [cfg].[DataFeedDependencyExecutionLog] where master_batch_id = @master_batch_id and DataObjectParent = @DataObjectParent) 
			throw 52000, 'Provided DataObjectParent value does not exist.', 1; 

		-- Getting distinct status of Parent children
		declare @distinct_count int;
		SELECT @distinct_count = count(distinct FeedDependencyStatus) FROM cfg.DataFeedDependencyExecutionLog WHERE master_batch_id = @master_batch_id and DataObjectParent = @DataObjectParent;

		-- check if we're getting any result records
		if @distinct_count = 0 throw 53000, 'Output result is empty, check provided input parameters.', 1; 

		-- Showing the result
		SELECT master_batch_id = @master_batch_id
			 , DataObjectParent = @DataObjectParent
			 , FeedDependencyStatus = 
			   case 
				when @distinct_count = 1 then (SELECT distinct FeedDependencyStatus FROM cfg.DataFeedDependencyExecutionLog WHERE master_batch_id = @master_batch_id and DataObjectParent = @DataObjectParent)
				when @distinct_count > 1 
				     and exists (SELECT null FROM cfg.DataFeedDependencyExecutionLog WHERE master_batch_id = @master_batch_id and DataObjectParent = @DataObjectParent and FeedDependencyStatus = 'Failed')
					 then 'Failed: For some data objects'
				else 'In Progress'
			   end;
		
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