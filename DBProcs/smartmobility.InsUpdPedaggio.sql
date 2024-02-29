USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.InsUpdPedaggio;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE InsUpdPedaggio(
pCodSvincoloE varchar(12),
pCodSvincoloU varchar(12),
pPedaggio decimal(9,2)
)
--
InsUpdPedaggio:BEGIN
    DECLARE DUPLICATED_KEY CONDITION FOR 1062;
    DECLARE lvDuplicatedKey int default 0;
    DECLARE CONTINUE HANDLER FOR DUPLICATED_KEY set lvDuplicatedKey = 1;
    --
    insert into Pedaggio (
        CodSvincoloE, CodSvincoloU, Pedaggio
    ) VALUES (
        pCodSvincoloE, pCodSvincoloU, pPedaggio
    );
    --
    if lvDuplicatedKey = 1 then
        update Svincolo
           set Pedaggio = pPedaggio
         where CodSvincoloE = pCodSvincoloE
           and CodSvincoloU = pCodSvincoloU;
    end if;
END
//
DELIMITER ;