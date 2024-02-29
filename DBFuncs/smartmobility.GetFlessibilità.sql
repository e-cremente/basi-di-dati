USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.GetFlessibilita;

delimiter //
CREATE DEFINER=root@localhost FUNCTION GetFlessibilita(
pFlessibilita int
) RETURNS varchar(5)
GetFlessibilita:BEGIN
    DECLARE lvRes varchar(5) default NULL;
    --
    if pFlessibilita <= 5 then
		set lvRes = 'Bassa';
	elseif pFlessibilita > 5 and pFlessibilita <= 10 then
		set lvRes = 'Media';
	elseif pFlessibilita > 10 and pFlessibilita <= 15 then
		set lvRes = 'Alta';
	else
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La flessibilità è troppo alta';
	end if;
    --
    return lvRes;
END
//
DELIMITER ;
