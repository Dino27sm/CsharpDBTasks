-- 16. Employees Maximum Salaries

SELECT DepartmentID, MAX(Salary) AS MaxSalary
	FROM [Employees]
	GROUP BY DepartmentID
	HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

-- 17. Employees Count Salaries

SELECT COUNT(*) AS [Count]
	FROM [Employees]
	WHERE ManagerID IS NULL

