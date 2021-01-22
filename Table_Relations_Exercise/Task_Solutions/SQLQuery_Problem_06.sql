CREATE DATABASE UniversityDatabase
USE UniversityDatabase

CREATE TABLE Majors
(
	MajorID INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	[Name] NVARCHAR(50) NOT NULL
)
CREATE TABLE Students
(
	StudentID INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	StudentNumber NVARCHAR(50) NOT NULL,
	StudentName NVARCHAR(50) NOT NULL,
	MajorID INT FOREIGN KEY REFERENCES Majors(MajorID)
)
CREATE TABLE Payments
(
	PaymentID INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	PaymentDate DATE NOT NULL,
	PaymentAmount DECIMAL(12, 2),
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID)
)
-----------------------------------------------------------------
CREATE TABLE Subjects
(
	SubjectID INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	SubjectName NVARCHAR(50) NOT NULL
)
-----------------------------------------------------------------
CREATE TABLE Agenda
(
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
	SubjectID INT FOREIGN KEY REFERENCES Subjects(SubjectID),
	CONSTRAINT PK_Agenda_CompositKey PRIMARY KEY(StudentID, SubjectID)
)
