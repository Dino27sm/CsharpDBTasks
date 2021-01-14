CREATE DATABASE CarRental
USE CarRental

CREATE TABLE Categories 
(
	Id INT PRIMARY KEY NOT NULL, 
	CategoryName NVARCHAR(30) NOT NULL, 
	DailyRate TINYINT NULL, 
	WeeklyRate TINYINT NULL, 
	MonthlyRate TINYINT NULL, 
	WeekendRate TINYINT NULL
)
CREATE TABLE Cars 
(
	Id INT PRIMARY KEY NOT NULL, 
	PlateNumber VARCHAR(10) NOT NULL, 
	Manufacturer NVARCHAR(50) NULL, 
	Model NVARCHAR(50) NOT NULL, 
	CarYear DATE NOT NULL, 
	CategoryId INT FOREIGN KEY REFERENCES Categories(iD) NOT NULL, 
	Doors TINYINT NOT NULL, 
	Picture VARBINARY(MAX) NULL
		CHECK(DATALENGTH(Picture) <= 800 * 1024), 
	Condition NVARCHAR(50) NULL, 
	Available BIT NOT NULL
)
CREATE TABLE Employees 
(
	Id INT PRIMARY KEY NOT NULL, 
	FirstName NVARCHAR(50) NOT NULL, 
	LastName NVARCHAR(50) NOT NULL, 
	Title NVARCHAR(10) NULL, 
	Notes NVARCHAR(500) NULL
)
CREATE TABLE Customers
(
	Id INT PRIMARY KEY NOT NULL, 
	DriverLicenceNumber NVARCHAR(20) NOT NULL, 
	FullName NVARCHAR(100) NOT NULL, 
	[Address] NVARCHAR(200) NOT NULL, 
	City NVARCHAR(15) NOT NULL, 
	ZIPCode NVARCHAR(10) NULL, 
	Notes NVARCHAR(500) NULL
)

CREATE TABLE RentalOrders
(
	Id INT PRIMARY KEY NOT NULL, 
	EmployeeId INT FOREIGN KEY REFERENCES EmployeeS(iD) NOT NULL, 
	CustomerId INT FOREIGN KEY REFERENCES Customers(iD) NOT NULL, 
	CarId INT FOREIGN KEY REFERENCES Cars(iD) NOT NULL, 
	TankLevel TINYINT NOT NULL, 
	KilometrageStart INT NOT NULL, 
	KilometrageEnd INT NOT NULL, 
	TotalKilometrage INT NOT NULL, 
	StartDate DATETIME2 NOT NULL, 
	EndDate DATETIME2 NOT NULL, 
	TotalDays TINYINT , 
	RateApplied DECIMAL(6, 2) NOT NULL, 
	TaxRate DECIMAL(6, 2) NOT NULL, 
	OrderStatus BIT NOT NULL, 
	Notes NVARCHAR(500) NULL
)
INSERT INTO Categories(Id, CategoryName, DailyRate, [WeeklyRate], [MonthlyRate], [WeekendRate])
	VALUES
		(1, 'Category_01', 8, 7, 6, 9),
		(2, 'Category_02', 2, 8, 3, 12),
		(3, 'Category_03', 12, 17, 19, 18)

INSERT INTO Cars(Id, [PlateNumber], [Manufacturer], [Model], [CarYear], [CategoryId], 
	[Doors], [Picture], [Condition], [Available])
	VALUES
		(1, 'Plate_01', NULL, 'Model_01', '2015-07-19', 1, 3, NULL, NULL, 1),
		(2, 'Plate_02', NULL, 'Model_02', '2016-07-19', 2, 5, NULL, NULL, 0),
		(3, 'Plate_03', NULL, 'Model_03', '2017-07-19', 3, 5, NULL, 'Good', 1)

INSERT INTO Employees (Id, FirstName, LastName, Title, Notes)
	VALUES
		(1, 'FirstName_01', 'LastName_01', 'Mr', NULL),
		(2, 'FirstName_02', 'LastName_02', 'Miss', NULL),
		(3, 'FirstName_03', 'LastName_02', 'Mr', NULL)

INSERT INTO Customers (Id, DriverLicenceNumber, FullName, Address, City, ZIPCode, Notes)
	VALUES
		(1, 'License_01', 'Full Name_01', 'Address_01', 'Sofia', 'ZH1700', NULL),
		(2, 'License_02', 'Full Name_02', 'Address_02', 'Sofia', NULL, NULL),
		(3, 'License_03', 'Full Name_03', 'Address_03', 'Sofia', NULL, NULL)

INSERT INTO RentalOrders (Id, EmployeeId, CustomerId, CarId, TankLevel, 
	KilometrageStart, KilometrageEnd, TotalKilometrage, StartDate, EndDate, 
	TotalDays, RateApplied, TaxRate, OrderStatus, Notes)
	VALUES
		(1, 1, 3, 2, 40, 24000, 25000, 25000, '2019-06-01 12:00', '2019-06-07 12:00', 6, 30.00, 180, 1, NULL),
		(2, 2, 1, 3, 50, 25000, 26000, 26000, '2019-06-02 12:00', '2019-06-08 12:00', 6, 40.00, 240, 1, NULL),
		(3, 3, 2, 1, 60, 32000, 34000, 34000, '2019-06-03 12:00', '2019-06-09 12:00', 6, 50.00, 300, 1, NULL)
