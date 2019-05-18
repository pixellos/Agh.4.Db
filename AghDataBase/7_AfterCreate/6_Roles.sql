USE [AghDataBase]
GO


CREATE ROLE [customerservice]
GRANT SELECT ON GetAttendantsAtConferenceDay TO customerservice
GRANT SELECT ON GetAttendantsAtWorkshopsOnConferenceDay TO customerservice
GRANT EXECUTE ON GetConferenceStart TO customerservice
GRANT EXECUTE ON GetIndividualClientOrThrow TO customerservice
GRANT EXECUTE ON GetConferenceWithPriceAccordingToDate TO customerservice
GRANT EXECUTE ON LoyalClientsView TO customerservice
GRANT EXECUTE ON AddAddress TO customerservice
GRANT EXECUTE ON AddClient TO customerservice
GRANT EXECUTE ON AddCorporateClient TO customerservice
GRANT EXECUTE ON AddStudent TO customerservice
GRANT EXECUTE ON AssignEmployerToEmployee TO customerservice
GRANT EXECUTE ON MakeReservation TO customerservice
GRANT EXECUTE ON MakeReservationCorporation TO customerservice
GRANT EXECUTE ON PayForReservationWithADate TO customerservice
GRANT EXECUTE ON DeleteUnpaidReservations TO customerservice
GRANT EXECUTE ON ReserveAPlaceForAWorkshop TO customerservice

CREATE ROLE [organizer]
GRANT SELECT ON GetAttendantsAtConferenceDay TO customerservice
GRANT SELECT ON GetAttendantsAtWorkshopsOnConferenceDay TO customerservice
GRANT SELECT ON GetConferenceStart TO customerservice
GRANT SELECT ON LoyalClientsView TO customerservice
GRANT EXECUTE ON DeleteUnpaidReservations TO customerservice
GRANT EXECUTE ON AddPriceToConference TO customerservice
GRANT EXECUTE ON AddConference TO customerservice
GRANT EXECUTE ON AddConferenceDay TO customerservice
GRANT EXECUTE ON AddWorkshop TO customerservice
GRANT EXECUTE ON AddPriceToWorkshop TO customerservice


GO


