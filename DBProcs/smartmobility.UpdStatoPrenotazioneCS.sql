USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.UpdStatoPrenotazioneCS;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE UpdStatoPrenotazioneCS(
pCodPrenotazione varchar(12),
pStato varchar(16)
)
--
UpdStatoPrenotazioneCS:BEGIN
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    update PrenotazioneCS
       set Stato = pStato
     where CodPrenotazione = pCodPrenotazione;
    --
    if lvRecNotFound = 1 then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UpdStatoPrenotazioneCS: Prenotazione inesistente';
    end if;
END
//
DELIMITER ;