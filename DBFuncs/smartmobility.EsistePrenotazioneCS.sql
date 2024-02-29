USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.EsistePrenotazioneCS;

delimiter //
CREATE DEFINER=root@localhost FUNCTION EsistePrenotazioneCS(
pCodPrenotazione varchar(12)
) RETURNS char(1)
    COMMENT 'Restituisce S o N a seconda che pCodPrenotazione sia presente nella tabella PrenotazioneCS'
EsistePrenotazioneCS:BEGIN
    DECLARE lvRes char(1) default 'N';
    select 'S'
      into lvRes
      from PrenotazioneCS
     where CodPrenotazione = pCodPrenotazione;
    --
    return lvRes;
END
//
DELIMITER ;
