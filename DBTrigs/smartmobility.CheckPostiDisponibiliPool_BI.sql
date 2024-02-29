DROP TRIGGER IF EXISTS PrenotazioneCP_BEFORE_INSERT;

DELIMITER $$

CREATE DEFINER = CURRENT_USER TRIGGER `smartmobility`.`PrenotazioneCP_BEFORE_INSERT` BEFORE INSERT ON `PrenotazioneCP` FOR EACH ROW
BEGIN

    DECLARE posti INTEGER DEFAULT 0;
    
    select PostiDisponibili into posti
      from Pool
	 where CodPool = NEW.CodPool;
	
	if posti = 0 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nessun posto disponibile al momento';
    end if;

END
$$
DELIMITER ;
