USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.IsAlphabetic;

delimiter //
CREATE DEFINER=root@localhost FUNCTION IsAlphabetic(
pStr varchar(256)
) RETURNS char(1)
    COMMENT 'Restituisce S o N a seconda che pStr sia alfabetica o meno'
IsAlphabetic:BEGIN
    DECLARE lvLen int;
    DECLARE lvIdx int;
    DECLARE lvChr char(1);
    --
    set lvLen = length(pStr);
    set lvIdx = 1;
    while lvIdx <= lvLen do
        set lvChr = substr(pStr, lvIdx, 1);
        if upper(lvChr) < 'A' or upper(lvChr) > 'Z' then return 'N'; end if;
        set lvIdx = lvIdx + 1;
    end while;
    --
    return 'S';
END
//
DELIMITER ;
