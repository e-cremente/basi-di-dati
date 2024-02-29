USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.AggiornaCostoPool;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE AggiornaCostoPool(
pCodPool varchar(16),
pCostoCarburante decimal(6,4), -- EUR/LITRO
pMotivo varchar(16) -- ACCETTAZIONE | RINUNCIA
)
--
AggiornaCostoPool:BEGIN
    DECLARE POOL_INESISTENTE CONDITION FOR SQLSTATE '45000';
    DECLARE lvNumTarga varchar(8);
    DECLARE lvSpesa decimal(9,2);
    DECLARE lvPostiDisponibili decimal(2);
    DECLARE lvLunghezza decimal(9,3);
    DECLARE lvTipoPercorso char(1);
    DECLARE lvNumPostiTotali decimal(2);
    DECLARE lvNumPasseggeri decimal(2);
    DECLARE lvCostoOperativo decimal(9,2);
    DECLARE lvCostoUsura decimal(9,2);
    DECLARE lvConsumoU decimal(5,3);
    DECLARE lvConsumoXU decimal(5,3);
    DECLARE lvConsumoM decimal(5,3);
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    -- Recupero le informazioni necessarie per iil calcolo del costo
    select DT.Lunghezza, DT.TipoPercorso, DT.NumTarga, DT.NumPosti, DT.NumPasseggeri,
           C.CostoOperativo, C.CostoUsura, C.ConsumoU, C.ConsumoXU, C.ConsumoM
      into lvLunghezza, lvTipoPercorso, lvNumTarga, lvNumPostiTotali, lvNumPasseggeri,
           lvCostoOperativo, lvCostoUsura, lvConsumoU, lvConsumoXU, lvConsumoM
      from (select T.Lunghezza, T.TipoPercorso, P.NumTarga, A.NumPosti,
                   A.NumPosti - P.PostiDisponibili + case pMotivo when 'ACCETTAZIONE' then +1 when 'RINUNCIA' then -1 else 0 end NumPasseggeri
              from Pool P
                   inner join TragittoProgrammato T on (
                       T.CodTragitto = P.CodTragittoPrg
                   )
                   inner join AutovetturaRegistrata A on (
                       A.NumTarga = P.NumTarga
                   )
             where P.CodPool = pCodPool
            ) DT
            inner join CostoAutovettura C on (
                C.NumTarga = DT.NumTarga
                and C.NumPasseggeri = DT.NumPasseggeri
            );
    -- Testiamo per assicurarci che il pool sia stato trovato
    if lvRecNotFound = 1 then
        SIGNAL POOL_INESISTENTE
           SET MESSAGE_TEXT = 'Pool inesistente';
    end if;
    -- Calcoliamo la spesa dovuta al consumo di carburante sul tipo di percorso determinato
    set lvSpesa = (lvLunghezza/100) *
        (case lvTipoPercorso when 'U' then lvConsumoU when 'X' then lvConsumoXU when 'M' then lvConsumoM end) *
        pCostoCarburante;
    -- Aggiungiamo i costi operativi e di usura dipendenti dalla lunghezza del tragitto
    set lvSpesa = lvSpesa + (lvCostoOperativo + lvCostoUsura) * lvLunghezza;
    -- Aggiorniamo la tabella Pool con la nuova spesa calcolata e con il numero di passeggeri modificati in seguito alla accettazione/rinuncia verificatasi
    update Pool
       set Spesa = lvSpesa,
           PostiDisponibili = lvNumPostiTotali - lvNumPasseggeri
     where CodPool = pCodPool;
END
//
DELIMITER ;
