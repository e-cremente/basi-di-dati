USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.GiornoSettimana;

delimiter //
CREATE DEFINER=`root`@`localhost` FUNCTION `GiornoSettimana`(
pGiornoSettimana varchar(3)
) RETURNS int 
    COMMENT 'Restituisce il giorno della settimana come intero (DOM = 1, LUN = 2, MAR = 3 ...)'
GiornoSettimana:BEGIN
    DECLARE lvRes int;
    set lvRes = case pGiornoSettimana
                    when 'DOM' then 1
                    when 'LUN' then 2
                    when 'MAR' then 3
                    when 'MER' then 4
                    when 'GIO' then 5
                    when 'VEN' then 6
                    when 'SAB' then 7
                end;
    --
    return lvRes;
END;
//
delimiter ;
