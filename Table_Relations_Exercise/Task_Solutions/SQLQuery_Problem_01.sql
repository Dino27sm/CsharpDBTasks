CREATE DATABASE OneToOneRelationship
USE OneToOneRelationship

CREATE TABLE Passports
(
	PassportID INT PRIMARY KEY IDENTITY(101, 1) NOT NULL,
	PassportNumber NVARCHAR(50) NOT NULL
)
CREATE TABLE Persons
(
	PersonID INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	FirstName NVARCHAR(50) NOT NULL,
	Salary DECIMAL(7, 2) NULL,
	PassportID INT FOREIGN KEY REFERENCES Passports(PassportID) NULL
)
INSERT INTO Passports (PassportNumber)
	VALUES
		('N34FG21B'),
		('K65LO4R7'),
		('ZE657QP2')

INSERT INTO Persons (FirstName, Salary, PassportID)
	VALUES
		('Roberto', 43300.00, 102),
		('Tom', 56100.00, 103),
		('Yana', 60200.00, 101)

ALTER TABLE Persons
	ADD CONSTRAINT UN_Id_Persons_PassportID
	UNIQUE(PassportID)

-- DROP TABLE Persons
-- DROP TABLE Passports
