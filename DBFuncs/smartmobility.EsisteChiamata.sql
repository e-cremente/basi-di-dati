USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.EsisteChiamata;

delimiter //
CREATE DEFINER=root@localhost FUNCTION EsisteChiamata(
pCodChiamata varchar(12)
) RETURNS char(1)
    COMMENT 'Restituisce S o N a seconda che pCodChiamata sia presente nella tabella Chiamata'
EsisteChiamata:BEGIN
    DECLARE lvRes char(1) default 'N';
    select 'S'
      into lvRes
      from Chiamata
     where CodChiamata = pCodChiamata;
    --
    return lvRes;
END
//
DELIMITER ;
