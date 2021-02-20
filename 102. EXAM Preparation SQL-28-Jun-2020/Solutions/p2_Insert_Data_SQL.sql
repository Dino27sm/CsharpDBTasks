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

