USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.InsUpdCostoAutovettura;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE InsUpdCostoAutovettura(
pNumTarga varchar(8),
pNumPasseggeri decimal(2),
pCostoOperativo decimal(12,5),
pCostoUsura decimal(12,5),
pConsumoU decimal(5,3),
pConsumoXU decimal(5,3),
pConsumoM decimal(5,3)
)
--
InsUpdCostoAutovettura:BEGIN
    DECLARE DUPLICATED_KEY CONDITION FOR 1062;
    DECLARE lvDuplicatedKey int default 0;
    DECLARE CONTINUE HANDLER FOR DUPLICATED_KEY set lvDuplicatedKey = 1;
    --
    insert into CostoAutovettura (
        NumTarga, NumPasseggeri, CostoOperativo, CostoUsura,
        ConsumoU, ConsumoXU, ConsumoM
    ) VALUES (
        pNumTarga, pNumPasseggeri, pCostoOperativo, pCostoUsura,
        pConsumoU, pConsumoXU, pConsumoM
    );
    --
    if lvDuplicatedKey = 1 then
        update CostoAutovettura
           set NumPasseggeri = pNumPasseggeri,
               CostoOperativo = pCostoOperativo,
               CostoUsura = pCostoUsura,
               ConsumoU = pConsumoU,
               ConsumoXU = pConsumoXU,
               ConsumoM = pConsumoM
         where NumTarga = pNumTarga;
    end if;
END
//
DELIMITER ;
