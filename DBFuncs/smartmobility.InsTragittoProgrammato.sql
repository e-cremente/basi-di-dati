USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.InsTragittoProgrammato;

delimiter //
CREATE DEFINER=root@localhost FUNCTION InsTragittoProgrammato(
pCodPosizioneP varchar(12),
pCodPosizioneA varchar(12),
pLunghezza decimal(9,3),
pTipoPercorso char(1)
) returns varchar(12)
--
InsTragittoProgrammato:BEGIN
    DECLARE lvCodTragitto varchar(12);
    --
    set lvCodTragitto = smartmobility.NewProgressivo('TGT', 'Tragitto');
    --
    insert into smartmobility.tragitto (
        CodTragitto, CodPosizioneP, CodPosizioneA
    ) VALUES (
        lvCodTragitto, pCodPosizioneP, pCodPosizioneA
    );
    --
    insert into smartmobility.tragittoprogrammato (
        CodTragitto, Lunghezza, TipoPercorso
    ) VALUES (
        lvCodTragitto, pLunghezza, pTipoPercorso
    );
    --
    return lvCodTragitto;
END
//
DELIMITER ;
