CREATE DATABASE OneToManyRelationship
USE OneToManyRelationship

CREATE TABLE Manufacturers
(
	ManufacturerID INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	[Name] NVARCHAR(50) NOT NULL,
	[EstablishedOn] DATE NULL
)
CREATE TABLE Models
(
	ModelID INT PRIMARY KEY IDENTITY(101, 1) NOT NULL,
	[Name] NVARCHAR(50) NOT NULL,
	ManufacturerID INT FOREIGN KEY REFERENCES Manufacturers(ManufacturerID) NULL
)
INSERT INTO Manufacturers([Name], EstablishedOn)
	VALUES
		('BMW', '07/03/1916'),
		('Tesla', '01/01/2003'),
		('Lada', '01/05/1966')

INSERT INTO Models([Name], ManufacturerID)
	VALUES
		('X1', 1),
		('i6', 1),
		('Model S', 2),
		('Model X', 2),
		('Model 3', 2),
		('Nova', 3)
