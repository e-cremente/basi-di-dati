USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.EsisteTragitto;

delimiter //
CREATE DEFINER=root@localhost FUNCTION EsisteTragitto(
pCodTragitto varchar(16)
) RETURNS char(1)
    COMMENT 'Restituisce S o N a seconda che pCodTragitto sia presente nella tabella Tragitto'
EsisteUtente:BEGIN
    DECLARE lvRes char(1) default 'N';
    select 'S'
      into lvRes
      from Tragitto
     where CodTragitto = pCodTragitto;
    --
    return lvRes;
END
//
DELIMITER ;
