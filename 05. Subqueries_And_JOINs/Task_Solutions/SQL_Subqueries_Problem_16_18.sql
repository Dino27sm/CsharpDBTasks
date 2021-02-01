-- 16. Countries Without any Mountains

SELECT COUNT(*) AS [Count]
	FROM [Countries] AS c
	LEFT JOIN [MountainsCountries] AS mc ON c.CountryCode = mc.CountryCode
	WHERE mc.MountainId IS NULL

-- 17. Highest Peak and Longest River by Country

SELECT TOP (5) c.CountryName, 
		MAX(p.Elevation) AS HighestPeakElevation, 
		MAX(r.Length) AS LongestRiverLength
    FROM Countries AS c
    LEFT JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
    LEFT JOIN Rivers AS r ON cr.RiverId = r.Id
    LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
    LEFT JOIN Mountains AS m ON mc.MountainId = m.Id
    LEFT JOIN Peaks p ON m.Id = p.MountainId
    GROUP BY c.CountryName
    ORDER BY HighestPeakElevation DESC, LongestRiverLength DESC, c.CountryName

-- 18. Highest Peak Name and Elevation by Country

SELECT TOP(5) Country, [Highest Peak Name], [Highest Peak Elevation], [Mountain]
	FROM
		(
		SELECT  c.CountryName AS Country,
			ISNULL(p.PeakName, '(no highest peak)') AS [Highest Peak Name],
			ISNULL(MAX(p.Elevation), 0) AS [Highest Peak Elevation],
			ISNULL(m.MountainRange, '(no mountain)') AS [Mountain],
			DENSE_RANK() OVER(PARTITION BY c.CountryName ORDER BY MAX(p.Elevation) DESC) AS Ranked
		FROM Countries AS c
		LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
		LEFT JOIN Mountains AS m ON mc.MountainId = m.Id
		LEFT JOIN Peaks p ON m.Id = p.MountainId
		GROUP BY c.CountryName, p.PeakName, m.MountainRange
		) AS TempTable
	WHERE TempTable.Ranked = 1
    ORDER BY Country, [Highest Peak Name]
