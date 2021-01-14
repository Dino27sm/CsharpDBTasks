CREATE DATABASE Movies
USE Movies

CREATE TABLE Directors
(
	Id INT PRIMARY KEY NOT NULL,
	DirectorName NVARCHAR(100) NOT NULL,
	Notes NVARCHAR(2000) NULL
)
CREATE TABLE Genres
(
	Id INT PRIMARY KEY NOT NULL,
	GenreName NVARCHAR(100) NOT NULL,
	Notes NVARCHAR(2000) NULL
)
CREATE TABLE Categories
(
	Id INT PRIMARY KEY NOT NULL,
	CategoryName NVARCHAR(100) NOT NULL,
	Notes NVARCHAR(2000) NULL
)
CREATE TABLE Movies 
(
	Id INT PRIMARY KEY NOT NULL,
	Title NVARCHAR(100) NOT NULL,
	DirectorId INT FOREIGN KEY REFERENCES Directors(Id) NOT NULL,
	CopyrightYear INT NULL,
	[Length] VARBINARY(MAX) NULL,
	GenreId INT FOREIGN KEY REFERENCES Genres(Id) NOT NULL,
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
	Rating TINYINT NULL,
	Notes NVARCHAR(2000) NULL
)

INSERT INTO Directors(Id, DirectorName, Notes)
VALUES
	(1, 'Director_01', 'Director_01 notes'),
	(2, 'Director_02', 'Director_02 notes'),
	(3, 'Director_03', 'Director_03 notes'),
	(4, 'Director_04', 'Director_04 notes'),
	(5, 'Director_05', 'Director_05 notes')

INSERT INTO Genres(Id, GenreName, Notes)
VALUES
	(1, 'Genre_01', 'Genre_01 notes'),
	(2, 'Genre_02', 'Genre_02 notes'),
	(3, 'Genre_03', 'Genre_03 notes'),
	(4, 'Genre_04', 'Genre_04 notes'),
	(5, 'Genre_05', 'Genre_05 notes')

INSERT INTO Categories(Id, CategoryName, Notes)
VALUES
	(1, 'Category_01', 'Category_01 notes'),
	(2, 'Category_02', 'Category_02 notes'),
	(3, 'Category_03', 'Category_03 notes'),
	(4, 'Category_04', 'Category_04 notes'),
	(5, 'Category_05', 'Category_05 notes')

INSERT INTO Movies(Id, Title, DirectorId, CopyrightYear, [Length], GenreId, CategoryId, Rating, Notes)
VALUES
	(1, 'Title_01', 1, 1981, 2000, 1, 5, 7, NULL),
	(2, 'Title_02', 2, 1982, 2000, 2, 4, 7, NULL),
	(3, 'Title_03', 3, 1983, 2000, 3, 3, 7, NULL),
	(4, 'Title_04', 4, 1984, 2000, 4, 2, 7, NULL),
	(5, 'Title_05', 5, 1985, 2000, 5, 1, 7, NULL)
