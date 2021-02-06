-- 16. Employees Maximum Salaries

SELECT DepartmentID, MAX(Salary) AS MaxSalary
	FROM [Employees]
	GROUP BY DepartmentID
	HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

-- 17. Employees Count Salaries

SELECT COUNT(*) AS [Count]
	FROM [Employees]
	WHERE ManagerID IS NULL

-- 18. 3rd Highest Salary

SELECT DISTINCT DepartmentID, [Salary] AS ThirdHighestSalary
	FROM(SELECT DepartmentID, [Salary],
			DENSE_RANK() OVER(PARTITION BY DepartmentID ORDER BY [Salary] DESC) AS Ranked
			FROM [Employees]
		) AS TempTable
	WHERE Ranked = 3

-- 19. Salary Challenge

SELECT TOP(10) FirstName, LastName, DepartmentID
	FROM [Employees] AS e
	WHERE Salary > (SELECT AVG(Salary)
						FROM [Employees]
						WHERE e.DepartmentID = DepartmentID
						GROUP BY DepartmentID)
	ORDER BY DepartmentID

SELECT TOP(10) FirstName, LastName, DepartmentID
	FROM [Employees] AS e
	WHERE Salary > (SELECT AVG(Salary)
						FROM [Employees]
						WHERE e.DepartmentID = DepartmentID)
	ORDER BY DepartmentID

