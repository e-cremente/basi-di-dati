DROP TRIGGER IF EXISTS AutovetturaRegistrata_BEFORE_UPDATE;

DELIMITER $$

CREATE DEFINER = CURRENT_USER TRIGGER `smartmobility`.`AutovetturaRegistrata_BEFORE_UPDATE` BEFORE UPDATE ON `AutovetturaRegistrata` FOR EACH ROW
BEGIN

    if NEW.NumPosti <=0 then
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il numero inserito non è accettabile';
    end if;
    
    if NEW.AnnoImmatricolazione > current_date() then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'L anno inserito non è valido';
    end if;    
    
    if NEW.Cilindrata <= 0 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La cilindrata inserita non è valida';
    end if;  
    
    if NEW.CapacitaSerbatoio <= 0 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La capacità del serbatoio inserita non è valida';
    end if;  
    
    if NEW.VelocitaMax <= 0 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La velocità massima inserita non è valida';
    end if;  

END
$$
DELIMITER ;
