USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.ValutaPrenotazioneCP;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE ValutaPrenotazioneCP(
pCodPrenotazione varchar(12),
pEsito varchar(16)
)
--
ValutaPrenotazioneCP:BEGIN
    DECLARE PRENOTAZIONE_INESISTENTE CONDITION FOR SQLSTATE '45000';
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    if EsistePrenotazioneCP(pCodPrenotazione) = 'N' then
        SIGNAL PRENOTAZIONE_INESISTENTE SET MESSAGE_TEXT = 'ValutaPrenotazioneCP: Prenotazione inesistente';
    end if;
    --
    call UpdStatoPrenotazioneCP(pCodPrenotazione, pEsito);
 END
//
DELIMITER ;
