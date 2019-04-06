CREATE FUNCTION AttendantsAtConferenceDay (
	@ConferenceId int,
	@ConferenceDay int
	)  
RETURNS TABLE  
AS  
RETURN   
(  
    SELECT A.FirstName, A.LastName, A.PersonalNumber, S.StudentId, CC.CompanyName
	from (
		SELECT * FROM ConferenceDay CD 
		where CD.ConferenceId = @conferenceId
		ORDER BY CD.Date ASC
		OFFSET @ConferenceDay ROWS
		FETCH NEXT 1 ROW ONLY
	) AS CDC

	LEFT JOIN IndividualClient A
	ON A.Id = CDC.IndividualClientId 

	LEFT JOIN Student S
	ON S.Id = A.Id

	LEFT JOIN CorporateClientEmployee CCE
	ON A.Id = CCE.Id

	LEFT JOIN CorporateClient CC
	ON CC.Id = CCE.CorporateClientId
);  