USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.ChkInsValutazione;

delimiter //
CREATE DEFINER=root@localhost FUNCTION ChkInsValutazione(
pCFUtenteGiudicante varchar(16),
pRuoloUtenteGiudicante char(1),
pCFUtenteGiudicato varchar(16),
pRuoloUtenteGiudicato char(1),
pCodTragitto varchar(12),
pServizio varchar(32),
pRecensione varchar(256)
) RETURNS char(12)
--
ChkInsValutazione:BEGIN
    DECLARE lvCodValutazione varchar(12) default NULL;
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select CodValutazione
      into lvCodValutazione
      from Valutazione
     where CFUtenteGiudicante = pCFUtenteGiudicante
       and RuoloUtenteGiudicante = pRuoloUtenteGiudicante
       and CFUtenteGiudicato = pCFUtenteGiudicato
       and RuoloUtenteGiudicato = pRuoloUtenteGiudicato
       and CodTragitto = pCodTragitto
       and Servizio = pServizio;
    --
    if lvRecNotFound = 1 then
        set lvCodValutazione = NewProgressivo('VAL', 'Valutazione');
        insert into Valutazione (
            CodValutazione, CFUtenteGiudicante, RuoloUtenteGiudicante, CFUtenteGiudicato, RuoloUtenteGiudicato, CodTragitto, Servizio, Recensione
        ) VALUES (
            lvCodValutazione, pCFUtenteGiudicante, pRuoloUtenteGiudicante, pCFUtenteGiudicato, pRuoloUtenteGiudicato, pCodTragitto, pServizio, pRecensione
        );
    end if;
    --
    return lvCodValutazione;
END
//
DELIMITER ;
