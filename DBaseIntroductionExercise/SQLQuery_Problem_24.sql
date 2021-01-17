--USE Hotel
-- Data from Problem 23. Decrease Tax Rate

UPDATE Payments
	SET [TaxRate] *= 0.97

SELECT [TaxRate] FROM Payments

-- Problem 24. Delete All Records

TRUNCATE TABLE Occupancies