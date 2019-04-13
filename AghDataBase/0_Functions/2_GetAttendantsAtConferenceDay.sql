CREATE FUNCTION GetAttendantsAtConferenceDay (
	@ConferenceId int,
	@ConferenceDay int
	)  
RETURNS TABLE  
AS  
RETURN   
(  
    SELECT CDC.Id as ConferenceDayId, A.FirstName, A.LastName, A.PersonalNumber, S.StudentId, CC.CompanyName
	from (
		SELECT * FROM ConferenceDays CD 
		where CD.ConferenceId = @conferenceId
		ORDER BY CD.Date ASC
		OFFSET @ConferenceDay ROWS
		FETCH NEXT 1 ROW ONLY
	) AS CDC

	LEFT JOIN IndividualClientConferenceDay ICCD
	ON CDC.Id = ICCD.ConferenceDays_Id

	LEFT JOIN IndividualClients A
	ON A.Id = ICCD.IndividualClientConferenceDay_ConferenceDay_Id

	LEFT JOIN Students S
	ON S.Id = A.Id

	LEFT JOIN CorporateClientEmployes CCE
	ON A.Id = CCE.Id

	LEFT JOIN CorporateClients CC
	ON CC.Id = CCE.CorporateClientId
);  