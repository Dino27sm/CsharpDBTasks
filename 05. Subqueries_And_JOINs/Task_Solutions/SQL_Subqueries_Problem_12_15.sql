-- 12. Highest Peaks in Bulgaria

SELECT c.CountryCode, m.MountainRange, p.PeakName, p.Elevation
	FROM [MountainsCountries] AS mc
	JOIN [Countries] AS c ON mc.CountryCode = c.CountryCode
	JOIN [Mountains] AS m ON mc.MountainId = m.Id
	JOIN [Peaks] AS p ON p.MountainId = m.Id
	WHERE c.CountryCode = 'BG' AND p.Elevation > 2835
	ORDER BY p.Elevation DESC

-- 13. Count Mountain Ranges

SELECT c.CountryCode, COUNT(c.CountryCode) AS MountainRange
	FROM [MountainsCountries] AS mc
	JOIN [Countries] AS c ON mc.CountryCode = c.CountryCode
	JOIN [Mountains] AS m ON mc.MountainId = m.Id
	WHERE c.CountryCode IN ('US', 'RU', 'BG')
	GROUP BY c.CountryCode

SELECT mc.CountryCode, COUNT(mc.MountainId) AS MountainRange
	FROM [MountainsCountries] AS mc
	WHERE mc.CountryCode IN ('US', 'RU', 'BG')
	GROUP BY mc.CountryCode

-- 14. Countries With or Without Rivers

SELECT TOP(5) c.CountryName, r.RiverName
	FROM [CountriesRivers] AS cr
	FULL JOIN [Countries] AS c ON cr.CountryCode = c.CountryCode
	FULL JOIN [Rivers] AS r ON cr.RiverId = r.Id
	WHERE c.ContinentCode = 'AF'
	ORDER BY c.CountryName
	
SELECT TOP(5) c.CountryName, r.RiverName
	FROM [Countries] AS c
	LEFT JOIN [CountriesRivers] AS cr ON cr.CountryCode = c.CountryCode
	LEFT JOIN [Rivers] AS r ON cr.RiverId = r.Id
	WHERE c.ContinentCode = 'AF'
	ORDER BY c.CountryName

-- 15. Continents and Currencies

SELECT ContinentCode, CurrencyCode, TempTable.currency AS CurrencyUsage
	FROM
		(
		SELECT ContinentCode, CurrencyCode, COUNT(CurrencyCode) AS currency,
			DENSE_RANK() OVER(PARTITION BY ContinentCode ORDER BY COUNT(CurrencyCode) DESC) AS Ranked
			FROM [Countries]
			GROUP BY ContinentCode, CurrencyCode
		)
		AS TempTable

	WHERE TempTable.Ranked = 1 AND TempTable.currency > 1
	ORDER BY ContinentCode
	