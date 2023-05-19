

CREATE PROCEDURE [cfg].[CreateFeedDependencyExecution]
	(
	@master_batch_id int,
	@master_batch_ts varchar(100), 
	@master_batch_type varchar(50)
	)
AS
BEGIN
	SET NOCOUNT ON;
	
		BEGIN TRY

    	begin transaction
			
			INSERT INTO cfg.DataFeedDependencyExecutionLog
				(
				  master_batch_id
				, master_batch_ts
				, DataObjectParent
				, DataObjectChild
				)
			SELECT -- Transpose cfg.DataFeedDependency.DataObjectDependency into multiple rows
				  @master_batch_id
				, @master_batch_ts
				, DataObjectParent = dfd.DataObject
				, DataObjectChild = replace(replace(trim(value), char(10), ''), char(13), '') -- STRING_SPLIT table-valued function result value
				FROM [cfg].[DataFeedDependency] dfd
				CROSS APPLY STRING_SPLIT(dfd.DataObjectDependency, ',') -- Transpose String to Column
				where dfd.Enabled = 1
				  and dfd.master_batch_type = @master_batch_type
			UNION 
			SELECT -- Add Dims and Facts as data "feeds" too
				  @master_batch_id
				, @master_batch_ts
				, DataObjectParent = dfd.DataObject
				, DataObjectChild  = dfd.DataObject
				FROM [cfg].[DataFeedDependency] dfd
				where dfd.Enabled = 1
				  and dfd.master_batch_type = @master_batch_type
			
			-- Stored Procedure output for validation
			SELECT *
			FROM cfg.DataFeedDependencyExecutionLog
			WHERE master_batch_id = @master_batch_id;
			
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