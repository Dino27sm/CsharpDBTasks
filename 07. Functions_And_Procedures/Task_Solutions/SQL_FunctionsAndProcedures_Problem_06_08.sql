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

-- 08. Delete Employees and Departments --------------------------------------

GO
CREATE OR ALTER PROCEDURE usp_DeleteEmployeesFromDepartment(@departmentId int)
AS
DELETE
    FROM EmployeesProjects
    WHERE EmployeeID IN (SELECT EmployeeID
                             FROM Employees
                             WHERE DepartmentID = @departmentId)

UPDATE Employees
SET ManagerID=NULL
    WHERE ManagerID IN (SELECT EmployeeID
                            FROM Employees
                            WHERE DepartmentID = @departmentId)
    ALTER TABLE Departments
        ALTER COLUMN ManagerID INT

UPDATE Departments
SET ManagerID=NULL
    WHERE ManagerID IN (SELECT EmployeeID
                            FROM Employees
                            WHERE Employees.DepartmentID = @departmentId)

DELETE
    FROM Employees
    WHERE DepartmentID = @departmentId

DELETE
    FROM Departments
    WHERE DepartmentID = @departmentId

SELECT COUNT(*)
    FROM Employees
    WHERE DepartmentID = @departmentId
GO
