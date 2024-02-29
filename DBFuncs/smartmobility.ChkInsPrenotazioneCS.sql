USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.ChkInsPrenotazioneCS;

delimiter //
CREATE DEFINER=root@localhost FUNCTION ChkInsPrenotazioneCS(
pCFFruitore varchar(16),
pNumTarga varchar(8),
pDataIni date,
pDataFin date
) RETURNS char(12)
--
ChkInsPrenotazioneCS:BEGIN
    DECLARE lvCodPrenotazione varchar(12) default NULL;
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select CodPrenotazione
      into lvCodPrenotazione
      from PrenotazioneCS
     where CFFruitore = pCFFruitore
       and NumTarga = pNumTarga
       and DataIni = pDataIni;
    --
    if lvRecNotFound = 1 then
        -- TODO: Controllare che il periodo della prenotazione [DataIni, DataFin] sia compatibile con (l'agenda della) fruibilità dell'autovettura
        call GestioneRuolo(pCFFruitore, 'FRUITORE', 'GRANT');
        set lvCodPrenotazione = smartmobility.NewProgressivo('PRN', 'Prenotazione');
        insert into PrenotazioneCS (
            CodPrenotazione, CFFruitore, NumTarga, DataIni, DataFin, Stato
        ) VALUES (
            lvCodPrenotazione, pCFFruitore, pNumTarga, pDataIni, pDataFin, 'NUOVA'
        );
    end if;
    --
    return lvCodPrenotazione;
END
//
DELIMITER ;
