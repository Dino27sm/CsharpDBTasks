-- 05. Mechanic Assignments

SELECT (m.FirstName + ' ' + m.LastName) AS Mechanic, [Status], IssueDate
	FROM Mechanics AS m
	JOIN Jobs AS j ON j.MechanicId = m.MechanicId
	ORDER BY m.MechanicId, IssueDate, j.JobId

-- 06. Current Clients

SELECT (c.FirstName + ' ' + c.LastName) AS [Client], 
		(DATEDIFF(DAY, IssueDate, '2017-04-24')) AS [Days going], [Status]
	FROM Clients AS c
	JOIN Jobs AS j ON j.ClientId = c.ClientId
	WHERE j.Status != 'Finished'
	ORDER BY [Days going] DESC, c.ClientId

-- 07. Mechanic Performance

SELECT (temp.FirstName + ' ' + temp.LastName) AS Mechanic, temp.[Average Days]
	FROM(SELECT m.MechanicId, m.FirstName, m.LastName,
				(SUM((DATEDIFF(DAY, IssueDate, FinishDate))) / COUNT(m.MechanicId)) AS [Average Days]
			FROM Mechanics AS m
			JOIN Jobs AS j ON j.MechanicId = m.MechanicId
			WHERE j.Status = 'Finished'
			GROUP BY m.MechanicId, m.FirstName, m.LastName) AS temp
	ORDER BY temp.MechanicId
-------------------------------------------------------------------------------------

SELECT (temp.FirstName + ' ' + temp.LastName) AS Mechanic, temp.[Average Days]
	FROM(SELECT m.MechanicId, m.FirstName, m.LastName,
				AVG((DATEDIFF(DAY, IssueDate, FinishDate))) AS [Average Days]
			FROM Mechanics AS m
			JOIN Jobs AS j ON j.MechanicId = m.MechanicId
			WHERE j.Status = 'Finished'
			GROUP BY m.MechanicId, m.FirstName, m.LastName) AS temp
	ORDER BY temp.MechanicId

-- 08. Available Mechanics
--------  HERE IS THE SOLUTION  ---------	
SELECT (m.FirstName + ' ' + m.LastName) AS Available
	FROM Mechanics AS m
	LEFT JOIN Jobs AS j ON j.MechanicId = m.MechanicId
	WHERE (j.[Status] = 'Finished' OR j.JobId IS NULL) 
		AND m.MechanicId NOT IN(SELECT ms.MechanicId FROM Mechanics AS ms
										JOIN Jobs AS js ON js.MechanicId = ms.MechanicId
										WHERE js.[Status] != 'Finished'
										GROUP BY ms.MechanicId)
	GROUP BY m.MechanicId, m.FirstName, m.LastName

-- 09. Past Expenses

SELECT j.JobId, ISNULL(SUM(op.Quantity * p.Price), 0) AS Total
	FROM Jobs AS j
	LEFT JOIN Orders AS o ON o.JobId = j.JobId
	LEFT JOIN OrderParts AS op ON op.OrderId = o.OrderId
	LEFT JOIN Parts AS p ON p.PartId = op.PartId
	WHERE j.Status = 'Finished'
	GROUP BY j.JobId
	ORDER BY Total DESC, JobId



