USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.ChkInsSharing;

delimiter //
CREATE DEFINER=root@localhost FUNCTION ChkInsSharing(
pNumTarga varchar(12),
pCodTragittoPrg varchar(12),
pDataPartenza date,
pOraPartenza time
) RETURNS char(12)
--
ChkInsSharing:BEGIN
    DECLARE lvCodSharing varchar(12) default NULL;
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select CodSharing
      into lvCodSharing
      from Sharing
     where NumTarga = pNumTarga
       and DataPartenza = pDataPartenza
       and OraPartenza = pOraPartenza;
    --
    if lvRecNotFound = 1 then
        set lvCodSharing = smartmobility.NewProgressivo('SRG', 'Sharing');
        insert into Sharing (
            CodSharing, NumTarga, CodTragittoPrg, DataPartenza, OraPartenza
        ) VALUES (
            lvCodSharing, pNumTarga, pCodTragittoPrg, pDataPartenza, pOraPartenza
        );
    end if;
    --
    return lvCodSharing;
END
//
DELIMITER ;
