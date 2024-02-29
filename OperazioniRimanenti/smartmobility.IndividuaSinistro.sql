USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.IndividuaSinistro;

delimiter //
CREATE DEFINER=root@localhost FUNCTION IndividuaSinistro(
pCodStrada varchar(12),
pChilometro decimal(9,3),
pLatitudine decimal(10,7),
pLongitudine decimal(10,7)
) RETURNS char(12)
--
IndividuaSinistro:BEGIN
    DECLARE lvCodSinistro varchar(12) default NULL;
    --
    if pLatitudine is not null and pLongitudine is not null then
		select CodSinistro
		  into lvCodSinistro
		  from Sinistro
		 where CodPosizione = ChkInsPosizione(pLatitudine, pLongitudine, NULL, NULL, NULL);
	else
		select CodSinistro 
          into lvCodSinistro
          from Sinistro S
               inner join Posizione P on (S.CodPosizione = P.CodPosizione)
		 where P.CodStrada = pCodStrada
           and P.Chilometro = pChilometro;
	end if;
    --
    return lvCodSinistro;
END
//
DELIMITER ;
