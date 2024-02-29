DROP TRIGGER IF EXISTS Carreggiata_BEFORE_INSERT;

DELIMITER $$

CREATE DEFINER = CURRENT_USER TRIGGER `smartmobility`.`Carreggiata_BEFORE_INSERT` BEFORE INSERT ON `Carreggiata` FOR EACH ROW
BEGIN

    DECLARE NumMaxCarr INTEGER DEFAULT 0;
    
    select NumCarreggiate INTO NumMaxCarr
      from Strada
	 where CodStrada = NEW.CodStrada;
	
	if NEW.NumCarreggiata > NumMaxCarr then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La strada ha meno carreggiate';
    end if;

END
$$
DELIMITER ;