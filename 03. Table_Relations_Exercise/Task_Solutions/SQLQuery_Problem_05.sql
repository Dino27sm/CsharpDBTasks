CREATE DATABASE OnlineStoreDatabase
USE OnlineStoreDatabase

CREATE TABLE Cities
(
	CityID INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	[Name] NVARCHAR(50) NOT NULL
)
CREATE TABLE Customers
(
	CustomerID INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	[Name] NVARCHAR(50) NOT NULL,
	Birthday DATE NULL,
	CityID INT FOREIGN KEY REFERENCES Cities(CityID)
)
CREATE TABLE Orders
(
	OrderID INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID)
)
---------------------------------------------------------------------------
CREATE TABLE ItemTypes
(
	ItemTypeID INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	[Name] NVARCHAR(50) NOT NULL
)
CREATE TABLE Items
(
	ItemID INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	[Name] NVARCHAR(50) NOT NULL,
	ItemTypeID INT FOREIGN KEY REFERENCES ItemTypes(ItemTypeID)
)
----------------------------------------------------------------------------
CREATE TABLE OrderItems
(
	OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
	ItemID INT FOREIGN KEY REFERENCES Items(ItemID),
	CONSTRAINT PK_OrderItems_CompositKey PRIMARY KEY(OrderID, ItemID)
)
