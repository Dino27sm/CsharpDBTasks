-- 16. Get Users with IPAddress Like Pattern

SELECT Username, IpAddress AS [IP Address]
	FROM Users
	WHERE IpAddress LIKE ('___.1%._%.___')
	ORDER BY Username

-- 17. Show All Games with Duration

SELECT [Name] AS Game
	,CASE
		WHEN DATEPART(HOUR, [Start]) >= 0 AND DATEPART(HOUR, [Start]) < 12 
			THEN 'Morning'
		WHEN DATEPART(HOUR, [Start]) >= 12 AND DATEPART(HOUR, [Start]) < 18 
			THEN 'Afternoon'
		WHEN DATEPART(HOUR, [Start]) >= 18 AND DATEPART(HOUR, [Start]) < 24 
			THEN 'Evening'
	END AS [Part of the Day]

	,CASE
		WHEN Duration <= 3 THEN 'Extra Short'
		WHEN Duration >= 4 AND Duration <= 6 THEN 'Short'
		WHEN Duration > 6 THEN 'Long'
	ELSE 'Extra Long'
	END AS [Duration]
	FROM Games
	ORDER BY [Game], [Duration]
