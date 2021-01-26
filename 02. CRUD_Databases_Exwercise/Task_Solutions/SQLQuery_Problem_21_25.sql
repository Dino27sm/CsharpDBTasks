SELECT * FROM Employees
SELECT * FROM Departments

-- 20. Last 7 Hired Employees

SELECT TOP(7) FirstName, LastName, HireDate 
	FROM [Employees]
	ORDER BY HireDate DESC;

-- 21. Increase Salaries

--USE master
--BACKUP DATABASE SoftUni TO DISK = 'E:\Soft-Uni\SQL Backup Data Base\SoftUni-backup.bak'
--DROP DATABASE SoftUni
--RESTORE DATABASE SoftUni FROM DISK = 'E:\Soft-Uni\SQL Backup Data Base\SoftUni-backup.bak'

UPDATE Employees
	SET Salary *= 1.12
	WHERE [dbo].[Employees].DepartmentID 
		IN (SELECT DepartmentID
				FROM [dbo].[Departments]
				WHERE [dbo].[Departments].[Name] IN ('Engineering', 'Tool Design', 'Marketing', 
					'Information Services'))

SELECT Salary
	FROM Employees

-- 22. All Mountain Peaks

SELECT PeakName
	FROM Peaks
	ORDER BY PeakName;

-- 23. Biggest Countries by Population

SELECT TOP(30) CountryName, [Population]
	FROM Countries
	WHERE ContinentCode = 'EU'
	ORDER BY [Population] DESC, CountryName ASC;

-- 24. Countries and Currency

SELECT CountryName, CountryCode,
	CASE
           WHEN CurrencyCode = 'EUR' THEN 'Euro'
           ELSE 'Not Euro'
           END AS [Currency]
	FROM Countries
	ORDER BY CountryName ASC;
	
-- 25. All Diablo Characters

SELECT [Name]
	FROM Characters
	ORDER BY [Name]