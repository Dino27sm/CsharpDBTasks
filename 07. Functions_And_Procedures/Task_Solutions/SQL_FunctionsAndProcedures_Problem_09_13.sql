-- 09. Find Full Name

CREATE PROC usp_GetHoldersFullName
AS
	SELECT CONCAT(FirstName, ' ', LastName) AS [Full Name]
		FROM [AccountHolders]

-- EXEC usp_GetHoldersFullName

-- 10. People with Balance Higher Than

CREATE OR ALTER PROC usp_GetHoldersWithBalanceHigherThan (@totalBalance DECIMAL(17, 2))
AS
SELECT FirstName AS [First Name], LastName AS [Last Name]
	FROM(SELECT FirstName, LastName, SUM(Balance) AS TotalBalance
			FROM [AccountHolders] AS ah
			JOIN [Accounts] AS acc ON acc.AccountHolderId = ah.Id
			GROUP BY FirstName, LastName
		) AS TempTable
		WHERE TotalBalance > @totalBalance
		ORDER BY FirstName, LastName

-----------------------------------------------------
