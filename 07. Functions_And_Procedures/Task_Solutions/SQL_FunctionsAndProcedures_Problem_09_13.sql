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
CREATE OR ALTER PROC usp_GetHoldersWithBalanceHigherThan (@totalBalance DECIMAL(17, 2))
AS
SELECT FirstName AS [First Name], LastName AS [Last Name]
	FROM [AccountHolders] AS ah
	JOIN [Accounts] AS acc ON acc.AccountHolderId = ah.Id
	GROUP BY FirstName, LastName
	HAVING SUM(Balance) > @totalBalance
	ORDER BY FirstName, LastName

-- EXEC usp_GetHoldersWithBalanceHigherThan 10000

-- 11. Future Value Function

CREATE OR ALTER FUNCTION ufn_CalculateFutureValue (@initialSum MONEY, @rate FLOAT, @years INT)
RETURNS DECIMAL(17, 4)
AS
BEGIN
	DECLARE @resultSum DECIMAL(17, 4);
	SET @resultSum = @initialSum * (POWER((1 + @rate), @years));
	RETURN @resultSum;
END
SELECT dbo.ufn_CalculateFutureValue (1000, 0.1, 5) AS [Output]

-- 12. Calculating Interest

CREATE OR ALTER PROC usp_CalculateFutureValueForAccount (@accountId INT, @iterestRate DECIMAL(7, 4))
AS
	SELECT @accountId AS [Account Id], FirstName AS [First Name], LastName AS [Last Name], 
			Balance AS [Current Balance], 
			dbo.ufn_CalculateFutureValue (acc.Balance, @iterestRate, 5) AS [Balance in 5 years]
	 FROM [AccountHolders] AS ach
	 JOIN [Accounts] AS acc ON acc.AccountHolderId = ach.Id
	 WHERE acc.Id = @accountId

EXEC usp_CalculateFutureValueForAccount 1, 0.1

-- 13. *Cash in User Games Odd Rows

-- USE Diablo
CREATE OR ALTER FUNCTION ufn_CashInUsersGames (@gameName NVARCHAR(50))
RETURNS TABLE
RETURN
	(SELECT SUM(TempTable.Cash) AS SumCash
		FROM(SELECT ug.GameId, ug.Cash, g.Id, g.Name, ROW_NUMBER() OVER(ORDER BY Cash DESC) AS RowNum
				FROM [UsersGames] AS ug
				JOIN [Games] AS g ON ug.GameId = g.Id
				WHERE g.[Name] = @gameName
			)AS TempTable
	WHERE TempTable.RowNum % 2 = 1)
