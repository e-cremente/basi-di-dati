USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.AggiornaStatoTragittoPrg;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE AggiornaStatoTragittoPrg(
pCodTragitto varchar(12)
)

AggiornaStatoTragittoPrg:BEGIN
	--
    DECLARE lvQtaUrbana int;
    DECLARE lvQtaExtraurbana int;
    -- Conto la quantita di Strade Urbane e di Strade Extraurbane presenti nel tragitto
    select sum(if(CodClassTec = 'SUR', 1, 0)),
           sum(if(CodClassTec = 'SXP' 
               or CodClassTec = 'SXS' 
               or CodClassTec = 'AUT', 1, 0)) 
      into lvQtaUrbana, lvQtaExtraurbana    
      from Tratta T
           natural join TrattaTragittoPrg TTP
           inner join Strada S on (S.CodStrada = T.CodStrada)
     where TTP.CodTragitto = pCodTragitto;      
    -- Aggiorno il valore dello Stato in TragittoProgrammato    
    if lvQtaUrbana > 0 and lvQtaExtraurbana = 0 then
        update TragittoProgrammato
           set TipoPercorso = 'U'
         where CodTragitto = pCodTragitto;
    elseif lvQtaUrbana = 0 and lvQtaExtraurbana > 0 then
        update TragittoProgrammato
           set TipoPercorso = 'X'
         where CodTragitto = pCodTragitto;     
    elseif lvQtaUrbana > 0 and lvQtaExtraurbana > 0 then
        update TragittoProgrammato
           set TipoPercorso = 'M'
         where CodTragitto = pCodTragitto;     
    end if;
END//

delimiter ;