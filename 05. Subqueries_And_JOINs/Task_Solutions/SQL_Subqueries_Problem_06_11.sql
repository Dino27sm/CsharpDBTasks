-- 06. Employees Hired After

SELECT e.FirstName, e.LastName, e.HireDate, d.[Name] AS DeptName
	FROM [Employees] AS e
	JOIN [Departments] AS d ON e.DepartmentID = d.DepartmentID
	WHERE (e.HireDate > '1.1.1999') AND (d.[Name] IN ('Sales', 'Finance'))
	ORDER BY e.HireDate ASC

SELECT e.FirstName, e.LastName, e.HireDate, d.[Name] AS DeptName
	FROM [Employees] AS e
	JOIN [Departments] AS d ON (e.DepartmentID = d.DepartmentID) AND (d.[Name] IN ('Sales', 'Finance'))
	WHERE (e.HireDate > '1.1.1999')
	ORDER BY e.HireDate ASC

-- 07. Employees With Project

SELECT TOP(5) e.EmployeeID, e.FirstName, p.[Name] AS ProjectName
	FROM [Employees] AS e
	JOIN [EmployeesProjects] AS ep ON e.EmployeeID = ep.EmployeeID
	JOIN [Projects] AS p ON ep.ProjectID = p.ProjectID
	WHERE p.EndDate IS NULL AND p.StartDate > '2002-08-13'
	ORDER BY e.EmployeeID
	
SELECT TOP(5) e.EmployeeID, e.FirstName, p.[Name] AS ProjectName
	FROM [Employees] AS e
	JOIN [EmployeesProjects] AS ep ON e.EmployeeID = ep.EmployeeID
	JOIN [Projects] AS p ON ep.ProjectID = p.ProjectID
	WHERE p.EndDate IS NULL AND p.StartDate > CONVERT(DATETIME, '13.08.2002', 104)
	ORDER BY e.EmployeeID
	