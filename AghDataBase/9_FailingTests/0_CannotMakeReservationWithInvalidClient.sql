/* SAME OBJECT AS PREVIOUS TEST, SHOULD BE CRAETED */
DECLARE @confitura int;
EXEC @confitura = AddConference '1234561', 'ConfituraPL',0 , 500, 'Konferencyjna', 14, 7, '32-234', 'Kraków', 'Polska';



DECLARE @RAISE int;
/*Will fail on adding not existing individual client to reservation*/
	EXEC MakeReservation 'NOTEXISTING', @confitura;
	SET @RAISE = CAST('Raise error.' AS INT);
