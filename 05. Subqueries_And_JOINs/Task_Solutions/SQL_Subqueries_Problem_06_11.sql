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

