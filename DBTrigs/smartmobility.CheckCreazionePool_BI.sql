DROP TRIGGER IF EXISTS Pool_BEFORE_INSERT;

DELIMITER $$

CREATE DEFINER = CURRENT_USER TRIGGER `smartmobility`.`Pool_BEFORE_INSERT` BEFORE INSERT ON `Pool` FOR EACH ROW
BEGIN

    if current_timestamp > (NEW.DataPartenza - interval 48 hour) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il pool non può essere creato a meno di 48 ore dalla partenza';
    end if;
    
    if NEW.Validita < 48 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La scadenza del pool non può essere impostata a meno di 48 ore dalla partenza';
    end if;
    
    if NEW.DataArrivo < NEW.DataPartenza then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La data di arrivo non può precedere la data di partenza';
    end if;
    
END
$$
DELIMITER ;
