USE Minions

ALTER TABLE Users								/* for Problem 9 */
	DROP CONSTRAINT PK__Users__3214EC077F24B2D1

ALTER TABLE Users
	ADD CONSTRAINT PK__Users__CombinedIdAndUsername
	PRIMARY KEY (Id, Username)

ALTER TABLE Users								/* for Problem 10 */
	ADD CONSTRAINT CK_Users_PasswordLength
	CHECK(LEN([Password]) >= 5)

ALTER TABLE Users								/* for Problem 11 */
	ADD CONSTRAINT DF_Users_DefaultTime
	DEFAULT GETDATE() FOR LastLoginTime

ALTER TABLE Users								/* for Problem 12 */
	DROP CONSTRAINT [PK__Users__CombinedIdAndUsername]

ALTER TABLE Users
	ADD CONSTRAINT PK_Users_Id
	PRIMARY KEY(Id)

ALTER TABLE Users
	ADD CONSTRAINT CK_Users_UsernameLength
	CHECK(LEN(Username) >= 3)

/*
DELETE FROM Users WHERE Username='Mimi07'

INSERT INTO Users(Username, [Password], ProfilePicture, IsDeleted)
VALUES
	('Mimi34', '777xxx', NULL, 0)
*/