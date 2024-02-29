DROP TRIGGER IF EXISTS Noleggio_BEFORE_INSERT;

DELIMITER $$

CREATE DEFINER = CURRENT_USER TRIGGER `smartmobility`.`Noleggio_BEFORE_INSERT` BEFORE INSERT ON `Noleggio` FOR EACH ROW
BEGIN

    if NEW.QtaCarburanteIni < 0 OR NEW.KmPercorsiIni < 0 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Parametri non validi';
    end if;

END
$$
DELIMITER ;
