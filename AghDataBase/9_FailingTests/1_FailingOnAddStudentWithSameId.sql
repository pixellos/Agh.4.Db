/*Will fail on adding student with same id */

	EXEC AddStudent 'NotExisting2', 'NotExisting', '97010207999','600000', '+48 123456689', 'Mickiewicza', 4, 1, '38-400', 'Krosno', 'Polska';
	DECLARE @RAISE INT = CAST('Raise error.' AS INT);
