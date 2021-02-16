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
