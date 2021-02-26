-- 05. Commits

SELECT Id, [Message], RepositoryId, ContributorId
	FROM Commits
	ORDER BY Id, [Message], RepositoryId, ContributorId

-- 06. Front-end

SELECT Id, [Name], [Size]
	FROM Files
	WHERE Size > 1000 AND [Name] LIKE '%html%'
	ORDER BY [Size] DESC, Id, [Name]

-- 07. Issue Assignment

SELECT i.Id, (u.Username + ' : ' + i.Title) AS IssueAssignee
	FROM Issues AS i
	JOIN Users AS u ON i.AssigneeId = u.Id
	ORDER BY i.Id DESC, i.AssigneeId

-------------------------------------------------------------------------------------
-- 08. Single Files --- OK but --- NOT SENT TO Judge -----

SELECT f1.Id, f1.[Name], CONCAT(f1.Size, 'KB') AS Size
	FROM Files AS f1
	WHERE (ParentId != Id OR ParentId IS NULL)
		AND Id NOT IN(SELECT f2.ParentId FROM Files AS f2 WHERE f2.ParentId != f2.Id)
	ORDER BY f1.Id, f1.[Name], Size DESC

--------------------------- My other solution of 08. Single Files --

SELECT f1.Id, f1.[Name], CONCAT(f1.Size, 'KB') AS Size
	FROM Files AS f1
	LEFT JOIN Files AS f2 ON f2.ParentId = f1.Id
	WHERE f2.Id IS NULL
	ORDER BY f1.Id, f1.[Name], Size DESC


