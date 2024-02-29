USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.UpdInsTrattaTemporizzata;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE UpdInsTrattaTemporizzata(
pCodTratta varchar(12),
pCodFascia varchar(12),
pTempoMedio decimal(13,2)
)
--
UpdInsTrattaTemporizzata:BEGIN
    DECLARE lvPrevTempoMedio decimal(13,2);
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select TempoMedio
      into lvPrevTempoMedio
      from TrattaTemporizzata
    where CodTratta = pCodTratta
       and CodFascia = pCodFascia;
    --
    if lvRecNotFound = 1 then
       insert into TrattaTemporizzata (
            CodTratta, CodFascia, TempoMedio
        ) VALUES (
            pCodTratta, pCodFascia, pTempoMedio
        );
    else
        update TrattaTemporizzata
           set TempoMedio = pTempoMedio
         where CodTratta = pCodTratta
           and CodFascia = pCodFascia;
    end if;
END
//
DELIMITER ;
