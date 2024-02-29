USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.EliminaUtente;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE EliminaUtente(
pCodFiscale varchar(16)
)
--
EliminaUtente:BEGIN
    DECLARE UTENTE_INESISTENTE CONDITION FOR SQLSTATE '45000';
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    if EsisteUtente(pCOdFiscale) = 'N' then
        SIGNAL UTENTE_INESISTENTE SET MESSAGE_TEXT = 'Utente inesistente';
    end if;
    -- Elimiamo i L'account dell'utente
    delete from Account
     where CodFiscale = pCodFiscale;
    -- Eliminiamo il Documento di Riconoscimento dell'autovettura
    delete from DocumentoRiconoscimento
     where CodFiscale = pCodFiscale;
    -- Eliminiamo l'utente
    delete from Utente
     where CodFiscale = pCodFiscale;
 END
//
DELIMITER ;
