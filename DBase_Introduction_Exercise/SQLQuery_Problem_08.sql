USE Minions

CREATE TABLE Users
(
	Id BIGINT PRIMARY KEY IDENTITY NOT NULL,
	Username  VARCHAR(30) UNIQUE NOT NULL,
	[Password] VARCHAR(26) NOT NULL,
	ProfilePicture  VARBINARY(MAX) NULL
		CHECK(DATALENGTH(ProfilePicture) <= 900 * 1024),  /* Checks if Picture size <= 900 Kb */
	LastLoginTime DATETIME2 NOT NULL,
	IsDeleted BIT NOT NULL
)
INSERT INTO Users(Username, [Password], ProfilePicture, LastLoginTime, IsDeleted)
VALUES
	('Mimi01', '111asd', NULL, '2020.11.23', 0),
	('Mimi02', '222asd', NULL, '2020.11.23', 1),
	('Mimi03', '333asd', NULL, '2020.11.23', 0),
	('Mimi04', '444asd', NULL, '2020.11.23', 0),
	('Mimi05', '555asd', NULL, '2020.11.23', 1)

SET IDENTITY_INSERT Users ON	/* Allows to insert manualy data into line number with Id deleted before */
SET IDENTITY_INSERT Users OFF