/*Good pesel, wrong date*/
EXEC AddClient 'Mateusz', 'Popielarz', '97019907002', '+48 111111112', 'Mickiewicza', 4, 1, '38-400', 'Krosno', 'Podkarpacie', 'Polska';


GO 


EXEC dbo.MakeReservationCorporation '000000000', 1, 2
