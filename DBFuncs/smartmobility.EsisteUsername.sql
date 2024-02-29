USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.EsisteUsername;

delimiter //
CREATE DEFINER=root@localhost FUNCTION EsisteUsername(
pUsername varchar(32)
) RETURNS char(1)
    COMMENT 'Restituisce S o N a seconda che pUsername sia presente nella tabella Account'
EsisteUsername:BEGIN
    DECLARE lvRes char(1) default 'N';
    select 'S'
      into lvRes
      from Account
     where Username = pUsername;
    --
    return lvRes;
END
//
DELIMITER ;
