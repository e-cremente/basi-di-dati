USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.ChkInsPool;

delimiter //
CREATE DEFINER=root@localhost FUNCTION ChkInsPool(
pNumTarga varchar(12),
pCodTragittoPrg varchar(12),
pCodTragittoTrc varchar(12),
pDataPartenza date,
pOraPartenza time,
pDataArrivo date,
pFlessibilita varchar(8),
pValidità int(11),
pPercentuale decimal(3,0),
pSpesa decimal(9,2),
pPostiDisponibili int(11)
) RETURNS char(12)
--
ChkInsPool:BEGIN
    DECLARE lvCodPool varchar(12) default NULL;
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select CodPool
      into lvCodPool
      from Pool
     where NumTarga = pNumTarga
       and DataPartenza = pDataPartenza
       and OraPartenza = pOraPartenza;
    --
    if lvRecNotFound = 1 then
        set lvCodPool = smartmobility.NewProgressivo('POL', 'Pool');
        insert into Pool (
            CodPool, NumTarga, CodTragittoPrg, CodTragittoTrc, DataPartenza, OraPartenza, DataArrivo, Flessibilita, Validita, Percentuale, Spesa, PostiDisponibili
        ) VALUES (
            lvCodPool, pNumTarga, pCodTragittoPrg, pCodTragittoTrc, pDataPartenza, pOraPartenza, pDataArrivo, pFlessibilita, pValidita, pPercentuale, pSpesa, pPostiDisponibili
        );
    end if;
    --
    return lvCodPool;
END
//
DELIMITER ;
