DROP TRIGGER IF EXISTS noleggio_BEFORE_INSERT;

DELIMITER $$

CREATE DEFINER = CURRENT_USER TRIGGER `smartmobility`.`noleggio_BEFORE_INSERT` BEFORE INSERT ON `noleggio` FOR EACH ROW
BEGIN

    if not exists(
        select *
          from PrenotazioneCS
         where CodPrenotazione = NEW.CodPrenotazione
           and Stato = 'ACCETTATA'
    ) then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Prenotazione Inesistente';
    end if;    

END
$$
DELIMITER ;
