USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.InsTrattaTragittoTrc;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE InsTrattaTragittoTrc(
pCodTragitto  varchar(12),
pCodTratta varchar(12),
pDataOraEntrata datetime
)
--
InsTrattaTragittoTrc:BEGIN
    insert into smartmobility.TrattaTragittoTrc (
        CodTragitto, CodTratta, DataOraEntrata
    ) VALUES (
        pCodTragitto, pCodTratta, pDataOraEntrata
    );
    --
END
//
DELIMITER ;
