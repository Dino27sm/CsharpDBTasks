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

-- 08. Metropolis

SELECT TOP(10) Id, [Name] AS City, CountryCode AS Country, Accounts
	FROM (SELECT c.Id, a.CityId, c.[Name], c.CountryCode, COUNT(*) AS Accounts
			FROM Cities AS c
			JOIN Accounts AS a ON a.CityId = c.Id
			GROUP BY c.Id, a.CityId, c.[Name], c.CountryCode) AS temp

	ORDER BY Accounts DESC

-- 09. Romantic Getaways

SELECT a.Id, a.Email, c.[Name] AS City, COUNT(*) AS Trips
	FROM Accounts AS a
	JOIN AccountsTrips AS atr ON atr.AccountId = a.Id
	JOIN Trips AS tr ON tr.Id = atr.TripId
	JOIN Rooms AS r ON r.Id = tr.RoomId
	JOIN Hotels AS h ON h.Id = r.HotelId
	JOIN Cities AS c ON c.Id = h.CityId
	WHERE h.CityId = a.CityId
	GROUP BY a.Id, a.Email, c.[Name]
	ORDER BY COUNT(*) DESC, a.Id

