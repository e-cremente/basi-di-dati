USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.IsCategoria;

delimiter //
CREATE DEFINER=root@localhost FUNCTION IsCategoria(
pCategoria varchar(256)
) RETURNS char(1)
    COMMENT 'Restituisce S o N a seconda che pCategoria sia contenuto nella tabella CategoriaStrada'
IsCategoria:BEGIN
    DECLARE lvRes char(1) default 'N';
    -- DECLARE lvRecNotFound int default 0;
    -- DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    if upper(pCategoria) = ANY (
        select upper(CodCategStrada)
          from CategoriaStrada)
    then
        return 'S';
    else
        return 'N';
    end if;
    /*
    select 'S'
      into lvRes
      from CategoriaStrada
     where upper(CodCategStrada) = upper(pCategoria);
    --
    return lvRes;
    */
END
//
DELIMITER ;
