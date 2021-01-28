--USE [Geography]
-- 12. Countries Holding 'A'

SELECT CountryName AS [Country Name], IsoCode AS [ISO Code]
	FROM [dbo].[Countries]
	WHERE CountryName LIKE('%a%a%a%')
	ORDER BY IsoCode

SELECT CountryName AS [Country Name], IsoCode AS [ISO Code]
	FROM [dbo].[Countries]
	WHERE (LEN(CountryName) - LEN(REPLACE(CountryName, 'a', ''))) >= 3
	ORDER BY IsoCode

-- 13. Mix of Peak and River Names

SELECT PeakName, RiverName
	,LOWER(CONCAT(SUBSTRING(PeakName, 1, LEN(PeakName)-1), RiverName)) AS Mix
	FROM Peaks
	JOIN Rivers ON (RIGHT(PeakName, 1) = LEFT(RiverName, 1))
	ORDER BY Mix

SELECT PeakName, RiverName
	,LOWER(STUFF(PeakName, LEN(PeakName), 1, RiverName)) AS Mix
	FROM Peaks
	JOIN Rivers ON (RIGHT(PeakName, 1) = LEFT(RiverName, 1))
	ORDER BY Mix

-- 14. Games From 2011 and 2012 Year

SELECT TOP(50) [Name], FORMAT([Start], 'yyyy-MM-dd') AS [Start]
	FROM [dbo].[Games]
	WHERE YEAR([Start]) = 2011 OR YEAR([Start]) = 2012
	ORDER BY [Start], [Name]

