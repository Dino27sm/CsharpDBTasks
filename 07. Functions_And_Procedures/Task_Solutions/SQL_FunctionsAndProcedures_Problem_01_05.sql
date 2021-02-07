--USE SoftUni
-- 01. Employees with Salary Above 35000

CREATE OR ALTER PROC usp_GetEmployeesSalaryAbove35000
AS
	SELECT FirstName AS [First Name], LastName AS [Last Name]
		FROM Employees
		WHERE Salary > 35000
GO

CREATE PROC usp_GetEmployeesSalaryAbove35000
AS
BEGIN
	SELECT FirstName AS [First Name], LastName AS [Last Name]
		FROM Employees
		WHERE Salary > 35000
END
EXEC usp_GetEmployeesSalaryAbove35000

-- 02. Employees with Salary Above Number

CREATE PROC usp_GetEmployeesSalaryAboveNumber (@Salary DECIMAL(18, 4))
AS
	SELECT FirstName AS [First Name], LastName AS [Last Name]
		FROM Employees
		WHERE Salary >= @Salary
GO
EXEC usp_GetEmployeesSalaryAboveNumber 48100	-- NO brackets when passing parameters

-- 03. Town Names Starting With

CREATE PROC usp_GetTownsStartingWith (@String NVARCHAR(MAX))
AS
	SELECT t.[Name] AS Town
		FROM Towns AS t
		WHERE t.[Name] LIKE @String + '%'
GO
EXEC usp_GetTownsStartingWith 'b'

-- 04. Employees from Town

CREATE PROC usp_GetEmployeesFromTown (@Town NVARCHAR(50))
AS
	SELECT e.FirstName AS [First Name], e.LastName AS [Last Name]
		FROM Employees AS e
		JOIN Addresses AS a ON e.AddressID = a.AddressID
		JOIN Towns AS t ON a.TownID = t.TownID
		WHERE t.[Name] = @Town
GO
EXEC usp_GetEmployeesFromTown 'Sofia'

-- 05. Salary Level Function

CREATE OR ALTER FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS VARCHAR(30)
AS
BEGIN
	DECLARE @SalaryLevel VARCHAR(30)
	IF (@salary < 30000)
		SET @SalaryLevel = 'Low'
	ELSE IF (@salary >= 30000 AND @salary <= 50000)
		SET @SalaryLevel = 'Average'
	ELSE IF (@salary > 50000)
		SET @SalaryLevel = 'High'
	RETURN @SalaryLevel
END

----------------------------------------------------------------------------
CREATE OR ALTER FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS VARCHAR(30)
AS
BEGIN
	RETURN (CASE
				WHEN @salary < 30000 THEN 'Low'
				WHEN @salary BETWEEN 30000 AND 50000 THEN 'Average'
				ELSE 'High'
			END)
END
------------------------------------ Example how to use created FUNCTION -----------------------------------------
SELECT Salary, [dbo].[ufn_GetSalaryLevel](Salary) AS [Salary Level]
	FROM Employees
