
CREATE PROCEDURE [edw].[Load_DimProduct]

AS
BEGIN
    SET NOCOUNT ON

    BEGIN TRY

    begin transaction	
		
		BEGIN 

		/*
			This block should contain your code to populate your EDW table
		*/
		
		-- select count(*) as row_count from [stg].[Product];
		DECLARE @ERROR_MSG_500001 varchar(100) = 'ERROR: Custom Error message.';	

		END
	    
    select convert(varchar, @@ROWCOUNT) as rows_affected; -- Returns the number of rows affected by the last statement

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
END