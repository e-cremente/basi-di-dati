USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.InsTracciamento;

delimiter //
CREATE DEFINER=root@localhost FUNCTION InsTracciamento(
  pNumTarga  varchar(8),
  pTimestamp datetime,
  pLatitudine decimal(10,7),
  pLongitudine decimal(10,7),
  pChilometro decimal(9,3),
  -- Strada
  pNazione varchar(2),
  pRegione varchar(3),
  pProvincia varchar(4),
  pComune varchar(64),
  -- Strada URBANA
  pDUG varchar(32),
  pNomeStd varchar(64),
  -- STrada EXTRAURBANA
  pTipoStrada varchar(2),
  pCategStrada varchar(8),
  pNumero int(11),
  pNome varchar(64)
) RETURNS char(12)
--
InsTracciamento:BEGIN
    declare lvCodTracciamento varchar(12);
    set lvCodTracciamento = smartmobility.NewProgressivo('TRC', 'Tracciamento');
    --
    insert into smartmobility.Tracciamento (
        CodTracciamento, NumTarga, Timestamp, Latitudine, Longitudine,
        Chilometro, Nazione, Regione, Provincia, Comune,
        DUG, NomeStd, TipoStrada, CategStrada, Numero,
        Nome
    ) VALUES (
        lvCodTracciamento, pNumTarga, pTimestamp, pLatitudine, pLongitudine,
        pChilometro, pNazione, pRegione, pProvincia, pComune,
        pDUG, pNomeStd, pTipoStrada, pCategStrada, pNumero,
        pNome
    );
    --
    return lvCodTracciamento;
END
//
DELIMITER ;
