USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.RegistraValutazione;

delimiter //
CREATE DEFINER=root@localhost FUNCTION RegistraValutazione(
pCFUtenteGiudicante varchar(16),
pRuoloUtenteGiudicante char(1),
pCFUtenteGiudicato varchar(16),
pRuoloUtenteGiudicato char(1),
pCodTragitto varchar(12),
pServizio varchar(32),
pRecensione varchar(256)
) RETURNS VARCHAR(12)
--
RegistraValutazione:BEGIN
    DECLARE TRAGITTO_INESISTENTE CONDITION FOR SQLSTATE '45000';
    DECLARE lvCodValutazione varchar(12);
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    if pCodTragitto is not null then
        if pServizio = 'CAR_SHARING' and EsisteTragitto(pCodTragitto) = 'N' then
            SIGNAL TRAGITTO_INESISTENTE
               SET MESSAGE_TEXT = 'Tragitto inesistente per il servizio CAR_SHARING';
        elseif pServizio = 'CAR_POOLING' and EsisteTragitto(pCodTragitto) = 'N' then
            SIGNAL TRAGITTO_INESISTENTE
               SET MESSAGE_TEXT = 'Tragitto inesistente per il servizio CAR_POOLING';
        elseif pServizio = 'RIDE_SHARING_ON_DEMAND' and EsisteTragitto(pCodTragitto) = 'N' then
            SIGNAL TRAGITTO_INESISTENTE
               SET MESSAGE_TEXT = 'Tragitto inesistente per il servizio RIDE_SHARING_ON_DEMAND';
        end if;
    end if;
    --
    set lvCodValutazione = ChkInsValutazione(pCFUtenteGiudicante, pRuoloUtenteGiudicante,
        pCFUtenteGiudicato, pRuoloUtenteGiudicato, pCodTragitto, pServizio, pRecensione);
    --
    return lvCodValutazione;
END
//
DELIMITER ;
