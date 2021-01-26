CREATE DATABASE Minions

USE Minions

CREATE TABLE People
(
	Id INT IDENTITY NOT NULL,
	[Name] NVARCHAR(200) NOT NULL,
	Picture VARBINARY(MAX) NULL
		CHECK(DATALENGTH(Picture) <= 2000 * 1024),  /* Checks if Picture size <= 2 Mb */
	[Height] NUMERIC(3, 2) NULL,
	[Weight] NUMERIC(5, 2) NULL,
	[Gender] CHAR(1) NOT NULL,
	[Birthdate] DATE NOT NULL,
	[Biography] NVARCHAR(MAX) NULL
)
ALTER TABLE People
ADD CONSTRAINT PK_Id
PRIMARY KEY (Id)

INSERT INTO People([Name], [Picture], [Height], [Weight], [Gender], [Birthdate], [Biography])
VALUES
	('Pesho', NULL, 1.85, 97.57, 'm', '1957.12.27', 'Text one'),
	('Denis', NULL, 1.90, 112.76, 'm', '1997.03.13', 'Text two'),
	('Gosho', NULL, 1.75, 82.40, 'm', '1884.10.17', 'Text three'),
	('Mimi', NULL, 1.65, 53.77, 'f', '1973.09.14', 'Text four'),
	('Tanya', NULL, 1.72, 61.43, 'f', '1978.08.07', 'Text five')

TRUNCATE TABLE People