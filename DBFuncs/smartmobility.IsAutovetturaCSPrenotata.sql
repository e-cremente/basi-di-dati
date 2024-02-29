USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.IsAutovetturaCSPrenotata;

delimiter //
CREATE DEFINER=root@localhost FUNCTION IsAutovetturaCSPrenotata(
pNumTarga varchar(8),
pGiorno   date
) RETURNS char(1)
    COMMENT 'Restituisce S o N a seconda che l''autovettura (Car Sharing) individuata da pNumTarga sia prenotata o meno nel giorno pGiorno'
IsAutovetturaCSPrenotata:BEGIN
    DECLARE lvRes char(1) default 'N';
    select 'S'
      into lvRes
      from PrenotazioneCS
     where NumTarga = pNumTarga
       and pGiorno between DataIni and DataFin
       and Stato = 'ACCETTATA';
    return lvRes;
END
//
DELIMITER ;
