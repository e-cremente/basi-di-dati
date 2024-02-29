USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.ValutaChiamata;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE ValutaChiamata(
pCodChiamata varchar(12),
pStato varchar(8),
pDataOraRisposta datetime
)
--
ValutaChiamata:BEGIN
    DECLARE CHIAMATA_INESISTENTE CONDITION FOR SQLSTATE '45000';
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    if EsisteChiamata(pCodChiamata) = 'N' then
        SIGNAL CHIAMATA_INESISTENTE SET MESSAGE_TEXT = 'ValutaChiamata: Chiamata inesistente';
    end if;
    --
    call UpdStatoChiamata(pCodChiamata, pStato, pDataOraRisposta);
 END
//
DELIMITER ;
