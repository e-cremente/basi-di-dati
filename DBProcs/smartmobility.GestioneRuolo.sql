USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.GestioneRuolo;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE GestioneRuolo(
pCodFiscale varchar(16),
pRuolo varchar(16),
pOperazione varchar(8)
)
--
GestioneRuolo:BEGIN
    DECLARE CODFISCALE_INESISTENTE CONDITION FOR SQLSTATE '45000';
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    if EsisteUtente(pCodFiscale) = 'N' then
        SIGNAL CODFISCALE_INESISTENTE
           SET MESSAGE_TEXT = 'Utente non è registrato';
    end if;
    --
    if pOperazione = 'GRANT' then
        if pRuolo = 'FRUITORE' then
            set pCodFiscale = ChkInsFruitore(pCodFiscale);
        elseif pRuolo = 'PROPONENTE' then
            set pCodFiscale = ChkInsProponente(pCodFiscale);
        end if;
    elseif pOperazione = 'REVOKE' then
        if pRuolo = 'FRUITORE' then
            delete from Fruitore where CodFiscale = pCodFiscale;
        elseif pRuolo = 'PROPONENTE' then
            delete from Proponente where CodFiscale = pCodFiscale;
        end if;
    end if;
 END
//
DELIMITER ;
