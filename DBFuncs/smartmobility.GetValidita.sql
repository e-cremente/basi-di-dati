USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.GetValidita;

delimiter //
CREATE DEFINER=root@localhost FUNCTION GetValidita(
pDataOraPartenza datetime
) RETURNS varchar(7)
GetValidita:BEGIN
    DECLARE lvRes varchar(7) default NULL;
    --
    if pDataOraPartenza > (current_timestamp() + interval 48 hour) then
		set lvRes = 'Aperto';
	elseif (pDataOraPartenza <= (current_timestamp() + interval 48 hour)) and pDataOraPartenza > (current_timestamp() + interval 1 hour) then
		set lvRes = 'Chiuso';
	elseif pDataOraPartenza <= (current_timestamp() + interval 1 hour) then
		set lvRes = 'Partito';
	end if;
    --
    return lvRes;
END
//
DELIMITER ;
