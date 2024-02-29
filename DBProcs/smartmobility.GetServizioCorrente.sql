USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.GetServizioCorrente;

delimiter //
/**********************************************************************
** PROCEDURE GetServizioCorrente
** La funzione, data la targa di una vettura e un istante nel tempo,
** determina il servizio in cui è coinvolta la vettura in quel momento.
** l'algoritmo cerca un servizio che è iniziato prima dell'istante
** passato e non ancora concluso.
**********************************************************************/
CREATE DEFINER=root@localhost PROCEDURE GetServizioCorrente(
pNumTarga varchar(8),
pDataOra  datetime,
out pServizio varchar(12),
out pCodServizio varchar(12)
)
GetServizioCorrente:BEGIN
    DECLARE lvRecFound int default 1;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecFound = 0;
    set pServizio = NULL;
    set pCodServizio = NULL;
    -- Tentiamo il servizio di Car Sharing
    select NCS.CodNoleggio, 'CarSharing'
      into pCodServizio, pServizio
      from Noleggio NCS
           inner join PrenotazioneCS PCS on (PCS.CodPrenotazione = NCS.CodPrenotazione)
     where PCS.NumTarga = pNumTarga
       and PCS.DataIni <= date(pDataOra)
       and PCS.DataFin >= date(pDataOra);
    --
    if lvRecFound = 1 then leave GetServizioCorrente; end if;
    -- Tentiamo il servizio di Car Pooling
    select P.CodPool, 'CarPooling'
      into pCodServizio, pServizio
      from Pool P
     where P.NumTarga = pNumTarga
       and timestamp(P.DataPartenza, P.OraPartenza) <= pDataOra
       and P.DataArrivo is null;
    --
    if lvRecFound = 1 then leave GetServizioCorrente; end if;
    -- Tentiamo il servizio di Ride Sharing On Demand
    select S.CodSharing, 'RideSharing'
      into pCodServizio, pServizio
      from Corsa C
           inner join Chiamata CH on (CH.CodChiamata = C.CodChiamata)
           inner join Sharing S on (S.CodSharing = CH.CodSharing)
     where S.NumTarga = pNumTarga
       and C.DataOraInizioCorsa <= pDataOra
       and C.DataOraFineCorsa is null;
    --
    if lvRecFound = 1 then leave GetServizioCorrente; end if;
    --
END
//
DELIMITER ;
