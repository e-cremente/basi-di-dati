USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.EsistePrenotazioneCP;

delimiter //
CREATE DEFINER=root@localhost FUNCTION EsistePrenotazioneCP(
pCodPrenotazione varchar(12)
) RETURNS char(1)
    COMMENT 'Restituisce S o N a seconda che pCodPrenotazione sia presente nella tabella PrenotazioneCP'
EsistePrenotazioneCP:BEGIN
    DECLARE lvRes char(1) default 'N';
    select 'S'
      into lvRes
      from PrenotazioneCP
     where CodPrenotazione = pCodPrenotazione;
    --
    return lvRes;
END
//
DELIMITER ;
