-- 02. Insert
--USE master
--BACKUP DATABASE ColonialJourney TO DISK = 'E:\Soft-Uni\BackUpDB\ColonialJourney_backup.bak'

INSERT INTO Planets ([Name])
VALUES
	('Mars'),
	('Earth'),
	('Jupiter'),
	('Saturn')

INSERT INTO Spaceships ([Name], [Manufacturer], [LightSpeedRate])
VALUES
	('Golf', 'VW', 3),
	('WakaWaka', 'Wakanda', 4),
	('Falcon9', 'SpaceX', 1),
	('Bed' , 'Vidolov', 6)

-- 03. Update

UPDATE [Spaceships]
	SET [LightSpeedRate] += 1
	WHERE Id BETWEEN 8 AND 12

-- 04. Delete

DELETE FROM [TravelCards] WHERE JourneyId BETWEEN 1 AND 3
DELETE FROM Journeys WHERE Id BETWEEN 1 AND 3

-- 05. Select All Military Journeys

-----  FIRST CLOSE ALL BATCH FILES THAT USE DATABASE ColonialJourney
--GO
--USE master
--DROP DATABASE ColonialJourney
--RESTORE DATABASE ColonialJourney FROM DISK = 'E:\Soft-Uni\BackUpDB\ColonialJourney_backup.bak'


SELECT Id, FORMAT(JourneyStart, 'dd/MM/yyyy') AS JourneyStart
			,FORMAT(JourneyEnd, 'dd/MM/yyyy') AS JourneyEnd
	FROM Journeys
	WHERE Purpose = 'Military'
	ORDER BY JourneyStart

-- 06. Select All Pilots

SELECT c.Id, (FirstName + ' ' + LastName) AS FullName
	FROM Colonists AS c
	JOIN TravelCards AS tc ON tc.ColonistId = c.Id
	WHERE JobDuringJourney = 'Pilot'
	ORDER BY c.Id

-- 07. Count Colonists
--------------------------------  THIS SOLUTION IS NOT ACCEPTED !!!  -------------------
SELECT COUNT(*) AS [Count]
	FROM TravelCards AS tc
	JOIN Colonists AS c ON c.Id = tc.ColonistId
	JOIN Journeys AS j ON tc.JourneyId = j.Id
	WHERE j.Purpose = 'Technical'

------ THIS SOLUTION IS ACCEPTED !!!  SHOULD START FROM Colonists Table !!! ---
SELECT COUNT(*) AS [Count]
	FROM Colonists AS c
	JOIN TravelCards AS tc ON tc.ColonistId = c.Id
	JOIN Journeys AS j ON j.Id = tc.JourneyId
	WHERE j.Purpose = 'Technical'

-- 08. Select Spaceships With Pilots

SELECT s.[Name], s.Manufacturer
	FROM Spaceships AS s
	JOIN Journeys AS j ON j.SpaceshipId = s.Id
	JOIN TravelCards AS tc ON tc.JourneyId = j.Id
	JOIN Colonists AS c ON c.Id = tc.ColonistId
	WHERE tc.JobDuringJourney = 'Pilot'
			AND (DATEDIFF(YEAR, c.BirthDate, '01/01/2019') <= 30)
	ORDER BY s.[Name]

-- 09. Planets And Journeys

SELECT p.[Name] AS PlanetName, COUNT(*) AS JourneysCount
	FROM Planets AS p
	JOIN Spaceports AS sp ON sp.PlanetId = p.Id
	JOIN Journeys AS j ON j.DestinationSpaceportId = sp.Id
	GROUP BY p.[Name]
	ORDER BY COUNT(*) DESC, p.[Name]

-- 10. Select Special Colonists

SELECT tmp.JobDuringJourney, (tmp.FirstName + ' ' + tmp.LastName) AS FullName, tmp.JobRank
FROM (SELECT tc.JobDuringJourney, c.FirstName, c.LastName
       ,DENSE_RANK() OVER (PARTITION BY tc.JobDuringJourney ORDER BY c.BirthDate ASC) AS JobRank
    FROM Colonists AS c
    JOIN TravelCards AS tc ON c.Id = tc.ColonistId) AS tmp
    WHERE tmp.JobRank = 2

-- 11. Get Colonists Count

GO
CREATE FUNCTION dbo.udf_GetColonistsCount (@PlanetName VARCHAR (30))
RETURNS INT
AS
BEGIN
RETURN (SELECT COUNT(*)
			FROM Colonists AS c
			JOIN TravelCards AS tc ON tc.ColonistId = c.Id
			JOIN Journeys AS j ON j.Id = tc.JourneyId
			JOIN Spaceports AS sp ON sp.Id = j.DestinationSpaceportId
			JOIN Planets AS p ON  p.Id = sp.PlanetId
			WHERE p.[Name] = @PlanetName)
END
GO
SELECT dbo.udf_GetColonistsCount('Otroyphus')

