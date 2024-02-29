USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.RegistraUtente;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE RegistraUtente(
-- Dati per la tabella Utente
pCodFiscale varchar(16),
pCognome varchar(64),
pNome varchar(64),
pTelefono varchar(16),
-- Dati per la tabella Indirizzo
pNazione varchar(2),
pRegione varchar(3),
pProvincia varchar(4),
pComune varchar(64),
pCAP varchar(5),
pDUG varchar(32),
pNomeStd varchar(64),
pCivico varchar(16),
pEsponente varchar(16),
-- Dati per la tabella DocumentoRiconoscimento
pTipoDocumento varchar(3),
pEnteRilascio varchar(64),
pNumeroDocumento varchar(16),
pScadenza date,
-- Dati per la tabella Account
pUsername varchar(32),
pPassword varchar(16),
pDomandaRiserva varchar(128),
pRisposta varchar(128)
)
--
RegistraUtente:BEGIN
    DECLARE CODFISCALE_ESISTENTE CONDITION FOR SQLSTATE '45000';
    DECLARE USERNAME_ESISTENTE CONDITION FOR SQLSTATE '45000';
    DECLARE lvCodStrada varchar(12) default NULL;
    DECLARE lvCodIndirizzo varchar(12) default NULL;
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    if EsisteUtente(pCodFiscale) = 'S' then
        SIGNAL CODFISCALE_ESISTENTE
           SET MESSAGE_TEXT = 'Utente già presente';
    end if;
    --
    if EsisteUsername(pUsername) = 'S' then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Username già assegnato ad altro utente';
    end if;
    --
    set lvCodStrada = ChkInsStradaUR(pDUG, pNomeStd, pComune, pProvincia, pRegione, pNazione, pCAP, 0, 1, 'SUR');
    set lvCodIndirizzo = ChkInsIndirizzo(lvCodStrada, pCivico, pEsponente);
    call InsUpdUtente(pCodFiscale, pCognome, pNome, lvCodIndirizzo, pTelefono, 'INATTIVO');
    call InsUpdAccount(pCodFiscale, pUsername, pPassword, pDomandaRiserva, pRisposta);
    call InsUpdDocumentoRiconoscimento(pCodFiscale, pTipoDocumento, pEnteRilascio, pNumeroDocumento, pScadenza);
 END
//
DELIMITER ;
