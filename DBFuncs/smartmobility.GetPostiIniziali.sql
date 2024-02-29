USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.GetPostiIniziali;

delimiter //
CREATE DEFINER=root@localhost FUNCTION GetPostiIniziali(
pNumTarga varchar(7)
) RETURNS int
GetPostiIniziali:BEGIN
    DECLARE lvRes int default NULL;
    --
    select NumPosti - 1
      into lvRes
      from AutovetturaRegistrata
     where NumTarga = pNumTarga;
    --
    return lvRes;
END
//
DELIMITER ;
