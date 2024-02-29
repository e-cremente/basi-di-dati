USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.InsUpdDocumentoRiconoscimento;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE InsUpdDocumentoRiconoscimento(
pCodFiscale varchar(16),
pTipoDocumento varchar(3),
pEnteRilascio varchar(64),
pNumeroDocumento varchar(16),
pScadenza date
)
--
InsUpdDocumentoRiconoscimento:BEGIN
    DECLARE DUPLICATED_KEY CONDITION FOR 1062;
    DECLARE lvDuplicatedKey int default 0;
    DECLARE CONTINUE HANDLER FOR DUPLICATED_KEY set lvDuplicatedKey = 1;
    --
    insert into DocumentoRiconoscimento (
        CodFiscale, TipoDocumento, EnteRilascio, NumeroDocumento, Scadenza
    ) VALUES (
        pCodFiscale, pTipoDocumento, pEnteRilascio, pNumeroDocumento, pScadenza
    );
    --
    if lvDuplicatedKey = 1 then
        update DocumentoRiconoscimento
           set TipoDocumento = pTipoDocumento,
               EnteRilascio = pEnteRilascio,
               NumeroDocumento = pNumeroDocumento,
               Scadenza = pScadenza
         where CodFiscale = pCodFiscale;
    end if;
END
//
DELIMITER ;
