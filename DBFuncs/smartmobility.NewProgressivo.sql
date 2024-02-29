USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.NewProgressivo;

delimiter //
CREATE DEFINER=root@localhost FUNCTION smartmobility.NewProgressivo(
pTipo varchar(3),
pOwnerTable varchar(64)
) RETURNS varchar(12)
COMMENT 'Restituisce un progressivo di tipo pTipo univoco'
NewProgressivo:BEGIN
    DECLARE lvRecNotFound int default 0;
    DECLARE lvRes varchar(12);
    DECLARE lvNextProgr int;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    set lvRecNotFound = 0;
    select progressivo
      into lvNextProgr
      from smartmobility.cfg_progressivo
     where tipo = pTipo;
    --
    if lvRecNotFound = 1 then
        set lvNextProgr = 1;
        insert into smartmobility.cfg_progressivo VALUES (pTipo, lvNextProgr+1, pOwnerTable);
    else
        update smartmobility.cfg_progressivo set progressivo = lvNextProgr+1 where tipo = pTipo;
    end if;
    --
    set lvRes = concat(pTipo, lpad(convert(lvNextProgr,char), 9, '0'));
    return lvRes;
END;
//
delimiter ;
