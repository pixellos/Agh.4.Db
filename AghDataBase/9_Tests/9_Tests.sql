/*Will add a street 5/5 38-400 City, Provice, Country*/
EXEC AddAddress 'street', 5,5,'38-400','City', 'Province', 'Country';

/*Will add a street 6/5 38-400 City, Provice, Country  -- Additional building*/
EXEC AddAddress 'street', 5,5,'38-400','City', 'Province', 'Country';

/*Will add a street 6/5 38-400 City, Provice, Country  -- Whole set in another country*/
EXEC AddAddress 'street', 5,5,'38-400','City', 'Province', 'AnotherCountry';

/*Will add a street 6/5 38-400 City, Provice, Country  -- Whole set in another country*/
EXEC AddAddress 'AnotherStreet', null, 5,'38-400','City', 'Province', 'AnotherCountry';

EXEC AddCorporateClient 'Company', '1234567898876', '+48123456789', 'AnotherStreet', null, 5 ,'38-400','City', 'Province', 'AnotherCountry';


EXEC AddCorporateClient 'ForteDigital', '000000000', '+48 123456789', 'UlicaForte', 10, 6 ,'12-122','Kraków', 'Małopolskie', 'Polska';
EXEC AddCorporateClient 'PowerShellPl', '1234561', '+48 143456789', 'Ulicapower', null, 6 ,'12-122','Kraków', 'Małopolskie', 'Polska';
EXEC AddCorporateClient 'ForteDigital2', '000000002', '+48 111111111', 'UlicaForte', 10, 6 ,'12-122','Kraków', 'Małopolskie', 'Polska';

EXEC AddClient 'Mateusz', 'Popielarz', '97010207000', '+48 111111112', 'Brodzińskiego', 5, 1, '38-400', 'Krosno', 'Podkarpacie', 'Polska';
EXEC AddClient 'Mateusz', 'Popielarz', '97010207001', '+48 111111112', 'Brodzińskiego', 5, 1, '38-400', 'Krosno', 'Podkarpacie', 'Polska';
EXEC AddClient 'Mateusz', 'Popielarz', '97010207002', '+48 111111112', 'Mickiewicza', 4, 1, '38-400', 'Krosno', 'Podkarpacie', 'Polska';

EXEC AddStudent 'Mateusz', 'Popielarz', '97010207003','600988', '+48 123456789', 'Mickiewicza', 4, 1, '38-400', 'Krosno', 'Podkarpacie', 'Polska';
EXEC AddStudent 'NotExisting', 'NotExisting', '97010207999','600000', '+48 123456680', 'Mickiewicza2', 4, 1, '38-400', 'Krosno', 'Podkarpacie', 'Polska';

EXEC AssignEmployerToEmployee '1234561', 'Associate', 'Mateusz', 'Popielarz', '97010207002', '+48 111111112', 'Mickiewicza', 4, 1, '38-400', 'Krosno', 'Podkarpacie', 'Polska';
EXEC AssignEmployerToEmployee '1234561', 'Associate', 'Mateusz', 'Popielarz', '97010207002', '+48 111111112', 'Mickiewicza', 4, 1, '38-400', 'Krosno', 'Podkarpacie', 'England';

DECLARE @confitura int;
EXEC @confitura = AddConference '1234561', 'ConfituraPL',0 , 500, 'Konferencyjna', 14, 7, '32-234', 'Kraków', 'Małopolskie', 'Polska';

EXEC AddConference '1234561', 'ConfituraStudent', 100, 800, 'Konferencyjna', 14, 7, '32-234', 'Kraków', 'Małopolskie', 'Polska';

EXEC MakeReservation '97010207001', @confitura;
EXEC MakeReservation '97010207001', @confitura;
EXEC MakeReservation '97010207002', @confitura;

BEGIN TRY  
EXEC MakeReservation 'NOTEXISTING', @confitura;
DECLARE @RAISE int = CAST('Raise error.' AS INT);
END TRY  
BEGIN CATCH  
END CATCH  

--/*Will fail on adding student with same id */
--BEGIN TRY  
--	EXEC AddStudent 'NotExisting2', 'NotExisting', '97010207999','600000', '+48 123456689', 'Mickiewicza', 4, 1, '38-400', 'Krosno', 'Podkarpacie', 'Polska';
--END TRY  
--BEGIN CATCH  
--	PRINT N'TEST FAILED';
--END CATCH  