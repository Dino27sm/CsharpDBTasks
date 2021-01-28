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

