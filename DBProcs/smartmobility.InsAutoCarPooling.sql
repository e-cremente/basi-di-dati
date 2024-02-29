USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.InsAutoCarPooling;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE InsAutoCarPooling(
pNumTarga varchar(8)
)
--
InsAutoCarPooling:BEGIN
    DECLARE DUPLICATED_KEY CONDITION FOR 1062;
    DECLARE lvDuplicatedKey int default 0;
    DECLARE CONTINUE HANDLER FOR DUPLICATED_KEY set lvDuplicatedKey = 1;
    --
    insert into AutoCarPooling (
        NumTarga
    ) VALUES (
        pNumTarga
    );
    --
    if lvDuplicatedKey = 1 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La vettura è già presente';
    end if;
END
//
DELIMITER ;
