
CREATE OR ALTER FUNCTION GetIndividualClientOrThrow(@PersonalNumber int)
RETURNS INT
AS
BEGIN

	DECLARE @client_id int;
	SELECT @client_id = Min(Id) FROM IndividualClients WHERE PersonalNumber = @PersonalNumber;

	IF @client_id IS NULL 
	BEGIN
		 RETURN CAST('Client canont be found.' AS INT);
	END	

	RETURN @client_id;
END
GO