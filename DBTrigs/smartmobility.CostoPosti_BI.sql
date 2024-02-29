DROP TRIGGER IF EXISTS CostoAutovettura_BEFORE_INSERT;

DELIMITER $$

CREATE DEFINER = CURRENT_USER TRIGGER `smartmobility`.`CostoAutovettura_BEFORE_INSERT` BEFORE INSERT ON `CostoAutovettura` FOR EACH ROW
BEGIN

     DECLARE MaxNPos INTEGER DEFAULT 0;
    
    select NumPosti into MaxNPos
      from AutovetturaRegistrata
	 where NumTarga = NEW.NumTarga;
    
	if NEW.NumPasseggeri > MaxNPos or New.NumPasseggeri <= 0 then
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La vettura e omologata per meno persone';
    end if;

END
$$
DELIMITER ;
