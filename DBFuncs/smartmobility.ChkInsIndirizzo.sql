USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.ChkInsIndirizzo;

delimiter //
CREATE DEFINER=root@localhost FUNCTION ChkInsIndirizzo(
pCodStrada varchar(32),
pCivico varchar(32),
pEsponente varchar(32)
) RETURNS char(12)
--
ChkInsIndirizzo:BEGIN
    DECLARE lvCodIndirizzo varchar(12) default NULL;
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select CodIndirizzo
      into lvCodIndirizzo
      from Indirizzo
     where CodStrada = pCodStrada
       and coalesce(Civico,'#') = coalesce(pCivico, '#')
       and coalesce(Esponente,'#') = coalesce(pEsponente, '#');
    --
    if lvRecNotFound = 1 then
        set lvCodIndirizzo = smartmobility.NewProgressivo('IND', 'Indirizzo');
        insert into Indirizzo (
            CodIndirizzo, CodStrada, Civico, Esponente
        ) VALUES (
            lvCodIndirizzo, pCodStrada, pCivico, pEsponente
        );
    end if;
    --
    return lvCodIndirizzo;
END
//
DELIMITER ;
