DROP TRIGGER IF EXISTS Fruibilita_BEFORE_INSERT;

DELIMITER $$

CREATE DEFINER = CURRENT_USER TRIGGER `smartmobility`.`Fruibilita_BEFORE_INSERT` BEFORE INSERT ON `Fruibilita` FOR EACH ROW
BEGIN

    if (NEW.GiornoIni < current_date())
    or (NEW.GiornoIni = current_date() and NEW.OraIni < current_time()) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La data di fine fruibilità deve essere successiva alla data di inizio';
    end if;

    if NEW.TipoFruibilita <> 'PER' AND NEW.TipoFruibilita <> 'FAS' then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipologia non valida (PER: Periodico; FAS: Fascia)';
    end if;

END
$$
DELIMITER ;
