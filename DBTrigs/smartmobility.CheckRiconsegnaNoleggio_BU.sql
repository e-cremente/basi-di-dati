DROP TRIGGER IF EXISTS noleggio_BEFORE_UPDATE;

DELIMITER $$

CREATE DEFINER = CURRENT_USER TRIGGER `smartmobility`.`noleggio_BEFORE_UPDATE` BEFORE UPDATE ON `noleggio` FOR EACH ROW
BEGIN

    if NEW.QtaCarburanteFin < QtaCarburanteIni - 2 
    or NEW.KmPercorsiFin < KmPercorsiIni then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La macchina non può essere riconsegnata poiché non ha sufficiente carburante nel serbatoio';
    end if;

END
$$
DELIMITER ;
