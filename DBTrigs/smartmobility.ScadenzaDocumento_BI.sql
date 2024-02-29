DROP TRIGGER IF EXISTS DocumentoRiconoscimento_BEFORE_INSERT;

DELIMITER $$

CREATE DEFINER = CURRENT_USER TRIGGER `smartmobility`.`DocumentoRiconoscimento_BEFORE_INSERT` BEFORE INSERT ON `DocumentoRiconoscimento` FOR EACH ROW
BEGIN

    if NEW.Scadenza <= CURRENT_DATE() then
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il documento è già scaduto';
    end if;
    
     if NEW.TipoDocumento <> 'CI' 
    and NEW.TipoDocumento <> 'P'
    and NEW.TipoDocumento <> 'PP' then
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il tipo di documento inserito non è velido';
    end if;

END
$$
DELIMITER ;
