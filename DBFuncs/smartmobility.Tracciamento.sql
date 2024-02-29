USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.Tracciamento;

delimiter //
/***********************************************************************
** Tracciamento()
** Gestisce un record di tracciamento arrivato dall'autovettura
** identificata da "pNumTarga", all'istante "pTimestamp".
** - Il primo record di tracciamento viene "innescato" dall'accensione
**   della vettura (pEvento = ACCENSIONE).
** - L'ultimo record di tracciamento viene "innescato" dallo spegnimento
**   della vettura (pEvento = SPEGNIMENTO).
** - Tutti i record di tracciamento intermedi vengono inviati dalla
**   sensoristica di bordo ad intervalli di tempo regolari (15 sec?
**   30sec? 60sec?) (pEvento = PERIODICO).
** Ipotizziamo che l'equipaggiamento di bordo (navigatore, gps, app,
** ...) sia in grado di individuare la strada su cui si trova la
** vettura fornendo esclusivamente, nel caso di strada urbana, DUG e
** NomeStd [VIA, GIUSEPPE GARIBALDI], mentre, nel caso di strada
** Extraurbana, Tipo, eventuale Categoria, Numero ed eventuale Nome
** della strada [SS, var, 1, AURELIA]
***********************************************************************/
CREATE DEFINER=root@localhost FUNCTION Tracciamento(
  pNumTarga  varchar(8),      -- Numero targa della vettura che ha inviato i dati di tracciamento,
  pTimestamp datetime,        -- Data e ora del momento in cui la vettura ha inviato i dati di tracciamento,
  pEvento varchar(16),        -- Evento che ha "innescato" l'invocazione della procedura: ACCENSIONE | PERIODICO | SPEGNIMENTO
  pLatitudine decimal(10,7),  -- Latitudine della posizione dell'autovettura al momento dell'invio di questi dati di tracciamento,
  pLongitudine decimal(10,7), -- Longitudine della posizione dell'autovettura al momento dell'invio di questi dati di tracciamento,
  pChilometro decimal(9,3),   -- Chilometro della strada in cui si trova l'autovettura al momento dell'invio di questi dati di tracciamento,
  -- Strada
  pNazione varchar(2),        -- Nazione in cui si trova l'autovettura al momento dell'invio di questi dati di tracciamento,
  pRegione varchar(3),        -- Codice della regione in cui si trova l'autovettura al momento dell'invio di questi dati di tracciamento,
  pProvincia varchar(4),      -- Sigla della provincia in cui si trova l'autovettura al momento dell'invio di questi dati di tracciamento,
  pComune varchar(64),        -- Comune in cui si trova l'autovettura al momento dell'invio di questi dati di tracciamento,
  pNumCarreggiata decimal(2), -- Numero della carreggiata della strada in cui si trova l'autovettura al momento dell'invio di questi dati di tracciamento 
  -- Strada URBANA
  pDUG varchar(32),           -- Dug della strada URBANA in cui si trova l'autovettura al momento dell'invio di questi dati di tracciamento,
  pNomeStd varchar(64),       -- Nome standard della strada URBANA in cui si trova l'autovettura al momento dell'invio di questi dati di tracciamento,
  -- Strada EXTRAURBANA
  pTipoStrada varchar(2),     -- Tipo della strada EXTRAURBANA in cui si trova l'autovettura al momento dell'invio di questi dati di tracciamento,
  pCategStrada varchar(8),    -- Categoria della strada EXTRAURBANA in cui si trova l'autovettura al momento dell'invio di questi dati di tracciamento,
  pNumero int(11),            -- Numero della strada EXTRAURBANA in cui si trova l'autovettura al momento dell'invio di questi dati di tracciamento,
  pNome varchar(64)           -- Nome della strada EXTRAURBANA in cui si trova l'autovettura al momento dell'invio di questi dati di tracciamento,
) RETURNS VARCHAR(12)
--
Tracciamento:BEGIN
    declare lvCodTracciamento varchar(12);
    declare lvCodStrada varchar(12);
    declare lvServizio varchar(12);
    declare lvCodServizio varchar(12);
    declare lvCodTragitto varchar(12);
    declare lvPosizioneIniTragitto varchar(12);
    declare lvPosizioneFinTragitto varchar(12);
    declare lvPosizioneIniTratta varchar(12);
    declare lvPosizioneFinTratta varchar(12);
    declare lvCodTratta varchar(12);
    --
    declare lvPrevCodStrada varchar(12);
    -- Precedente tratta e record di tracciamento
    declare lvPrevCodTratta varchar(12);
    declare lvPrevCodTracciamento varchar(12);
    declare lvPrevTimestamp datetime;
    declare lvPrevLatitudine decimal(10,7);  -- Latitudine della posizione dell'autovettura al momento dell'invio di questi dati di tracciamento,
    declare lvPrevLongitudine decimal(10,7);
    declare lvPrevChilometro decimal(9,3);
    declare lvPrevNazione varchar(2);
    declare lvPrevRegione varchar(3);
    declare lvPrevProvincia varchar(4);
    declare lvPrevComune varchar(64);
    declare lvPrevNumCarreggiata decimal(2);
    declare lvPrevDUG varchar(32);
    declare lvPrevNomeStd varchar(64);
    declare lvPrevTipoStrada varchar(2);
    declare lvPrevCategStrada varchar(8);
    declare lvPrevNumero int(11);
    declare lvPrevNome varchar(64);
    -- Inseriamo il record di tracciamento appena arrivato
    set lvCodTracciamento = smartmobility.InsTracciamento(
        pNumTarga, pTimestamp, pLatitudine, pLongitudine, pChilometro,
        pNazione, pRegione, pProvincia, pComune, pDUG,
        pNomeStd, pTipoStrada, pCategStrada, pNumero, pNome);
    --
    -- Recuperiamo il codice della strada su cui si trova l'autovettura
    -- N.B. Se la strada non esiste viene creata con:
    -- Lunghezza = 0, NumCarreggiate = 1
    if (pDUG is not null and pNomeStd is not null) then -- STRADA URBANA
        set lvCodStrada = smartmobility.ChkInsStradaUR(
            pDUG, pNomeStd, pComune, pProvincia, pRegione, pNazione, NULL, 0, 1, NULL);
    elseif (pTipoStrada is not null and pNumero is not null) then -- STRADA EXTRAURBANA
        set lvCodStrada = smartmobility.ChkInsStradaXU(
            pTipoStrada, pCategStrada, pNumero, NULL, pNome, 0, 1, NULL);
    end if;
    -- Controlliamo se esiste la carreggiata della strada
    -- N.B. Se la carreggiata non esiste la creiamo con 2 sensi di marcia e 1 corsia per senso di marcia
    call smartmobility.ChkInsCarreggiata(lvCodSTrada, pNumCarreggiata, 1, 2);
    --
    if pEvento = 'ACCENSIONE' then
        -- Recuperiamo il servizio che sta facendo la vettura
        call smartmobility.GetServizioCorrente(pNumTarga, pTimestamp, lvServizio, lvCodServizio);
        -- Determino la posizione iniziale del tragitto
        set lvPosizioneIniTragitto = smartmobility.ChkInsPosizione(
            pLatitudine, pLongitudine, lvCodStrada, pChilometro, NULL);
        -- Creiamo il nuovo tragitto tracciato che sta per iniziare
        set lvCodTragitto = smartmobility.InsTragittoTracciato(lvPosizioneIniTragitto, lvServizio, lvCodServizio);
        -- Creiamo la posizione iniziale della nuova tratta tracciata
        set lvPosizioneIniTratta = smartmobility.ChkInsPosizione(
            pLatitudine, pLongitudine, lvCodStrada, pChilometro, NULL);
        -- Creiamo la nuova tratta tracciata
        set lvCodTratta = smartmobility.OpenTrattaTracciata(
            lvCodStrada, pNumCarreggiata, lvPosizioneIniTratta, lvCodTracciamento, pTimestamp);
        -- Leghiamo la tratta tracciata al tragitto tracciato dell'autovettura
        call smartmobility.InsTrattaTragittoTrc(lvCodTragitto, lvCodTratta, pTimestamp);
    elseif pEvento = 'PERIODICO' then
        -- Recuperiamo il codice del tragitto tracciato che sta facendo la vettura
        set lvCodTragitto = smartmobility.GetCodTragitto(pNumTarga, pTimestamp);
        -- Recuperiamo il record di tracciamento immediatamente precedente inviato dalla stessa auto
        call smartmobility.GetPrevTracciamento(
            pNumTarga, pTimestamp, lvPrevCodTracciamento, lvPrevTimestamp, lvPrevLatitudine, lvPrevLongitudine,
            lvPrevChilometro, lvPrevNazione, lvPrevRegione, lvPrevProvincia, lvPrevComune,
            lvPrevDUG, lvPrevNomeStd, lvPrevTipoStrada, lvPrevCategStrada, lvPrevNumero, lvPrevNome); 
        -- controlliamo se è cambiata la strada su cui si trova l'auto
        if (pNazione != lvPrevNazione or pRegione != lvPrevRegione or pProvincia != lvPrevProvincia or pComune != lvPrevComune
        or coalesce(pDUG, '@') != coalesce(lvPrevDUG, '@') or coalesce(pNomeStd, '@') != coalesce(lvPrevNomeStd, '@')
        or coalesce(pTipoStrada, '@') != coalesce(lvPrevTipoStrada, '@') or coalesce(pCategStrada, '@') != coalesce(lvPrevCategStrada, '@')
        or coalesce(pNumero, '@') != coalesce(lvPrevNumero, '@') or coalesce(pNome, '@') != coalesce(lvPrevNome, '@')) then
            -- La strada è cambiata
            if (lvPrevDUG is not null and lvPrevNomeStd is not null) then -- STRADA URBANA
                set lvPrevCodStrada = smartmobility.ChkInsStradaUR(
                    lvPrevDUG, lvPrevNomeStd, lvPrevComune, lvPrevProvincia, lvPrevRegione, lvPrevNazione, NULL, 0, 1, NULL);
             elseif (lvPrevTipoStrada is not null and lvPrevNumero is not null) then -- STRADA EXTRAURBANA
                set lvPrevCodStrada = smartmobility.ChkInsStradaXU(
                    lvPrevTipoStrada, lvPrevCategStrada, lvPrevNumero, NULL, lvPrevNome, 0, 1, NULL);
            end if;
            -- Chiudiamo la tratta precedente
            select TTT.CodTratta
              into lvPrevCodTratta
              from TrattaTragittoTrc TTT
             where TTT.CodTragitto = lvCodTragitto
               and TTT.DataOraEntrata = (
                       select max(T.DataOraEntrata)
                         from TrattaTragittoTrc T
                        where T.CodTragitto = TTT.CodTragitto
                   );
            --
            set lvPosizioneFinTratta = smartmobility.ChkInsPosizione(
                lvPrevLatitudine, lvPrevLongitudine, lvPrevCodStrada, lvPrevChilometro, NULL);
            call CloseTrattaTracciata(lvPrevCodTratta, lvPosizioneFinTratta, lvPrevCodTracciamento, lvPrevTimestamp);
            -- Apriamo una nuova tratta
            -- Creiamo la posizione iniziale della nuova tratta tracciata
            set lvPosizioneIniTratta = smartmobility.ChkInsPosizione(
                pLatitudine, pLongitudine, lvCodStrada, pChilometro, NULL);
            -- Creiamo la nuova tratta tracciata
            set lvCodTratta = smartmobility.OpenTrattaTracciata(
                lvCodStrada, pNumCarreggiata, lvPosizioneIniTratta, lvCodTracciamento, pTimestamp);
           -- Leghiamo la tratta tracciata al tragitto tracciato dell'autovettura
            call smartmobility.InsTrattaTragittoTrc(lvCodTragitto, lvCodTratta, pTimestamp);
        end if;
    elseif pEvento = 'SPEGNIMENTO' then -- Ipotesi: sullo SPEGNIMENTO non si ha cambio di strada!!!
        -- Recuperiamo il codice del tragitto tracciato che sta facendo la vettura
        set lvCodTragitto = smartmobility.GetCodTragitto(pNumTarga, pTimestamp);
        -- Chiudiamo la tratta corrente
        select TTT.CodTratta
          into lvCodTratta
          from TrattaTragittoTrc TTT
         where TTT.CodTragitto = lvCodTragitto
           and TTT.DataOraEntrata = (
                   select max(T.DataOraEntrata)
                     from TrattaTragittoTrc T
                    where T.CodTragitto = TTT.CodTragitto
               );
        -- recupero la posizione in cui è avvenuto lo spegnimento
        set lvPosizioneFinTratta = smartmobility.ChkInsPosizione(
            pLatitudine, pLongitudine, lvCodStrada, pChilometro, NULL);
        -- 
        call CloseTrattaTracciata(lvCodTratta, lvPosizioneFinTratta, lvCodTracciamento, pTimestamp);
        -- chiudiamo il tragitto assegnandogli una posizione di arrivo
        update Tragitto
           set CodPosizioneA = lvPosizioneFinTratta
         where CodTragitto = lvCodTragitto;
        --
    end if;
    return lvCodTracciamento;
END
//
DELIMITER ;
