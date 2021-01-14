CREATE DATABASE Hotel
USE Hotel

CREATE TABLE Employees 
(
	Id INT PRIMARY KEY NOT NULL, 
	FirstName NVARCHAR(50) NOT NULL, 
	LastName NVARCHAR(50) NOT NULL, 
	Title NVARCHAR(30) NULL, 
	Notes NVARCHAR(500) NULL
)
CREATE TABLE Customers
(
	AccountNumber INT PRIMARY KEY NOT NULL, 
	FirstName NVARCHAR(40) NOT NULL, 
	LastName NVARCHAR(40) NOT NULL, 
	PhoneNumber NVARCHAR(30) NOT NULL, 
	EmergencyName NVARCHAR(40) NULL, 
	EmergencyNumber NVARCHAR(30) NOT NULL, 
	Notes NVARCHAR(500) NULL
)
CREATE TABLE RoomStatus 
(
	RoomStatus NVARCHAR(50) PRIMARY KEY NOT NULL, 
	Notes NVARCHAR(500)
)
CREATE TABLE RoomTypes  
(
	RoomType NVARCHAR(50) PRIMARY KEY NOT NULL, 
	Notes NVARCHAR(500)
)
CREATE TABLE BedTypes  
(
	BedType NVARCHAR(50) PRIMARY KEY NOT NULL, 
	Notes NVARCHAR(500)
)
CREATE TABLE Rooms
(
	RoomNumber SMALLINT PRIMARY KEY NOT NULL, 
	RoomType NVARCHAR(50) FOREIGN KEY REFERENCES RoomTypes(RoomType), 
	BedType NVARCHAR(50) FOREIGN KEY REFERENCES BedTypes(BedType), 
	Rate DECIMAL(5, 2) NOT NULL, 
	RoomStatus NVARCHAR(50) FOREIGN KEY REFERENCES RoomStatus(RoomStatus), 
	Notes NVARCHAR(500)
)
CREATE TABLE Payments
(
	Id INT PRIMARY KEY NOT NULL,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
	PaymentDate DATE NOT NULL,
	AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber) NOT NULL,
	FirstDateOccupied DATE NOT NULL,
	LastDateOccupied DATE NOT NULL,
	TotalDays AS DATEDIFF(DAY, FirstDateOccupied, LastDateOccupied),
	AmountCharged DECIMAL(6, 2) NOT NULL,
	TaxRate DECIMAL(6, 2) NOT NULL,
	TaxAmount AS (CONVERT(DECIMAL(6, 2), AmountCharged * (TaxRate/100))),
	PaymentTotal AS (CONVERT(DECIMAL(6, 2), AmountCharged * (1 + TaxRate/100))),
	Notes NVARCHAR(500)
)
CREATE TABLE Occupancies
(
	Id INT PRIMARY KEY NOT NULL, 
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL, 
	DateOccupied DATE NOT NULL, 
	AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber) NOT NULL, 
	RoomNumber SMALLINT FOREIGN KEY REFERENCES Rooms(RoomNumber) NOT NULL, 
	RateApplied DECIMAL(6, 2) NOT NULL, 
	PhoneCharge DECIMAL(6, 2), 
	Notes NVARCHAR(500)
)

INSERT INTO Employees (Id, FirstName, LastName, Title, Notes)
	VALUES 
		(1, 'FName_01','LName_01','Employee_01', 'Pensioner'),
		(2, 'FName_02','LName_02','Employee_02', NULL),
		(3, 'FName_03','LName_03','Employee_03', NULL)

INSERT INTO Customers ([AccountNumber], FirstName, LastName, PhoneNumber, EmergencyName, EmergencyNumber, Notes)
	VALUES 
		(1, 'FName_01', 'LName_01', '+359888113456', 'Em_Name_01', '+359888113451', 'Mother wit kids'),
		(2, 'FName_02', 'LName_02', '+359888223456', 'Em_Name_02', '+359888113452', NULL),
		(3, 'FName_03', 'LName_03', '+359888333456', 'Em_Name_03', '+359888113453', NULL)

INSERT INTO RoomStatus (RoomStatus, Notes)
	VALUES 
		('Not Ready', 'Problem with shower!'),
	    ('Ready', NULL),
	    ('Occupied', NULL)

INSERT INTO RoomTypes (RoomType, Notes)
	VALUES
		('Single Room', 'For 1 person'),
		('Double Room', 'Whith two beds'),
		('Apartment', 'With 2 bedrooms')

INSERT INTO BedTypes (BedType, Notes)
	VALUES
		('Single Bed', NULL),
		('Double Bed', NULL),
		('King size bed', NULL)

INSERT INTO Rooms (RoomNumber, RoomType, BedType, Rate, RoomStatus, Notes)
	VALUES
		(101, 'Single Room', 'Single Bed', 60.00, 'Occupied', NULL),
		(102, 'Double Room', 'Double Bed', 80.00, 'Occupied', NULL),
		(103, 'Single Room', 'Single Bed', 60.00, 'Not Ready', NULL)

INSERT INTO Payments (Id, EmployeeId, PaymentDate, AccountNumber, FirstDateOccupied, 
	LastDateOccupied, AmountCharged, TaxRate, Notes)
	VALUES
		(1, 1, '2020-01-04 12:00', 1, '2019-12-25 12:00', '2020-01-04 12:00', 300.00, 20.00, 'Text 1'),
		(2, 2, '2020-01-04 12:00', 2, '2019-12-25 12:00', '2020-01-04 12:00', 300.00, 20.00, 'Text 2'),
		(3, 3, '2020-01-04 12:00', 3, '2019-12-25 12:00', '2020-01-04 12:00', 300.00, 20.00, 'Text 3')

INSERT INTO Occupancies (Id, EmployeeId, DateOccupied, AccountNumber, RoomNumber, 
	RateApplied, PhoneCharge, Notes)
	VALUES
		(1, 3, '2019-12-25 12:00', 1, 101, 40.00, 25.00, 'Text to read'),
		(2, 2, '2019-12-25 12:00', 2, 102, 40.00, NULL, 'Text to read'),
		(3, 1, '2019-12-25 12:00', 3, 103, 40.00, 10.00, 'Text to read')
