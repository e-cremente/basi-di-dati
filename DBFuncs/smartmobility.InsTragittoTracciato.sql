USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.InsTragittoTracciato;

delimiter //
CREATE DEFINER=root@localhost FUNCTION InsTragittoTracciato(
pCodPosizioneP varchar(12),
pServizio varchar(12),
pCodServizio varchar(12) -- CodNoleggio/Pool/Sharing in base al valore di pServizio
) returns varchar(12)
--
InsTragittoTracciato:BEGIN
    DECLARE lvCodTragitto varchar(12);
    --
    set lvCodTragitto = smartmobility.NewProgressivo('TGT', 'Tragitto');
    --
    insert into smartmobility.tragitto (
        CodTragitto, CodPosizioneP
    ) VALUES (
        lvCodTragitto, pCodPosizioneP
    );
    --
    insert into smartmobility.tragittotracciato (
        CodTragitto
    ) VALUES (
        lvCodTragitto
    );
    --
    if pServizio = 'CarSharing' then
        insert into smartmobility.tragittotracciatocs (
            CodNoleggio, CodTragitto
        ) VALUES (
            pCodServizio, lvCodTragitto
        );
    end if;
    --
    return lvCodTragitto;
END
//
DELIMITER ;
