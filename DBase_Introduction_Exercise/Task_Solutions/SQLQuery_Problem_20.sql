--CREATE DATABASE SoftUni

-- Data from Problem 16. Create SoftUni Database

CREATE TABLE Towns 
(
	Id INT PRIMARY KEY IDENTITY NOT NULL, 
	[Name] NVARCHAR(50) NOT NULL
)
CREATE TABLE Addresses 
(
	Id INT PRIMARY KEY IDENTITY NOT NULL, 
	AddressText NVARCHAR(200) NOT NULL, 
	TownId INT FOREIGN KEY REFERENCES Towns(Id) NOT NULL
)
CREATE TABLE Departments 
(
	Id INT PRIMARY KEY IDENTITY NOT NULL, 
	[Name] NVARCHAR(50) NOT NULL
)
CREATE TABLE Employees 
(
	Id INT PRIMARY KEY IDENTITY NOT NULL, 
	FirstName NVARCHAR(50) NOT NULL, 
	MiddleName NVARCHAR(50), 
	LastName NVARCHAR(50) NOT NULL, 
	JobTitle NVARCHAR(50) NOT NULL, 
	DepartmentId INT FOREIGN KEY REFERENCES Departments(Id) NOT NULL, 
	HireDate DATE NOT NULL, 
	Salary DECIMAL(7, 2) NULL, 
	AddressId INT FOREIGN KEY REFERENCES Addresses(Id) NULL
)

-- Data from Problem 18. Basic Insert

INSERT INTO Towns ([Name])
	VALUES
		('Sofia'), 
		('Plovdiv'),
		('Varna'),
		('Burgas')

INSERT INTO Departments ([Name])
	VALUES
		('Engineering'),
		('Sales'), 
		('Marketing'), 
		('Software Development'),
		('Quality Assurance')

INSERT INTO Employees (FirstName, MiddleName, LastName, JobTitle, DepartmentId, HireDate, Salary)
	VALUES
		('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00),
		('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00),
		('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25),
		('Georgi', 'Teziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00),
		('Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88)

-- Data from Problem 19. Basic Select All Fields

SELECT * FROM Towns
SELECT * FROM Departments
SELECT * FROM Employees

-- Problem 20. Basic Select All Fields and Order Them

SELECT * FROM Towns
	ORDER BY [Name]

SELECT * FROM Departments
	ORDER BY [Name]

SELECT * FROM Employees
	ORDER BY [Salary] DESC
