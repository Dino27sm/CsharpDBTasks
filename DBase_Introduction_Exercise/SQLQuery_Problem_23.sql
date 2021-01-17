--USE Hotel

UPDATE Payments
	SET [TaxRate] -= 3

SELECT [TaxRate] FROM Payments
