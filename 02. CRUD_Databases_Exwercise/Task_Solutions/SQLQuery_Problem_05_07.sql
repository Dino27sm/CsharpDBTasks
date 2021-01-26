SELECT * FROM [Employees]

-- Solution of the Task 05. Find Full Name of Each Employee

SELECT FirstName, MiddleName, LastName
	FROM [Employees]

-- Solution of the Task 06. Find Email Address of Each Employee

SELECT FirstName + '.' + LastName + '@' + 'softuni.bg' AS [Full Email Address]
	FROM Employees

-- Solution of the Task 07. Find All Different Employee’s Salaries

SELECT DISTINCT Salary
	FROM Employees