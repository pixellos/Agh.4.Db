/*
	Procedura wykonywana codziennie. 
	Na zapłatę klienci mają tydzień od rezerwacji na konferencję. Jeśli do tego czasu
	nie pojawi się opłata, rezerwacja jest anulowana.
*/
CREATE OR ALTER PROCEDURE DeleteUnpaidReservations
AS

	DELETE R FROM Reservations R
	RIGHT JOIN ReservationPayments RP
		ON R.Id = RP.Id
	WHERE RP.Id IS NULL
		AND DATEADD(week, 1, R.ReservationDate) > GETDATE();

GO	