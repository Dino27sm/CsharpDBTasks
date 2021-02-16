CREATE OR ALTER FUNCTION udf_GetAvailableRoom(@HotelId INT, @Date DATE, @People INT)
RETURNS NVARCHAR(MAX)
AS
BEGIN
DECLARE @stringOut NVARCHAR(MAX);
SET @stringOut = (SELECT TOP(1) 'Room ' + CAST(r.Id AS VARCHAR) + ': ' 
				+ r.[Type] + ' (' + CAST(r.Beds AS VARCHAR) + ' beds) - $'
				+ CAST((h.BaseRate + r.Price) * @People AS VARCHAR)
	FROM Hotels AS h
	JOIN Rooms AS r ON r.HotelId = h.Id
	
	WHERE (h.Id = @HotelId)
			AND (r.Beds >= @People) AND
			NOT EXISTS(SELECT * FROM Trips AS tr WHERE tr.RoomId = r.Id
			AND CancelDate IS NULL
			AND @Date BETWEEN ArrivalDate AND ReturnDate)
	ORDER BY (h.BaseRate + r.Price) * @People DESC)
IF (@stringOut IS NULL)
	RETURN 'No rooms available'
RETURN @stringOut;
END
GO
--------------------------------------------------------------------
SELECT dbo.udf_GetAvailableRoom(112, '2011-12-17', 2)
SELECT dbo.udf_GetAvailableRoom(94, '2015-07-26', 3)
--------------------------------------------------------------------
GO
CREATE OR ALTER FUNCTION udf_GetAvailableRoom(@HotelId INT, @Date DATE, @People INT)
RETURNS NVARCHAR(MAX)
AS
BEGIN
DECLARE @roomID INT;
SET @roomID = (SELECT TOP(1) r.Id 
				FROM Rooms AS r
				JOIN Trips AS tr ON tr.RoomId = r.Id
				WHERE (@Date NOT BETWEEN tr.ArrivalDate AND tr.ReturnDate)
					AND (YEAR(@Date) = YEAR(tr.ArrivalDate))
					AND (tr.CancelDate IS NULL)
					AND (r.Beds >= @People)
					AND (r.HotelId = @HotelId)
				ORDER BY r.Price DESC
				)
IF (@roomID IS NULL)
	RETURN 'No rooms available'

DECLARE @roomType NVARCHAR(20) = (SELECT [Type] FROM Rooms WHERE Id = @roomID);
DECLARE @roomBeds INT = (SELECT Beds FROM Rooms WHERE Id = @roomID);
DECLARE @hotelBaseRate DECIMAL(17, 2) = (SELECT BaseRate FROM Hotels WHERE Id = @HotelId);
DECLARE @roomPrice DECIMAL(17, 2) = (SELECT Price FROM Rooms WHERE Id = @roomID);

DECLARE @totalPrice DECIMAL(17, 2) = (@hotelBaseRate + @roomPrice) * @People;

RETURN CONCAT('Room ', @roomID, ': ', @roomType, ' (', @roomBeds, ' beds) - $', @totalPrice);
END

--------------------------------------------------------------------------
-- 12. Switch Room
GO
CREATE OR ALTER PROC usp_SwitchRoom(@TripId INT, @TargetRoomId INT)
AS
	DECLARE @tripHotelID INT = (SELECT r.HotelId
					FROM Trips AS tr
					JOIN Rooms AS r ON tr.RoomId = r.Id
					WHERE tr.Id = @TripId)
	DECLARE @tripRoomID INT = (SELECT RoomId
					FROM Trips
					WHERE Id = @TripId)
	DECLARE @targetRoomHotelID INT = (SELECT HotelId FROM Rooms WHERE Id = @TargetRoomId)

	IF (@targetRoomHotelID != @tripHotelID)
		THROW 50001, 'Target room is in another hotel!', 1;

	DECLARE @targetRoomBeds INT = (SELECT Beds FROM Rooms WHERE Id = @TargetRoomId);
	DECLARE @tripPersons INT = (SELECT COUNT(AccountId) FROM AccountsTrips WHERE TripId = @TripId);

	IF (@targetRoomBeds < @tripPersons)
		THROW 50002, 'Not enough beds in target room!', 1;

UPDATE Trips
	SET RoomId = @TargetRoomId
	WHERE Id = @TripId

GO
----------------------------- For testing ------------------------------
EXEC usp_SwitchRoom 10, 11
EXEC usp_SwitchRoom 10, 7
EXEC usp_SwitchRoom 10, 8
------------------------------------------------------------------------
