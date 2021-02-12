-- 19-1. Trigger (1. Users should not be allowed to buy items 
-----------------with higher level than their level.)

CREATE OR ALTER TRIGGER tr_RestrictsItemBuy ON [UserGameItems] INSTEAD OF INSERT
AS
	DECLARE @itemID INT = (SELECT ItemId FROM inserted)
	DECLARE @userGameID INT = (SELECT UserGameId FROM inserted)

	DECLARE @itemLevel INT = (SELECT MinLevel FROM [Items] WHERE Id = @itemID)
	DECLARE @userLevel INT = (SELECT [Level] FROM [UsersGames] WHERE Id = @userGameID)

	IF(@itemLevel <= @userLevel)
		BEGIN
			INSERT INTO [UserGameItems] (ItemId, UserGameId)
			VALUES (@itemID, @userGameID)
		END
GO
-------------------------------------------------------------------------------
-- 19-2. Trigger (2. Add bonus cash of 50000 to users: 
-----------------baleremuda, loosenoise, inguinalself, buildingdeltoid, monoxidecos 
-----------------in the game "Bali".)

WITH TempTable_CTE (UserId, UserName, Cash, GameID)
AS
(
	SELECT u.Id, u.Username, ug.Cash, g.Id
		FROM [Users] AS u
		JOIN [UsersGames] AS ug ON u.Id = ug.UserId
		JOIN [Games] AS g ON g.Id = ug.GameId
		WHERE (Username IN ('baleremuda', 'loosenoise'
							, 'inguinalself', 'buildingdeltoid'
							, 'monoxidecos')) AND (g.[Name] = 'Bali')
)

UPDATE [UsersGames]
	SET Cash += 50000
	WHERE UserId IN (SELECT UserId FROM TempTable_CTE) 
				AND GameId IN (SELECT GameID FROM TempTable_CTE)
GO
