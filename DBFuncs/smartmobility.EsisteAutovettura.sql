USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.EsisteAutovettura;

delimiter //
CREATE DEFINER=root@localhost FUNCTION EsisteAutovettura(
pNumTarga varchar(8)
) RETURNS char(1)
    COMMENT 'Restituisce S o N a seconda che pNumTarga sia presente nella tabella Autovettura'
EsisteAutovettura:BEGIN
    DECLARE lvRes char(1) default 'N';
    select 'S'
      into lvRes
      from Autovettura
     where NumTarga = pNumTarga;
    --
    return lvRes;
END
//
DELIMITER ;
