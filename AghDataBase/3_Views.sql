/*
    Registered clients for conference (conferenceId)
	Person registered for conference (conferenceId)
	Person that (not?) paid a ticked for (conferenceId)

	*/


CREATE OR ALTER VIEW LoyalClientsView
  AS
	SELECT TOP 1000 IC.FirstName, IC.LastName, CC.CompanyName, sum(RP.Amount) as TotalPaid
		FROM IndividualClients IC
	RIGHT JOIN Clients C
		ON IC.Id = C.Id
	LEFT JOIN CorporateClients CC
		ON CC.Id = C.Id
	INNER JOIN Reservations R
		ON C.Id = R.ClientId
	INNER JOIN ReservationPayments RP
		ON R.Id = RP.Id
	GROUP BY IC.FirstName, IC.LastName, CC.CompanyName
	ORDER BY TotalPaid DESC;

