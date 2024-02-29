DROP TRIGGER IF EXISTS ValutazioneAspetti_BU;

DELIMITER $$

CREATE DEFINER = CURRENT_USER TRIGGER `smartmobility`.`ValutazioneAspetti_BU` BEFORE UPDATE ON `ValutazioneAspetti` FOR EACH ROW
BEGIN
    if NEW.Voto not between 0 and 5 then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Il voto deve essere compreso tra 0 e 5';
    end if;
END
$$
DELIMITER ;
