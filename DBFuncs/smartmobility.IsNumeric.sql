USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.IsNumeric;

delimiter //
CREATE DEFINER=root@localhost FUNCTION IsNumeric(
pStr varchar(256)
) RETURNS char(1)
    COMMENT 'Restituisce S o N a seconda che pStr sia numerico o meno'
IsNumeric:BEGIN
    DECLARE lvLen int;
    DECLARE lvIdx int;
    DECLARE lvChr char(1);
    --
    set lvLen = length(pStr);
    set lvIdx = 1;
    while lvIdx <= lvLen do
        set lvChr = substr(pStr, lvIdx, 1);
        if lvChr < '0' or lvChr > '9' then return 'N'; end if;
        set lvIdx = lvIdx + 1;
    end while;
    --
    return 'S';
END
//
DELIMITER ;
