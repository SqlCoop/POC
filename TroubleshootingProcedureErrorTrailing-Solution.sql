/*-----------------------
CORRECT EXAMPLE
The code in this example represents the scenario whereby when an error occurs in an embedded child procedure,
you will receive the errror/line number from childProc, as well as the line number in parent just after where the childProc 
was called from.

*/-----------------------

USE CatchingErrors_In_EmbeddedProcedures
GO

CREATE OR ALTER PROCEDURE Solution_parentProc
( @LastName varchar(100))
	/*   
	EXECUTE Solution_parentProc '12345678901234'  --Will cause error in childProc, Length Exceeds DataType length
	EXECUTE Solution_parentProc '1234' --Is valid parameter value
	*/
as

DECLARE	@CustomErrorMessage as VARCHAR(100);

BEGIN TRY
CREATE TABLE #TEMP(LastName varchar(10))

	BEGIN TRY 
		EXECUTE Solution_childProc @LastName; 
	END TRY
	BEGIN CATCH 
		-- ChildProc error bubbled up to parent procedure
		EXEC DisplayErrorInfo;
		SET @CustomErrorMessage = 'EXECUTE Solution_childProc ''' + @LastName + ''''
		RAISERROR(@CustomErrorMessage, 16, 1); 
	END CATCH

	SELECT 'Parent Procedure Completed';
END TRY
BEGIN CATCH
	EXEC DisplayErrorInfo
END CATCH
GO
----------------------
----------------------
CREATE OR ALTER PROC Solution_childProc (
  @LastName varchar(100)
  )
as

	INSERT #TEMP
	SELECT @LastName
GO
----------------------
----------------------
CREATE OR ALTER  PROCEDURE DisplayErrorInfo
as
    SELECT   
        ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        ,ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_LINE() AS ErrorLine  
        ,ERROR_MESSAGE() AS ErrorMessage
		,GETDATE() AS ErrorTime; 
		
	WAITFOR DELAY '00:00:01';



