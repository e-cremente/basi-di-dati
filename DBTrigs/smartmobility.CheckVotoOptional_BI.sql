DROP TRIGGER IF EXISTS Optional_BEFORE_INSERT;

DELIMITER $$

CREATE DEFINER = CURRENT_USER TRIGGER `smartmobility`.`Optional_BEFORE_INSERT` BEFORE INSERT ON `Optional` FOR EACH ROW
BEGIN

    if (NEW.CodOptional = 'BAGAGLIAIO' OR NEW.CodOptional = 'INSONORIZZAZIONE')
		AND NEW.Voto IS NOT NULL then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Non è possibile dare un voto a questi optional';
    end if;
    
    if (NEW.CodOptional = 'BAGAGLIAIO' OR NEW.CodOptional = 'INSONORIZZAZIONE')
		AND NEW.Voto < 0 OR NEW.Voto > 3 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Voto non accettabile';
    end if;

END
$$
DELIMITER ;
