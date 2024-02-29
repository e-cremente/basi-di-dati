USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.ChkInsNoleggio;

delimiter //
CREATE DEFINER=root@localhost FUNCTION ChkInsNoleggio(
pCodPrenotazione varchar(12),
pQtaCarburanteIni decimal(7,0),
pKmPercorsiIni decimal(7,0)
) RETURNS char(12)
--
ChkInsNoleggio:BEGIN
    DECLARE lvCodNoleggio varchar(12) default NULL;
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select CodNoleggio
      into lvCodNoleggio
      from Noleggio
     where CodPrenotazione = pCodPrenotazione;
    --
    if lvRecNotFound = 1 then
        set lvCodNoleggio = smartmobility.NewProgressivo('NOL', 'Noleggio');
        insert into Noleggio (
            CodNoleggio, CodPrenotazione, QtaCarburanteIni, KmPercorsiIni
        ) VALUES (
            lvCodNoleggio, pCodPrenotazione, pQtaCarburanteIni, pKmPercorsiIni
        );
    end if;
    --
    return lvCodNoleggio;
END
//
DELIMITER ;
