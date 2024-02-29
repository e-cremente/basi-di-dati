USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.UpdStatoPrenotazioneCP;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE UpdStatoPrenotazioneCP(
pCodPrenotazione varchar(12),
pStato varchar(16)
)
--
UpdStatoPrenotazioneCP:BEGIN
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    update PrenotazioneCP
       set Stato = pStato
     where CodPrenotazione = pCodPrenotazione;
    --
    if lvRecNotFound = 1 then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UpdStatoPrenotazioneCP: Prenotazione inesistente';
    end if;
END
//
DELIMITER ;