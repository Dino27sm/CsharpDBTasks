-- 16. Get Users with IPAddress Like Pattern

SELECT Username, IpAddress AS [IP Address]
	FROM Users
	WHERE IpAddress LIKE ('___.1%._%.___')
	ORDER BY Username

