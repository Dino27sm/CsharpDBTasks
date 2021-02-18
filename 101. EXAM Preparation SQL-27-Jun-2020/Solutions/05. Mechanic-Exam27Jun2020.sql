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




