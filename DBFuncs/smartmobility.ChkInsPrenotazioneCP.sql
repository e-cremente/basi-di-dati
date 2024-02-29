USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.ChkInsPrenotazioneCP;

delimiter //
CREATE DEFINER=root@localhost FUNCTION ChkInsPrenotazioneCP(
pCodPool varchar(12),
pCFFruitore varchar(16)
) RETURNS char(12)
--
ChkInsPrenotazioneCP:BEGIN
    DECLARE lvCodPrenotazione varchar(12) default NULL;
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select CodPrenotazione
      into lvCodPrenotazione
      from PrenotazioneCP
     where CFFruitore = pCFFruitore
       and CodPool = pCodPool;
    --
    if lvRecNotFound = 1 then
        call GestioneRuolo(pCFFruitore, 'FRUITORE', 'GRANT');
        set lvCodPrenotazione = smartmobility.NewProgressivo('PRN', 'Prenotazione');
        insert into PrenotazioneCP (
            CodPrenotazione, CodPool, CFFruitore, Stato
        ) VALUES (
            lvCodPrenotazione, pCodPool, pCFFruitore, 'NUOVA'
        );
    end if;
    --
    return lvCodPrenotazione;
END
//
DELIMITER ;
