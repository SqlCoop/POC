/*-----------------------
PROBLEM 1 EXAMPLE
The code in this example represents the scenario whereby when an error occurs in an embedded child procedure,
you will receive the errror/line number from childProc.  If you do not use a Catch Block in the Child Procedure,
but have on in the Parent procedure, then the Error will be caught by the parent's catch block and immediately stop execution 
of the procedure.

PROBLEM 2 EXAMPLE
The code in this example represents the scenario whereby when an error occurs in an embedded child procedure,
you will receive the errror/line number from childProc.  If you a Catch Block in the Child Procedure,
then the Error will be caught by the child procedure's catch block and then return control back to the parent procedure code, 
where it will continue running to completion.

Based on Blog at https://dba.stackexchange.com/questions/211388/sql-server-try-catch-resume-on-terminating-error
The scenario emphasis in the above blog focuses on running multiple embedded proces, and even if some of them failed,
a error will be generated; but the parent procedure will not stop and will continually process the remaining procedures.
*/-----------------------

USE CatchingErrors_In_EmbeddedProcedures
GO

CREATE OR ALTER PROCEDURE Problem1_parentProc
( @LastName varchar(100))
	/*   
	EXECUTE Problem1_parentProc '12345678901234'  --Will cause error in childProc, Length Exceeds DataType length
	EXECUTE Problem1_parentProc '1234' --Is valid parameter value
	*/
as

DECLARE	@CustomErrorMessage as VARCHAR(100);

BEGIN TRY
	CREATE TABLE #TEMP(LastName varchar(10))
	EXECUTE Problem1_childProc @LastName; 
	SELECT 'Parent Procedure Completed Successfully';
END TRY
BEGIN CATCH
	EXEC DisplayErrorInfo
END CATCH
GO
----------------------
----------------------
CREATE OR ALTER PROCEDURE Problem2_parentProc
( @LastName varchar(100))
	/*   
	EXECUTE Problem2_parentProc '12345678901234'  --Will cause error in childProc, Length Exceeds DataType length
	EXECUTE Problem2_parentProc '1234' --Is valid parameter value
	*/
as

DECLARE	@CustomErrorMessage as VARCHAR(100);

BEGIN TRY
	CREATE TABLE #TEMP(LastName varchar(10))
	EXECUTE Problem2_childProcWithCatchBlock @LastName; 
	SELECT 'Parent Procedure Completed Successfully';
END TRY
BEGIN CATCH
---	EXEC DisplayErrorInfo
END CATCH
GO
----------------------
----------------------
CREATE OR ALTER PROC Problem1_childProc (
  @LastName varchar(100)
  )
as

	INSERT #TEMP
	SELECT @LastName
GO
----------------------
----------------------
CREATE OR ALTER PROC Problem2_childProcWithCatchBlock(
  @LastName varchar(100)
  )
as
BEGIN TRY 
	INSERT #TEMP
	SELECT @LastName
END TRY
BEGIN CATCH 
	-- ChildProc error bubbled up to parent procedure
	EXEC DisplayErrorInfo;
END CATCH
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




