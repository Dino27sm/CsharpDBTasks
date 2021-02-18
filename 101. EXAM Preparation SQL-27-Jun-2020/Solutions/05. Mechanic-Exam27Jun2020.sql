-- 05. Mechanic Assignments

SELECT (m.FirstName + ' ' + m.LastName) AS Mechanic, [Status], IssueDate
	FROM Mechanics AS m
	JOIN Jobs AS j ON j.MechanicId = m.MechanicId
	ORDER BY m.MechanicId, IssueDate, j.JobId



