DROP TRIGGER IF EXISTS Strada_BEFORE_INSERT;

DELIMITER $$

CREATE DEFINER = CURRENT_USER TRIGGER `smartmobility`.`Strada_BEFORE_INSERT` BEFORE INSERT ON `Strada` FOR EACH ROW
BEGIN

    if NEW.NumCarreggiate <=  0 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La strada deve avere almeno una carreggiata';
    end if;

END
$$
DELIMITER ;
