USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.InsUpdUtente;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE InsUpdUtente(
pCodFiscale varchar(16),
pCognome varchar(64),
pNome varchar(64),
pCodIndirizzo varchar(12),
pTelefono varchar(16),
pStato varchar(8)
)
--
InsUpdUtente:BEGIN
    DECLARE DUPLICATED_KEY CONDITION FOR 1062;
    DECLARE lvDuplicatedKey int default 0;
    DECLARE CONTINUE HANDLER FOR DUPLICATED_KEY set lvDuplicatedKey = 1;
    --
    insert into Utente (
        CodFiscale, Cognome, Nome, CodIndirizzo, Telefono, Stato, DataIscrizione
    ) VALUES (
        pCodFiscale, pCognome, pNome, pCodIndirizzo, pTelefono, pStato, now()
    );
    --
    if lvDuplicatedKey = 1 then
        update Utente
           set Cognome = pCognome,
               Nome = pNome,
               CodIndirizzo = pCodIndirizzo,
               Telefono = pTelefono,
               Stato = pStato
         where CodFiscale = pCodFiscale;
    end if;
END
//
DELIMITER ;