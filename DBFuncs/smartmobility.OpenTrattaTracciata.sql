USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.OpenTrattaTracciata;

delimiter //
CREATE DEFINER=`root`@`localhost` FUNCTION OpenTrattaTracciata(
pCodStrada varchar(32),
pNumCarreggiata tinyint,
pCodPosizioneIni varchar(12),
pCodTracciamentoE varchar(12),
pDataOraEntrata datetime
) RETURNS varchar(12)
--
OpenTrattaTracciata:BEGIN
    DECLARE lvCodTratta varchar(12);
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    set lvCodTratta = smartmobility.NewProgressivo('TRT', 'Tratta');
    insert into Tratta(
        CodTratta, CodStrada, NumCarreggiata, Lunghezza, CodPosizioneIni, CodPosizioneFin
    ) VALUES (
        lvCodTratta, pCodStrada, pNumCarreggiata, 0, pCodPosizioneIni, NULL
    );
    --
    insert into TrattaTracciata (
        CodTratta, DataOraEntrata, CodTracciamentoE, DataOraUscita, CodTracciamentoU
    ) VALUES (
        lvCodTratta, pDataOraEntrata, pCodTracciamentoE, NULL, NULL
    );
    return lvCodTratta;
END
//
DELIMITER ;
