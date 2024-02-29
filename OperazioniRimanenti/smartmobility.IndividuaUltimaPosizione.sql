USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.IndividuaUltimaPosizione;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE IndividuaUltimaPosizione(
pNumTarga varchar(8)
)
--
IndividuaUltimaPosizione:BEGIN
    --
    select *
      from Tracciamento T
     where T.NumTarga = 'EH732KV'
       and T.Timestamp = (
           select max(T2.Timestamp)
             from Tracciamento T2
            where T2.NumTarga = 'EH732KV'
	       );
    --  
END
//
DELIMITER ;
