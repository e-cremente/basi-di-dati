DROP PROCEDURE IF EXISTS GiudizioRiepilogativo;

DELIMITER $$
CREATE PROCEDURE GiudizioRiepilogativo(
pCodFiscale VARCHAR(16),
pGiudizioP VARCHAR(16),
pComportamento VARCHAR(16),
pSerieta VARCHAR(16),
pPiacereViaggio VARCHAR(16),
pRispettoOrari VARCHAR(16),
pRispettoLimiti VARCHAR(16),
pRuoloGto CHAR(1)
)
BEGIN
	SELECT CFUtenteGiudicato,
		   CodAspettoValutabile,
		   AVG(Voto) AS Voto
	  FROM Valutazione 
		   NATURAL JOIN ValutazioneAspetti
	 WHERE CFUtenteGiudicato = pCodFiscale
	   AND (
		   CodAspettoValutabile = pGiudizioP
		   OR CodAspettoValutabile = pComportamento
		   OR CodAspettoValutabile = pSerieta
		   OR CodAspettoValutabile = pPiacereViaggio
           OR CodAspettoValutabile = pRispettoOrari
		   OR CodAspettoValutabile = pRispettoLimiti	
		   )
       AND RuoloUtenteGiudicato = pRuoloGto
     GROUP BY CFUtenteGiudicato,
		      CodAspettoValutabile;
END $$
DELIMITER ;

