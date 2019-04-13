/* SAME OBJECT AS PREVIOUS TEST, SHOULD BE CRAETED */
DECLARE @confitura int;
EXEC @confitura = AddConference '1234561', 'ConfituraPL',0 , 500, 'Konferencyjna', 14, 7, '32-234', 'Kraków', 'Małopolskie', 'Polska';


DECLARE @RAISE int;
/*Will fail on adding not existing individual client to reservation*/
BEGIN TRY  
	EXEC MakeReservation 'NOTEXISTING', @confitura;
	SET @RAISE = CAST('Raise error.' AS INT);
END TRY  
BEGIN CATCH  
END CATCH  

/*Will fail on adding student with same id */
BEGIN TRY  
	EXEC AddStudent 'NotExisting2', 'NotExisting', '97010207999','600000', '+48 123456689', 'Mickiewicza', 4, 1, '38-400', 'Krosno', 'Podkarpacie', 'Polska';
	SET @RAISE = CAST('Raise error.' AS INT);
END TRY  
BEGIN CATCH  
END CATCH  
