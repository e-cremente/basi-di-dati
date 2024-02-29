USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.EliminaAutovettura;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE EliminaAutovettura(
pNumTarga varchar(8)
)
--
EliminaAutovettura:BEGIN
    DECLARE AUTOVETTURA_INESISTENTE CONDITION FOR SQLSTATE '45000';
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION begin
        ROLLBACK;
    end;
    --
    if EsisteAutovettura(pNumTarga) = 'N' then
        SIGNAL AUTOVETTURA_INESISTENTE
           SET MESSAGE_TEXT = 'Autovettura inesistente';
    end if;
    START TRANSACTION;
    -- Elimiamo i costi dell'autovettura
    delete from CostoAutovettura
     where NumTarga = pNumTarga;
    -- Eliminiamo gli optional dell'autovettura
    delete from OptionalAuto
     where NumTarga = pNumTarga;
    -- Eliminiamo l'autovettura registrata
    delete from AutovetturaRegistrata
     where NumTarga = pNumTarga;
    -- Eliminiamo l'autovettura
    delete from Autovettura
     where NumTarga = pNumTarga;
    COMMIT;
 END
//
DELIMITER ;
