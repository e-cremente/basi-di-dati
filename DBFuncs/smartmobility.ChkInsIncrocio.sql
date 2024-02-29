USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.ChkInsIncrocio;

delimiter //
CREATE DEFINER=`root`@`localhost` FUNCTION `ChkInsIncrocio`(
pCodStrada1 varchar(32),
pNumCarreggiata1 tinyint,
pChilometro1 decimal(9,3),
pLatitudine decimal(10,7),
pLongitudine decimal(10,7),
pCodStrada2 varchar(32),
pNumCarreggiata2 tinyint,
pChilometro2 decimal(9,3)
) RETURNS varchar(12)
--
ChkInsIncrocio:BEGIN
    DECLARE lvCodIncrocio varchar(12);
    DECLARE lvCodPosizione1 varchar(12);
    DECLARE lvCodPosizione2 varchar(12);
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select I.CodIncrocio
      into lvCodIncrocio
      from Incrocio I
	 where I.CodStrada = pCodStrada1
	   and I.NumCarreggiata = pNumCarreggiata1
       and I.CodStradaX = pCodStrada2
	   and I.NumCarreggiataX = pNumCarreggiata2
    ;
    if lvRecNotFound = 1 then
		set lvRecNotFound = 0;
		select P.CodPosizione
		  into lvCodPosizione1
		  from Posizione P
		 where P.Latitudine = MyRound(pLatitudine, 0.00005)
		   and P.Longitudine = MyRound(pLongitudine, 0.00005)
		   and P.CodStrada = pCodStrada1;
		--
		if lvRecNotFound = 1 then
			set lvCodPosizione1 = ChkInsPosizione(pLatitudine, pLongitudine, pCodStrada1, pChilometro1, NULL);
		end if;
		--
		set lvRecNotFound = 0; 
		select P.CodPosizione
		  into lvCodPosizione2
		  from Posizione P
		 where P.Latitudine = MyRound(pLatitudine, 0.00005)
		   and P.Longitudine = MyRound(pLongitudine, 0.00005)
		   and P.CodStrada = pCodStrada2;
		--
		if lvRecNotFound = 1 then
			set lvCodPosizione2 = ChkInsPosizione(pLatitudine, pLongitudine, pCodStrada2, pChilometro2, NULL);
		end if;
        --
        set lvCodIncrocio = NewProgressivo('INC', 'Incrocio');
        insert into Incrocio (
			CodIncrocio, CodStrada, NumCarreggiata, CodPosizione, CodStradaX, NumCarreggiataX, CodPosizioneX
        ) VALUES (
			lvCodIncrocio, pCodStrada1, pNumCarreggiata1, lvCodPosizione1, pCodStrada2, pNumCarreggiata2, lvCodPosizione2
        );
	end if;
    --
    return lvCodIncrocio;
END
//
DELIMITER ;

