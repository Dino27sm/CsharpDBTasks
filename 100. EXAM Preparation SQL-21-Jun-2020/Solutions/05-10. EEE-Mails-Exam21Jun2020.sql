-- 05. EEE-Mails

SELECT a.FirstName, a.LastName, FORMAT(a.BirthDate, 'MM-dd-yyyy') AS BirthDate, c.[Name] AS Hometown, a.Email
	FROM Accounts AS a
	JOIN Cities AS c ON a.CityId = c.Id
	WHERE Email LIKE 'e%'
	ORDER BY c.[Name] ASC

-- 06. City Statistics

SELECT temp.City, temp.Hotels
	FROM (SELECT c.[Name] AS City, c.Id, h.CityId, COUNT(*) AS Hotels
			FROM Cities AS c
			JOIN Hotels AS h ON c.Id = h.CityId
			GROUP BY c.[Name], c.Id, h.CityId) AS temp

	ORDER BY temp.Hotels DESC, temp.City

-- 07. Longest and Shortest Trips

SELECT temp.Id AS AccountId, temp.FullName, MAX(TripDays) AS LongestTrip, MIN(TripDays) AS ShortestTrip
	FROM (SELECT a.Id, a.FirstName + ' ' + a.LastName AS FullName,
				DATEDIFF(DAY, tr.ArrivalDate, tr.ReturnDate) AS TripDays
			FROM Accounts AS a
			JOIN AccountsTrips AS atr ON a.Id = atr.AccountId
			JOIN Trips tr ON atr.TripId = tr.Id
			WHERE (a.MiddleName IS NULL AND tr.CancelDate IS NULL)) AS temp
	GROUP BY temp.Id, temp.FullName
	ORDER BY MAX(TripDays) DESC, MIN(TripDays)

