USE [Geography]
----------------------------------------------- Solution Without JOIN -----------------------
SELECT MountainRange, PeakName, Elevation
	FROM [dbo].[Mountains], [dbo].[Peaks]
	WHERE (MountainRange = 'Rila') AND ([Peaks].MountainId = [Mountains].Id)
	ORDER BY Elevation DESC

----------------------------------------------- Solution With JOIN -----------------------

SELECT MountainRange, PeakName, Elevation
	FROM Mountains
		JOIN  Peaks ON Peaks.MountainId = Mountains.Id
	WHERE MountainRange = ('Rila')
	ORDER BY Elevation DESC
