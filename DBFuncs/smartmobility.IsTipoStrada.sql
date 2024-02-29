USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.IsTipoStrada;

delimiter //
CREATE DEFINER=root@localhost FUNCTION IsTipoStrada(
pTipoStrada varchar(256)
) RETURNS char(1)
    COMMENT 'Restituisce S o N a seconda che pTipoStrada sia contenuto nella tabella TipoStrada'
IsTipoStrada:BEGIN
    DECLARE lvRes char(1) default 'N';
    -- DECLARE lvRecNotFound int default 0;
    -- DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    if pTipoStrada = ANY (
        select CodTipoStrada
          from TipoStrada)
    then
        return 'S';
    else
        return 'N';
    end if;
    /*
    select 'S'
      into lvRes
      from TipoStrada
     where CodTipoStrada = pTipoStrada;
    --
    return lvRes;
    */
END
//
DELIMITER ;
