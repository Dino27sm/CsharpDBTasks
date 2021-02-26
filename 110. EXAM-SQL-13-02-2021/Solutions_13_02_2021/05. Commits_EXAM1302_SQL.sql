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

