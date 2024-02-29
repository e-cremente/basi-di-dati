USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.UpdStatoChiamata;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE UpdStatoChiamata(
pCodChiamata varchar(12),
pStato varchar(8),
pDataOraRisposta datetime
)
--
UpdStatoChiamata:BEGIN
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    update Chiamata
       set Stato = pStato,
		   DataOraRisposta = pDataOraRisposta
     where CodChiamata = pCodChiamata;
    --
    if lvRecNotFound = 1 then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UpdStatoChiamata: Chiamata inesistente';
    end if;
END
//
DELIMITER ;