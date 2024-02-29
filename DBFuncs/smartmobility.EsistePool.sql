USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.EsistePool;

delimiter //
CREATE DEFINER=root@localhost FUNCTION EsistePool(
pCodPool varchar(12)
) RETURNS char(1)
    COMMENT 'Restituisce S o N a seconda che pCodPool sia presente nella tabella Pool'
EsistePool:BEGIN
    DECLARE lvRes char(1) default 'N';
    select 'S'
      into lvRes
      from Pool
     where CodPool = pCodPool;
    --
    return lvRes;
END
//
DELIMITER ;
