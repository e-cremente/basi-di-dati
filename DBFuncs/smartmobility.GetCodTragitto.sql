USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.GetCodTragitto;

delimiter //
/**********************************************************************
** FUNCTION GetCodTragitto
** La funzione, data la targa di una vettura e un istante nel tempo,
** determina il codice del tragitto in cui è coinvolta la vettura in
** quel momento.
** l'algoritmo cerca un tragitto di un servizio che è iniziato prima
** dell'istante passato e non ancora concluso.
**********************************************************************/
CREATE DEFINER=root@localhost FUNCTION GetCodTragitto(
pNumTarga varchar(8),
pDataOra  datetime
) RETURNS varchar(16)
GetCodTragitto:BEGIN
    DECLARE lvCodTragitto varchar(12) default NULL;
    DECLARE lvRecFound int default 1;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecFound = 0;
    -- Tentiamo il servizio di Car Sharing
    select TTCS.CodTragitto
      into lvCodTragitto
      from TragittoTracciatoCS TTCS
           inner join Noleggio NCS on (NCS.CodNoleggio = TTCS.CodNoleggio)
           inner join PrenotazioneCS PCS on (PCS.CodPrenotazione = NCS.CodPrenotazione)
     where PCS.NumTarga = pNumTarga
       and PCS.DataIni <= date(pDataOra)
       and PCS.DataFin >= date(pDataOra);
    --
    if lvRecFound = 1 then return lvCodTragitto; end if;
    -- Tentiamo il servizio di Car Pooling
    select TT.CodTragitto
      into lvCodTragitto
      from TragittoTracciato TT
           inner join Pool P on (P.CodTragittoTrc = TT.CodTragitto)
     where P.NumTarga = pNumTarga
       and timestamp(P.DataPartenza, P.OraPartenza) <= pDataOra
       and date(pDataOra) <= P.DataArrivo;
    --
    if lvRecFound = 1 then return lvCodTragitto; end if;
    -- Tentiamo il servizio di Ride Sharing On Demand
    select TT.CodTragitto
      into lvCodTragitto
      from TragittoTracciato TT
           inner join Corsa C on (C.CodTragittoTrc = TT.CodTragitto)
           inner join Chiamata CH on (CH.CodChiamata = C.CodChiamata)
           inner join Sharing S on (S.CodSharing = CH.CodSharing)
	 where S.NumTarga = pNumTarga
       and C.DataOraInizioCorsa <= pDataOra
       and C.DataOraFineCorsa is null;
    --
    if lvRecFound = 1 then return lvCodTragitto; end if;
    --
    return lvCodTragitto;
END
//
DELIMITER ;
