USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.ChkInsProponente;

delimiter //
CREATE DEFINER=root@localhost FUNCTION ChkInsProponente(
pCFProponente varchar(16)
) RETURNS char(16)
--
ChkInsProponente:BEGIN
    DECLARE lvCodFiscale varchar(16);
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select CodFiscale
      into lvCodFIscale
      from Proponente
     where CodFiscale = pCFProponente;
    --
    if lvRecNotFound = 1 then
        insert into Proponente (
            CodFiscale
        ) VALUES (
            pCFProponente
        );
    end if;
    --
    return pCFProponente;
END
//
DELIMITER ;
