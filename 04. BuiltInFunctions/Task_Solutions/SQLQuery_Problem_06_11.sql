-- 06. Find Towns Starting With

SELECT *
	FROM Towns
	WHERE LEFT([Name], 1) = 'M' OR LEFT([Name], 1) = 'K' 
		OR LEFT([Name], 1) = 'B' OR LEFT([Name], 1) = 'E'
	ORDER BY [Name] ASC

SELECT *
	FROM Towns
	WHERE [Name] LIKE '[MKBE]%'
	ORDER BY [Name] ASC

-- 07. Find Towns Not Starting With

SELECT *
	FROM Towns
	WHERE NOT (LEFT([Name], 1) = 'R' OR LEFT([Name], 1) = 'B' OR LEFT([Name], 1) = 'D')
	ORDER BY [Name] ASC

-- 08. Create View Employees Hired After

CREATE VIEW V_EmployeesHiredAfter2000 AS
	SELECT FirstName, LastName
		FROM Employees
		WHERE YEAR(HireDate) > 2000

SELECT * FROM V_EmployeesHiredAfter2000

-- 09. Length of Last Name

SELECT FirstName, LastName
	FROM Employees
	WHERE LEN(LastName) = 5
