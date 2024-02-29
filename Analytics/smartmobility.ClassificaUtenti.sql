DROP PROCEDURE IF EXISTS ClassificaUtenti;

DELIMITER $$
CREATE PROCEDURE ClassificaUtenti(
Comportamento TINYINT,
GiudizioP TINYINT,
Serieta TINYINT,
PiacereViaggio TINYINT,
RispettoOrari TINYINT,
RispettoLimiti TINYINT,
ruoloGto CHAR(1)
)
BEGIN
	IF GiudizioP THEN
		SELECT @rank := @rank + 1 AS Rank,
			P.CFUtenteGiudicato,
			P. CodAspettoValutabile,
			P.Voto
		FROM(
			SELECT V.CFUtenteGiudicato,
				VA.CodAspettoValutabile,
				AVG(VA.Voto) AS Voto
			FROM Valutazione V
				NATURAL JOIN ValutazioneAspetti VA
			WHERE VA.CodAspettoValutabile = 'ASP000000001'
				AND V.RuoloUtenteGiudicato = RuoloGto
			GROUP BY V.CFUtenteGiudicato
		) AS P CROSS JOIN (SELECT @rank := 0) AS R
        ORDER BY Voto desc;
	END IF;

IF Comportamento THEN
		SELECT @rank := @rank + 1 AS Rank,
			P.CFUtenteGiudicato,
			P.CodAspettoValutabile,
			P.Voto
		FROM(
			SELECT V.CFUtenteGiudicato,
				VA.CodAspettoValutabile,
				AVG(VA.Voto) AS Voto
			FROM Valutazione V
				NATURAL JOIN ValutazioneAspetti VA
			WHERE VA.CodAspettoValutabile = 'ASP000000002'
				AND V.RuoloUtenteGiudicato = RuoloGto
			GROUP BY V.CFUtenteGiudicato
		) AS P CROSS JOIN (SELECT @rank := 0) AS R
        ORDER BY Voto desc;
	END IF;

IF Serieta THEN
		SELECT @rank := @rank + 1 AS Rank,
			P.CFUtenteGiudicato,
			P.CodAspettoValutabile,
			P.Voto
		FROM(
			SELECT V.CFUtenteGiudicato,
				VA.CodAspettoValutabile,
				AVG(VA.Voto) AS Voto
			FROM Valutazione V
				NATURAL JOIN ValutazioneAspetti VA
			WHERE VA.CodAspettoValutabile = 'ASP000000003'
				AND V.RuoloUtenteGiudicato = RuoloGto
			GROUP BY V.CFUtenteGiudicato
		) AS P CROSS JOIN (SELECT @rank := 0) AS R
        ORDER BY Voto desc;
	END IF;

IF PiacereViaggio THEN
		SELECT @rank := @rank + 1 AS Rank,
			P.CFUtenteGiudicato,
			P. CodAspettoValutabile,
			P.Voto
		FROM(
			SELECT V.CFUtenteGiudicato,
				VA.CodAspettoValutabile,
				AVG(VA.Voto) AS Voto
			FROM Valutazione V
				NATURAL JOIN ValutazioneAspetti VA
			WHERE VA.CodAspettoValutabile = 'ASP000000004'
				AND V.RuoloUtenteGiudicato = RuoloGto
			GROUP BY V.CFUtenteGiudicato
		) AS P CROSS JOIN (SELECT @rank := 0) AS R
        ORDER BY Voto desc;
END IF;

IF RispettoOrari THEN
		SELECT @rank := @rank + 1 AS Rank,
			P.CFUtenteGiudicato,
			CodAspettoValutabile,
			P.Voto
		FROM(
			SELECT V.CFUtenteGiudicato,
				VA.CodAspettoValutabile,
				AVG(VA.Voto) AS Voto
			FROM Valutazione V
				NATURAL JOIN ValutazioneAspetti VA
			WHERE VA.CodAspettoValutabile = 'ASP000000005'
				AND V.RuoloUtenteGiudicato = RuoloGto
			GROUP BY V.CFUtenteGiudicato
		) AS P CROSS JOIN (SELECT @rank := 0) AS R
        ORDER BY Voto desc;
	END IF;

IF RispettoLimiti THEN
		SELECT @rank := @rank + 1 AS Rank,
			P.CFUtenteGiudicato,
			P. CodAspettoValutabile,
			P.Voto
		FROM(
			SELECT V.CFUtenteGiudicato,
				VA.CodAspettoValutabile,
				AVG(VA.Voto) AS Voto
			FROM Valutazione V
				NATURAL JOIN ValutazioneAspetti VA
			WHERE VA.CodAspettoValutabile = 'ASP000000006'
				AND V.RuoloUtenteGiudicato = RuoloGto
			GROUP BY V.CFUtenteGiudicato
		) AS P CROSS JOIN (SELECT @rank := 0) AS R
        ORDER BY Voto desc;
	END IF;
END $$
DELIMITER ;