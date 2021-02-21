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
