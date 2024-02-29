USE `smartmobility`;
DROP function IF EXISTS `ViabilitaTratta`;

DELIMITER $$
USE `smartmobility`$$
CREATE FUNCTION `ViabilitaTratta` (
pCodTratta VARCHAR(12),
pCodFascia VARCHAR(12))
RETURNS VARCHAR(13)
BEGIN

	DECLARE lvTempoMedio DECIMAL(13,2); -- secondi
    DECLARE lvStrada VARCHAR(12);
    DECLARE lvCarreggiata TINYINT(4);
    DECLARE lvLunghezza DECIMAL(9,3);
    DECLARE lvPosizioneIni VARCHAR(12);
    DECLARE lvLimite DECIMAL(5,2);
    DECLARE lvTempoOttimale DECIMAL(13,2); -- secondi
    DECLARE lvRes VARCHAR(13);
    
    SELECT IF(TempoMedio IS NULL, 0, TempoMedio) INTO lvTempoMedio
	  FROM TrattaTemporizzata
	 WHERE CodTratta = pCodTratta
		AND CodFascia = pCodFascia;
        
	
	SELECT CodStrada,
		   NumCarreggiata,
           Lunghezza,
           CodPosizioneIni
	  INTO lvStrada, lvCarreggiata, lvLunghezza, lvPosizioneIni
	  FROM Tratta
	 WHERE CodTratta = pCodTratta;
     
     
	SELECT Limite - 5 INTO lvLimite
      FROM LimiteVelocita
	 WHERE CodStrada = lvStrada
		AND NumCarreggiata = lvCarreggiata
        AND CodPosizione = lvPosizioneIni;
    
    -- la lunghezza è in km, la velocita è in km/h      
	SELECT 3600 * (lvLunghezza/lvLimite) INTO lvTempoOttimale;
    --
    IF lvTempoMedio <> 0 THEN
        IF lvTempoOttimale >= lvTempoMedio THEN
            SET lvRes = 'NonTrafficato';
        ELSE 
            SET lvRes = 'Trafficato';
        END IF;
    ELSE 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La tratta non esiste o non è mai stata percorsa nella fascia oraria selezionata';
    END IF;
    --
    RETURN lvRes;
    
END$$

DELIMITER ;
