USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.InsUpdAutovettura;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE InsUpdAutovettura(
pNumTarga varchar(8),
pCFProponente varchar(16),
pNumPosti decimal(2),
pCilindrata decimal(5),
pAnnoImmatricolazione decimal(4),
pCasaProduttrice varchar(32),
pModello varchar(32),
pComfort decimal(3,2),
pVelocitaMax decimal(5,2),
pCapacitaSerbatoio decimal(3),
pTipoAlimentazione varchar(16)
)
--
InsUpdAutovettura:BEGIN
    DECLARE DUPLICATED_KEY CONDITION FOR 1062;
    DECLARE ERRORE CONDITION FOR SQLSTATE '45000';
    DECLARE lvDuplicatedKey int default 0;
    DECLARE CONTINUE HANDLER FOR DUPLICATED_KEY set lvDuplicatedKey = 1;
    --
    insert into Autovettura (
        NumTarga, CasaProduttrice, Modello
    ) VALUES (
        pNumTarga, pCasaProduttrice, pModello
    );
    --
    if lvDuplicatedKey = 1 then
        update Autovettura
           set CasaProduttrice = pCasaProduttrice,
               Modello = pModello
         where NumTarga = pNumTarga;
        --
        update AutovetturaRegistrata
           set CodFiscale = pCFProponente,
               NumPosti = pNumPosti,
               Cilindrata = pCilindrata,
               AnnoImmatricolazione = pAnnoImmatricolazione,
               CasaProduttrice = pCasaProduttrice,
               Modello = pModello,
               Comfort = pComfort,
               VelocitaMax = pVelocitaMax,
               CapacitaSerbatoio = pCapacitaSerbatoio,
               TipoAlimentazione = pTipoAlimentazione
         where NumTarga = pNumTarga;
    else
        insert into AutovetturaRegistrata (
            NumTarga, CodFiscale, NumPosti, Cilindrata, AnnoImmatricolazione,
            Comfort, VelocitaMax, CapacitaSerbatoio, TipoAlimentazione
        ) VALUES (
            pNumTarga, pCFProponente, pNumPosti, pCilindrata, pAnnoImmatricolazione,
            pComfort, pVelocitaMax, pCapacitaSerbatoio, pTipoAlimentazione
        );
    end if;
END
//
DELIMITER ;
