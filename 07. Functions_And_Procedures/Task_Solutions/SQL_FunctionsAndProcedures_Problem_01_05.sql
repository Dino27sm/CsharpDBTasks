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

