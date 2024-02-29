USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.InsUpdCarreggiata;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE InsUpdCarreggiata(
pCodStrada varchar(32),
pNumCarreggiata tinyint,
pNumCorsie tinyint,
pNumSensiMarcia tinyint
)
--
InsUpdCarreggiata:BEGIN
    DECLARE DUPLICATED_KEY CONDITION FOR 1602;
    DECLARE lvDuplicatedKey int default 0;
    DECLARE CONTINUE HANDLER FOR DUPLICATED_KEY set lvDuplicatedKey = 1;
    --
    insert into Carreggiata (
        CodStrada, NumCarreggiata, NumCorsie, NumSensiMarcia
    ) VALUES (
        pCodStrada, pNumCarreggiata, pNumCorsie, pNumSensiMarcia
    );
    --
    if lvDuplicatedKey = 1 then
        update Carreggiata
           set NumCorsie = pNumCorsie,
               NumSensiMarcia = pNumSensiMarcia
         where CodStrada = pCodStrada
           and NumCarreggiata = pNumCarreggiata;
    end if;
END
//
DELIMITER ;
