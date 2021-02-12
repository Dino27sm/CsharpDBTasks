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
