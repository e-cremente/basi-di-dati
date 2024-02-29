USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.CloseTrattaTracciata;

delimiter //
CREATE DEFINER=`root`@`localhost` PROCEDURE CloseTrattaTracciata(
pCodTratta varchar(32),
pCodPosizioneFin varchar(12),
pCodTracciamentoU varchar(12),
pDataOraUscita datetime
)
--
CloseTrattaTracciata:BEGIN
    DECLARE lvLunghezzaTratta DECIMAL(9,3);
    DECLARE lvDataOraEntrata datetime;
    DECLARE lvDataOraUscita datetime;
    DECLARE lvTempoImpiegato INT;
    DECLARE lvTempoMedio decimal(13,2);
    DECLARE lvCodFascia varchar(12);
    DECLARE lvCodPosizioneIni varchar(12);
    DECLARE lvCodTrattaDaUsare varchar(12);
    DECLARE lvCodAltraTratta varchar(12);
    DECLARE lvCodTracciamentoE varchar(12);
    DECLARE lvNewDataOraEntrata datetime;
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    set lvCodTrattaDaUsare = pCodTratta;
    -- Determino la posizione iniziale della tratta
    select CodPosizioneIni
      into lvCodPosizioneIni
      from tratta T
	 where CodTratta = pCodTratta;
	-- Determino se esista già una tratta (diversa da pCodTratta) che abbia le stesse posizioni iniziale e finale
    set lvRecNotFound = 0;
    select CodTratta
      into lvCodAltraTratta
      from tratta T
	 where CodPosizioneIni = lvCodPosizioneIni
       and CodPosizioneFin = pCodPosizioneFin;
	--
    if lvRecNotFound = 1 then -- LA TRATTA DESIDERATA NON ESISTE
		-- Determiniamo la lunghezza della tratta da chiudere
		select abs(FIN.Chilometro - INI.Chilometro)
		  into lvLunghezzaTratta
		  from Posizione FIN,
			   Tratta T
			   inner join Posizione INI on (INI.CodPosizione = T.CodPosizioneIni)
		 where FIN.CodPosizione = pCodPosizioneFin
		   and T.CodTratta = pCodTratta;
		-- Chiudiamo la Tratta
		update Tratta
		   set Lunghezza = lvLunghezzaTratta,
			   CodPosizioneFin = pCodPosizioneFin
		 where CodTratta = pCodTratta;
		--
	else -- LA TRATTA DESIDERATA ESISTE (ed è lvCodAltraTratta)
		set lvCodTrattaDaUsare = lvCodAltraTratta;
        -- 
	end if;
	-- Recupero la DataOraEntrata nella tratta
	select DataOraEntrata
	  into lvNewDataOraEntrata
	  from TrattaTracciata
	 where CodTratta = pCodTratta;
    --
	update TrattaTracciata
	   set CodTratta = lvCodTrattaDaUsare,
		   DataOraUscita = pDataOraUScita,
		   CodTracciamentoU = pCodTracciamentoU
	 where CodTratta = pCodTratta
	   and DataOraEntrata = lvNewDataOraEntrata;
	-- Cancella la tratta inutile
    if lvCodTrattaDaUsare != pCodTratta then
		delete from tratta where CodTratta = pCodTratta;
    end if;
    -- Calcoliamo il tempo (come numero di secondi) impiegato a percorrere la tratta
    select DataOraEntrata, DataOraUscita, TimestampDiff(SECOND, DataOraEntrata, DataOraUscita)
      into lvDataOraEntrata, lvDataoraUscita, lvTempoImpiegato
      from TrattaTracciata
     where CodTratta = lvCodTrattaDaUsare
       and DataOraEntrata = lvNewDataOraEntrata;
    -- Memorizziamo il tempo impiegato nella tabella TrattaPercorsa
    insert into TrattaPercorsa (
        CodTratta, DataOraInserimento, TempoPercorrenza
    ) VALUES (
        lvCodTrattaDaUsare, current_timestamp(), lvTempoImpiegato
    );
    -- Calcolo il tempo medio di tutti i tempi di percorrenza della tratta
    -- inseriti nella fascia oraria a cui appartiene pDataOraUScita
    select FO.CodFascia, avg(TP.TempoPercorrenza)
      into lvCodFascia, lvTempoMedio
      from TrattaPercorsa TP
           inner join FasciaOraria FO on (
               time(pDataOraUscita) >= FO.OraIni
               and time(pDataOraUscita) < FO.OraFin
           )
     where TP.CodTratta = lvCodTrattaDaUsare
     group by FO.CodFascia;
    --
    call smartmobility.UpdInsTrattaTemporizzata(lvCodTrattaDaUsare, lvCodFascia, lvTempoMedio);
END
//
DELIMITER ;
