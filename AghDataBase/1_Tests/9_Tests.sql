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

EXEC AddClient 'Mateusz', 'Popielarz', '97010207000', '+48 123456789', 'Brodzińskiego', 5, 1, '38-400', 'Krosno', 'Podkarpacie', 'Polska';
EXEC AddClient 'Mateusz', 'Popielarz', '97010207001', '+48 123456789', 'Brodzińskiego', 5, 1, '38-400', 'Krosno', 'Podkarpacie', 'Polska';
EXEC AddClient 'Mateusz', 'Popielarz', '97010207002', '+48 123456789', 'Mickiewicza', 4, 1, '38-400', 'Krosno', 'Podkarpacie', 'Polska';


SELECT * from Countries
SELECT * from Provinces
SELECT * from Cities
SELECT * from Streets
SELECT * from Buildings
SELECT * FROM Clients
SELECT * FROM CorporateClients
SELECT * FROM IndividualClients