USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.InsChiamata;

delimiter //
CREATE DEFINER=root@localhost FUNCTION InsChiamata(
pCFFruitore varchar(16),
pCodSharing varchar(12),
pCodPosizioneFruitore varchar(12),
pCodPosizioneDestinazione varchar(12),
pDataOraChiamata datetime,
pStato varchar(8),
pDataOraRisposta datetime
) RETURNS char(12)
--
InsChiamata:BEGIN
    DECLARE lvCodChiamata varchar(12) default NULL;
    --
	set lvCodChiamata = smartmobility.NewProgressivo('CMT', 'Chiamata');
	insert into Chiamata (
		CodChiamata, CFFruitore, CodSharing, CodPosizioneFruitore, CodPosizioneDestinazione, DataOraChiamata, Stato, DataOraRisposta
	) VALUES (
		lvCodChiamata, pCFFruitore, pCodSharing, pCodPosizioneFruitore, pCodPosizioneDestinazione, pDataOraChiamata, pStato, pDataOraRisposta
	);
    --
    return lvCodChiamata;
END
//
DELIMITER ;
