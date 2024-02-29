USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.RegistraAutovettura;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE RegistraAutovettura(
-- Dati per la tabella Autovettura
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
pTipoAlimentazione varchar(16),
-- Dati per la tabella CostoAutovettura (per 1 passeggero)
pCostoOperativo decimal(12,5),
pCostoUsura decimal(12,5),
pConsumoU decimal(5,3),
pConsumoXU decimal(5,3),
pConsumoM decimal(5,3)
)
--
RegistraAutovettura:BEGIN
    DECLARE AUTOVETTURA_ESISTENTE CONDITION FOR SQLSTATE '45000';
    DECLARE lvIdx int;
    DECLARE lvFact decimal(4,3);
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION begin
        GET DIAGNOSTICS CONDITION 1 @p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
        select @p1, @p2;
        ROLLBACK;
    end;
    --
    if EsisteAutovettura(pNumTarga) = 'S' then
        SIGNAL AUTOVETTURA_ESISTENTE
           SET MESSAGE_TEXT = 'Autovettura già registrata';
    end if;
    --
    START TRANSACTION;
    call GestioneRuolo(pCFProponente, 'PROPONENTE', 'GRANT');
    call InsUpdAutovettura(pNumTarga, pCFProponente, pNumPosti, pCilindrata, pAnnoImmatricolazione, pCasaProduttrice, pModello, pComfort, pVelocitaMax, pCapacitaSerbatoio, pTipoAlimentazione);
    call InsUpdCostoAutovettura(pNumTarga, 1, pCostoOperativo, pCostoUsura, pConsumoU, pConsumoXU, pConsumoM);
    set lvIdx = 2;
    set lvFact = 1.025;
    while lvIdx <= pNumPosti do
        set pCostoOperativo = pCostoOperativo * lvFact;
        set pCostoUsura = pCostoUsura * lvFact;
        set pConsumoU = pConsumoU * lvFact;
        set pConsumoXU = pConsumoXU * lvFact;
        set pConsumoM = pConsumoM * lvFact;
        call InsUpdCostoAutovettura(pNumTarga, lvIdx, pCostoOperativo, pCostoUsura, pConsumoU, pConsumoXU, pConsumoM);
        set lvIdx = lvIdx + 1;
    end while;
    COMMIT;
 END
//
DELIMITER ;
