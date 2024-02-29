DROP TRIGGER IF EXISTS Fruibilita_BU;

DELIMITER $$

CREATE DEFINER=`root`@`localhost` TRIGGER `smartmobility`.`Fruibilita_BU`
BEFORE UPDATE ON `smartmobility`.`fruibilita`
FOR EACH ROW
BEGIN
    if NEW.TipoFruibilita <> 'PER' AND NEW.TipoFruibilita <> 'FAS' then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'TipoFruibilita non valida (PER: Periodico; FAS: Fascia)';
    end if;
    if NEW.TipoFruibilita = 'PER' and coalesce(NEW.NomeGiorno, '#') not in ('LUN', 'MAR', 'MER', 'GIO', 'VEN', 'SAB', 'DOM') then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Specificare un nome giorno valido per una fruibilità periodica';
    end if;
    if NEW.TipoFruibilita = 'PER' and (NEW.GiornoIni is not null or NEW.GiornoFin is not null) then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Specificare solamente un nome giorno valido per una fruibilità periodica';
    end if;
    if NEW.TipoFruibilita = 'FAS' and NEW.NomeGiorno is not null then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Specificare solamente un intervallo di giorni valido per una fruibilità a fasce';
    end if;
    if NEW.TipoFruibilita = 'FAS' and (NEW.GiornoIni is null or NEW.GiornoFin is null) then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Specificare un intervallo di giorni valido per una fruibilità a fasce';
    end if;
    if NEW.TipoFruibilita = 'FAS' and (NEW.GiornoIni > NEW.GiornoFin) then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Specificare un intervallo di giorni valido per una fruibilità a fasce';
    end if;
  --  if NEW.TipoFruibilita = 'FAS' and (NEW.GiornoIni < current_date()) then
   --     SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Specificare un intervallo di giorni valido per una fruibilità a fasce';
   -- end if;
END
$$
DELIMITER ;
