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
