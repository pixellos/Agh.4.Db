/*
	Procedura wykonywana codziennie. 
	Na zapłatę klienci mają tydzień od rezerwacji na konferencję. Jeśli do tego czasu
	nie pojawi się opłata, rezerwacja jest anulowana.
*/
CREATE OR ALTER PROCEDURE DeleteUnpaidReservation
AS

	DELETE R FROM Reservations R
	INNER JOIN ReservationPayments RP
		ON R.Id = RP.Id

GO	