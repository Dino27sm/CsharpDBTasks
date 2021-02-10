-- 14. Create Table Logs
CREATE TABLE Logs
(
	LogId INT PRIMARY KEY IDENTITY NOT NULL, 
	AccountId INT REFERENCES Accounts(Id), 
	OldSum DECIMAL(17, 2) NOT NULL, 
	NewSum DECIMAL(17, 2) NOT NULL
)
GO
CREATE OR ALTER TRIGGER tr_AddToLogsBalanceChanges ON Accounts FOR UPDATE
AS
	DECLARE @newSum DECIMAL(17, 2) = (SELECT Balance FROM inserted)	
	DECLARE @oldSum DECIMAL(17, 2) = (SELECT Balance FROM deleted)
	DECLARE @accountId INT = (SELECT Id FROM inserted)
	INSERT INTO Logs (AccountId, OldSum, NewSum)
	VALUES
		(@accountId, @oldSum, @newSum)
GO
