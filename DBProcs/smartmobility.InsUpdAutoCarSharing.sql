USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.InsUpdAutoCarSharing;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE InsUpdAutoCarSharing(
pNumTarga varchar(8),
pDisponibilita varchar(16)
)
--
InsUpdAutoCarSharing:BEGIN
    DECLARE DUPLICATED_KEY CONDITION FOR 1062;
    DECLARE lvDuplicatedKey int default 0;
    DECLARE CONTINUE HANDLER FOR DUPLICATED_KEY set lvDuplicatedKey = 1;
    --
    insert into AutoCarSharing (
        NumTarga, Disponibilita
    ) VALUES (
        pNumTarga, pDisponibilita
    );
    --
    if lvDuplicatedKey = 1 then
        update AutoCarSharing
           set Disponibilita = pDisponibilita
         where NumTarga = pNumTarga;
    end if;
END
//
DELIMITER ;
