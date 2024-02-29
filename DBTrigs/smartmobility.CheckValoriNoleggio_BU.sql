DROP TRIGGER IF EXISTS Noleggio_BEFORE_UPDATE;

DELIMITER $$

CREATE DEFINER = CURRENT_USER TRIGGER `smartmobility`.`Noleggio_BEFORE_UPDATE` BEFORE UPDATE ON `Noleggio` FOR EACH ROW
BEGIN

    if NEW.QtaCarburanteIni < 0 OR NEW.KmPercorsiIni < 0
		OR NEW.QtaCarburanteFin < 0 OR NEW.KmPercorsiFin < 0 
        OR NEW.KmPercorsiFin < NEW.KmPercorsiIni then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Parametri non validi';
    end if;

END
$$
DELIMITER ;
