DROP PROCEDURE IF EXISTS ClassificaAuto;

DELIMITER $$
CREATE PROCEDURE ClassificaAuto()
BEGIN
	SELECT @rank := @rank + 1 AS Classifica,
		   AU.NumTarga, 
		   AU.Comfort
	  FROM (
		    SELECT A.NumTarga, A.Comfort
		      FROM AutovetturaRegistrata A
			       CROSS JOIN (SELECT @rank := 0) R
		    ORDER BY A.Comfort DESC, A.AnnoImmatricolazione DESC
		   ) AS AU;
END $$
DELIMITER ;
