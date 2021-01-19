SELECT * FROM Employees

-- 16. Create View Employees with Salaries
/*
CREATE VIEW V_EmployeesSalaries AS
	SELECT FirstName, LastName, Salary
		FROM Employees

SELECT * FROM V_EmployeesSalaries
*/
-- 17. Create View Employees with Job Titles
/*
CREATE VIEW V_EmployeeNameJobTitle AS
	SELECT FirstName + ' ' + ISNULL(MiddleName, '') + ' ' + LastName AS [Full Name], JobTitle AS [Job Title]
		FROM Employees

SELECT * FROM V_EmployeeNameJobTitle
*/
-- 18. Distinct Job Titles

SELECT DISTINCT JobTitle
	FROM Employees

-- 19. Find First 10 Started Projects

SELECT TOP(10) * 
	FROM [Projects]
	ORDER BY StartDate ASC, [Name] ASC;

-- 20. Last 7 Hired Employees

SELECT TOP(7) FirstName, LastName, HireDate 
	FROM [Employees]
	ORDER BY HireDate DESC;
