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
-- 15. Create Table Emails

CREATE TABLE NotificationEmails
(
	Id INT PRIMARY KEY IDENTITY NOT NULL, 
	Recipient INT REFERENCES Accounts(Id) NOT NULL, 
	[Subject] NVARCHAR(500) NOT NULL, 
	Body NVARCHAR(500) NOT NULL
)
GO
CREATE OR ALTER TRIGGER tr_CreateEmailWhenLogsChanges ON Logs FOR INSERT
AS
	DECLARE @oldSum NVARCHAR(100) = CAST((SELECT OldSum FROM inserted) AS NVARCHAR(100))
	DECLARE @newSum NVARCHAR(100) = CAST((SELECT NewSum FROM inserted) AS NVARCHAR(100))
	DECLARE @date NVARCHAR(100) = CAST(GETDATE() AS NVARCHAR(100))
	DECLARE @recepient INT = (SELECT AccountId FROM inserted)
	DECLARE @subject NVARCHAR(500) = 'Balance change for account: ' + CAST(@recepient AS NVARCHAR(100))
	DECLARE @body NVARCHAR(500) = CONCAT('On ', @date, ' your balance was changed from ', 
			@oldSum, ' to ', @newSum, '.')

	INSERT INTO NotificationEmails (Recipient, [Subject], Body)
	VALUES
		(@recepient, @subject, @body)

-- 16. Deposit Money
GO
CREATE OR ALTER PROC usp_DepositMoney (@accountId INT, @moneyAmount DECIMAL(17, 4))
AS
BEGIN TRANSACTION
	DECLARE @checkId INT = (SELECT Id FROM Accounts WHERE Id = @accountId)
	IF(@checkId IS NULL)
		BEGIN
			ROLLBACK;
			THROW 50001, 'Invali account!', 1
		END

	IF(@moneyAmount < 0)
		BEGIN
			ROLLBACK;
			THROW 50002, 'Neative money amount!', 1;
		END

	UPDATE Accounts
		SET Balance += @moneyAmount
		WHERE Id = @accountId
COMMIT
EXEC usp_DepositMoney 1, 100

