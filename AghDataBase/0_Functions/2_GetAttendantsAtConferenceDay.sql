CREATE FUNCTION GetAttendantsAtConferenceDay (
	@ConferenceId int,
	@ConferenceDay int
	)  
RETURNS TABLE  
AS  
RETURN   
(  
    SELECT A.FirstName, A.LastName, A.PersonalNumber, S.StudentId, CC.CompanyName
	from (
		SELECT * FROM ConferenceDays CD 
		where CD.ConferenceId = @conferenceId
		ORDER BY CD.Date ASC
		OFFSET @ConferenceDay ROWS
		FETCH NEXT 1 ROW ONLY
	) AS CDC

	LEFT JOIN IndividualClients A
	ON A.Id = CDC.IndividualClientId 

	LEFT JOIN Students S
	ON S.Id = A.Id

	LEFT JOIN CorporateClientEmployes CCE
	ON A.Id = CCE.Id

	LEFT JOIN CorporateClients CC
	ON CC.Id = CCE.CorporateClientId
);  