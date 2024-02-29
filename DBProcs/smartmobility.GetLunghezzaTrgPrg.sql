USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.GetLunghezzaTrgPrg;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE GetLunghezzaTrgPrg(
pCodTragitto varchar(12)
)
--
GetLunghezzaTrgPrg:BEGIN
    declare lvLunghezza decimal(9,3) default NULL;
    --
    select sum(Lunghezza)
      into lvLunghezza
      from TrattaTragittoPrg TTP
           natural join Tratta T 
     where TTP.CodTragitto = pCodTragitto;
    --
    update TragittoProgrammato
       set Lunghezza = lvLunghezza
     where CodTragitto = pCodTragitto;
    --
END
//
DELIMITER ;
