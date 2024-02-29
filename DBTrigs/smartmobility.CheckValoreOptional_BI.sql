DROP TRIGGER IF EXISTS OptionalAuto_BEFORE_INSERT;

DELIMITER $$

CREATE DEFINER = CURRENT_USER TRIGGER `smartmobility`.`OptionalAuto_BEFORE_INSERT` BEFORE INSERT ON `OptionalAuto` FOR EACH ROW
BEGIN

    if (NEW.CodOptional = 'BAGAGLIAIO' OR NEW.CodOptional = 'INSONORIZZAZIONE')
		AND NEW.Valore IS NULL then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Non è possibile non dare un valore a questi optional';
    end if;

END
$$
DELIMITER ;
