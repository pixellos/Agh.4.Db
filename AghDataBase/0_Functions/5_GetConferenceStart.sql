CREATE FUNCTION GetConferenceStart(	@ConferenceId int)
RETURNS DATETIME
AS
BEGIN
	RETURN (SELECT TOP(1) [Id]
	FROM ConferenceDays
	WHERE ConferenceId = @ConferenceId
	ORDER BY [Date])
END
GO