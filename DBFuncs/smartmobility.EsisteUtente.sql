USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.EsisteUtente;

delimiter //
CREATE DEFINER=root@localhost FUNCTION EsisteUtente(
pCodFiscale varchar(16)
) RETURNS char(1)
    COMMENT 'Restituisce S o N a seconda che pCodFiscale sia presente nella tabella Utente'
EsisteUtente:BEGIN
    DECLARE lvRes char(1) default 'N';
    select 'S'
      into lvRes
      from Utente
     where CodFiscale = pCodFiscale;
    --
    return lvRes;
END
//
DELIMITER ;
