
CREATE PROCEDURE [cfg].[UpdateMasterBatch]
	(
	@master_batch_id int,
	@MasterBatchStatus nvarchar(50)
	)
AS
BEGIN
	SET NOCOUNT ON;	
		BEGIN TRY

    	begin transaction
				
		UPDATE
			cfg.MasterBatchExecutionLog
		SET
			MasterBatchStatus = @MasterBatchStatus,
			[EndDateTime] = GETUTCDATE()
		WHERE
			master_batch_id = @master_batch_id
		
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