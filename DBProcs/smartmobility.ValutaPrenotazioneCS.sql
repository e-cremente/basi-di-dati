USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.ValutaPrenotazioneCS;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE ValutaPrenotazioneCS(
pCodPrenotazione varchar(12),
pEsito varchar(16)
)
--
ValutaPrenotazioneCS:BEGIN
    DECLARE PRENOTAZIONE_INESISTENTE CONDITION FOR SQLSTATE '45000';
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    if EsistePrenotazioneCS(pCodPrenotazione) = 'N' then
        SIGNAL PRENOTAZIONE_INESISTENTE SET MESSAGE_TEXT = 'ValutaPrenotazioneCS: Prenotazione inesistente';
    end if;
    --
    call UpdStatoPrenotazioneCS(pCodPrenotazione, pEsito);
 END
//
DELIMITER ;
