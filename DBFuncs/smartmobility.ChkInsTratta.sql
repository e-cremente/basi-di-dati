USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.ChkInsTratta;

delimiter //
CREATE DEFINER=`root`@`localhost` FUNCTION `ChkInsTratta`(
pCodStrada varchar(32),
pNumCarreggiata tinyint,
pLunghezza decimal (9,3),
pLatitudineIni decimal(10,7),
pLongitudineIni decimal(10,7),
pLatitudineFin decimal(10,7),
pLongitudineFin decimal(10,7)
) RETURNS varchar(12)
--
ChkInsTratta:BEGIN
    DECLARE lvCodTratta varchar(12);
    DECLARE lvCodPosizioneIni varchar(12);
    DECLARE lvCodPosizioneFIn varchar(12);
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select T.CodTratta
      into lvCodTratta
      from Tratta T
           inner join Posizione PI on (PI.CodPosizione = T.CodPosizioneIni)
           inner join Posizione PF on (PF.CodPosizione = T.CodPosizioneFin)
     where T.CodStrada = pCodStrada
       and T.NumCarreggiata = pNumCarreggiata
       and PI.Latitudine = MyRound(pLatitudineIni, 0.00005)
       and PI.Longitudine = MyRound(pLongitudineIni, 0.00005)
       and PF.Latitudine = MyRound(pLatitudineFin, 0.00005)
       and PF.Longitudine = MyRound(pLongitudineFin, 0.00005);
    --
    if lvRecNotFound = 1 then
        set lvCodTratta = smartmobility.NewProgressivo('TRT', 'Tratta');
        set lvCodPosizioneIni = ChkInsPosizione(pLatitudineIni, pLongitudineIni, pCodStrada, NULL, NULL);
        set lvCodPosizioneFIn = ChkInsPosizione(pLatitudineFin, pLongitudineFin, pCodStrada, NULL, NULL);
        insert into Tratta(
            CodTratta, CodStrada, NumCarreggiata, Lunghezza, CodPosizioneIni, CodPosizioneFin
        ) VALUES (
            lvCodTratta, pCodStrada, pNumCarreggiata, pLunghezza, lvCodPosizioneIni, lvCodPosizioneFin
        );
        --
    end if;
    --
    return lvCodTratta;
END
//
DELIMITER ;
