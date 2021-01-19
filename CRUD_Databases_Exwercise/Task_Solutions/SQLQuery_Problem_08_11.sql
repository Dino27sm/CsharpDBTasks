SELECT * FROM [Employees]

-- Solution of the Task 08. Find all Information About Employees

SELECT *
	FROM Employees
	WHERE JobTitle = 'Sales Representative';

-- Solution of the Task 09. Find Names of All Employees by Salary in Range

SELECT FirstName, LastName, JobTitle
	FROM Employees
	WHERE Salary >= 20000 AND Salary <= 30000;

SELECT FirstName, LastName, JobTitle
	FROM Employees
	WHERE Salary BETWEEN 20000 AND 30000;

-- Solution of the Task 10. Find Names of All Employees

SELECT FirstName + ' ' + MiddleName + ' ' + LastName AS [Full Name]
	FROM Employees
	WHERE Salary IN (25000, 14000, 12500, 23600);

-- Solution of the Task 11. Find All Employees Without Manager

SELECT FirstName, LastName
	FROM Employees
	WHERE ManagerID IS NULL;
