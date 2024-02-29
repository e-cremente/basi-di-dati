DROP TRIGGER IF EXISTS Account_BEFORE_UPDATE;

DELIMITER $$

CREATE DEFINER = CURRENT_USER TRIGGER `smartmobility`.`Account_BEFORE_UPDATE` BEFORE UPDATE ON `Account` FOR EACH ROW
BEGIN

    DECLARE len INTEGER DEFAULT 0;
    
    select length(NEW.Password) into len;
    
	if len < 6 OR len > 64 then
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lunghezza della password non accettata(range: 6-64)';
    end if;

END
$$
DELIMITER ;
