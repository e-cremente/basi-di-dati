USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.ChkInsCarreggiata;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE ChkInsCarreggiata(
pCodStrada varchar(32),
pNumCarreggiata tinyint,
pNumCorsie tinyint,
pNumSensiMarcia tinyint
)
--
ChkInsCarreggiata:BEGIN
    DECLARE lvCodStrada varchar(12);
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select CodStrada
      into lvCodStrada
      from smartmobility.Carreggiata C
     where C.CodStrada = pCodStrada
       and C.NumCarreggiata = pNumCarreggiata;
    --
    if lvRecNotFound = 1 then
        insert into Carreggiata (
            CodStrada, NumCarreggiata, NumCorsie, NumSensiMarcia
        ) VALUES (
            pCodStrada, pNumCarreggiata, pNumCorsie, pNumSensiMarcia
        );
    end if;
END
//
DELIMITER ;
