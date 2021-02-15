-- 03. Update

UPDATE Rooms
	SET Price *= 1.14
	WHERE HotelId IN (5, 7, 9);

-- 04. Delete

DELETE FROM [AccountsTrips]
	WHERE AccountId = 47