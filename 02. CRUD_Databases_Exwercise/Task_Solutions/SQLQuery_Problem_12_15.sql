SELECT * FROM [Employees]

-- 12. Find All Employees with Salary More Than

SELECT FirstName, LastName, Salary
	FROM Employees
	WHERE Salary > 50000
	ORDER BY Salary DESC;

-- 13. Find 5 Best Paid Employees

SELECT TOP(5) FirstName, LastName
	FROM Employees
	ORDER BY Salary DESC;

-- 14. Find All Employees Except Marketing

SELECT FirstName, LastName
	FROM Employees
	WHERE DepartmentID != 4;

-- 15. Sort Employees Table

SELECT *
	FROM Employees
	ORDER BY Salary DESC, FirstName ASC, LastName DESC, MiddleName ASC; 
