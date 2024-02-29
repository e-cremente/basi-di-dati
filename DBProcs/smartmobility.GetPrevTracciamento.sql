USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.GetPrevTracciamento;

delimiter //
/***********************************************************************
** GetPrevTracciamento()
***********************************************************************/
CREATE DEFINER=root@localhost PROCEDURE GetPrevTracciamento(
pNumTarga  varchar(8),
pTimestamp datetime,
out poCodTracciamento varchar(12),
out poTimestamp datetime,
out poLatitudine decimal(10,7),
out poLongitudine decimal(10,7),
out poChilometro decimal(9,3),
-- Strada
out poNazione varchar(2),
out poRegione varchar(3),
out poProvincia varchar(4),
out poComune varchar(64),
-- Strada URBANA
out poDUG varchar(32),
out poNomeStd varchar(64),
-- Strada EXTRAURBANA
out poTipoStrada varchar(2),
out poCategStrada varchar(8),
out poNumero int(11),
out poNome varchar(64)
)
--
GetPrevTracciamento:BEGIN
    select TR.CodTracciamento, TR.Timestamp, TR.Latitudine, TR.Longitudine,
           TR.Chilometro, TR.Nazione, TR.Regione, TR.Provincia, TR.Comune,
           TR.DUG, TR.NomeStd,
           TR.TipoStrada, TR.CategStrada, TR.Numero, TR.Nome
      into poCodTracciamento, poTimestamp, poLatitudine, poLongitudine,
           poChilometro, poNazione, poRegione, poProvincia, poComune,
           poDUG, poNomeStd,
           poTipoStrada, poCategStrada, poNumero, poNome
      from smartmobility.Tracciamento TR
     where TR.NumTarga = pNumTarga
       and TR.Timestamp = (
               select max(T.Timestamp)
                 from smartmobility.Tracciamento T
                where T.NumTarga = TR.NumTarga
                  and T.Timestamp < pTimestamp
           );
END
//
DELIMITER ;
