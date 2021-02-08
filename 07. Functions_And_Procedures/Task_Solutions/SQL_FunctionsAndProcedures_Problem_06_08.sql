-- 06. Employees by Salary Level

CREATE PROC usp_EmployeesBySalaryLevel (@SalaryLevel VARCHAR(30))
AS
	SELECT FirstName AS [First Name], LastName AS [Last Name]
		FROM Employees AS e
		WHERE [dbo].[ufn_GetSalaryLevel](e.Salary) = @SalaryLevel
GO
EXEC usp_EmployeesBySalaryLevel 'High'

-- 07. Define Function
GO
CREATE OR ALTER FUNCTION ufn_IsWordComprised(@setOfLetters NVARCHAR(MAX), @word NVARCHAR(MAX))
RETURNS BIT
AS
BEGIN
	DECLARE @isContain BIT = 1;
	DECLARE @counter INT = 1
	WHILE(@counter <= LEN(@word))
		BEGIN
			IF (CHARINDEX(SUBSTRING(@word, @counter, 1), @setOfLetters) = 0)
				BEGIN
					SET @isContain = 0;
					BREAK;
				END
			SET @counter += 1;
		END
	RETURN @isContain;
END
GO
SELECT [dbo].[ufn_IsWordComprised]('oistmiahf', 'Sofia') AS Result

