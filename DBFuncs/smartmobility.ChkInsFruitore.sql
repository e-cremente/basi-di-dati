USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.ChkInsFruitore;

delimiter //
CREATE DEFINER=root@localhost FUNCTION ChkInsFruitore(
pCFFruitore varchar(16)
) RETURNS char(16)
--
ChkInsFruitore:BEGIN
    DECLARE lvCodFiscale varchar(16);
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select CodFiscale
      into lvCodFIscale
      from Fruitore
     where CodFiscale = pCFFruitore;
    --
    if lvRecNotFound = 1 then
        insert into Fruitore (
            CodFiscale
        ) VALUES (
            pCFFruitore
        );
    end if;
    --
    return pCFFruitore;
END
//
DELIMITER ;
