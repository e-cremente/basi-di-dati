USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.InsUpdLimiteVelocita;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE InsUpdLimiteVelocita(
pCodStrada varchar(12),
pNumCarreggiata tinyint(4),
pCodPosizione varchar(12),
pLimite decimal(5,2)
)
--
InsUpdLimiteVelocita:BEGIN
    DECLARE DUPLICATED_KEY CONDITION FOR 1602;
    DECLARE lvDuplicatedKey int default 0;
    DECLARE CONTINUE HANDLER FOR DUPLICATED_KEY set lvDuplicatedKey = 1;
    --
    insert into LimiteVelocita (
        CodStrada, NumCarreggiata, CodPosizione, Limite
    ) VALUES (
        pCodStrada, pNumCarreggiata, pCodPosizione, pLimite
    );
    --
    if lvDuplicatedKey = 1 then
        update LimiteVelocita
           set NumCarreggiata = pNumCarreggiata,
               Limite = pLimite
         where CodStrada = pCodStrada
           and CodPosizione = pCodPosizione;
    end if;
END
//
DELIMITER ;
