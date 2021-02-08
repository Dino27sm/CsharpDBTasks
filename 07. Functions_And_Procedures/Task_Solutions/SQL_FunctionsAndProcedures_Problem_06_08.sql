-- 06. Employees by Salary Level

CREATE PROC usp_EmployeesBySalaryLevel (@SalaryLevel VARCHAR(30))
AS
	SELECT FirstName AS [First Name], LastName AS [Last Name]
		FROM Employees AS e
		WHERE [dbo].[ufn_GetSalaryLevel](e.Salary) = @SalaryLevel
GO
EXEC usp_EmployeesBySalaryLevel 'High'

