USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.ChkInsPosizione;

delimiter //
CREATE DEFINER=root@localhost FUNCTION ChkInsPosizione(
pLatitudine decimal(10,7),
pLongitudine decimal(10,7),
pCodStrada varchar(12),
pChilometro decimal(9,3),
pCodIndirizzo varchar(12)
) RETURNS char(12)
--
ChkInsPosizione:BEGIN
    DECLARE lvCodPosizione varchar(12) default NULL;
    DECLARE lvLatitudine decimal(10,7);
    DECLARE lvLongitudine decimal(10,7);
    DECLARE lvCodStrada varchar(12);
    DECLARE lvChilometro decimal(9,3);
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    set lvLatitudine = MyRound(pLatitudine, 0.00005);
    set lvLongitudine = MyRound(pLongitudine, 0.00005);
    set lvCodStrada = case when pCodStrada is null or pChilometro is null then null else pCodStrada end;
    set lvChilometro = case when pCodStrada is null or pChilometro is null then null else pChilometro end;
    select CodPosizione
      into lvCodPosizione
      from Posizione
     where Latitudine = lvLatitudine
       and Longitudine = lvLongitudine
       and coalesce(CodStrada,'#') = coalesce(lvCodStrada, '#')
       and coalesce(Chilometro, -1) = coalesce(lvChilometro, -1)
       and coalesce(CodIndirizzo,'#') = coalesce(pCodIndirizzo, '#');
    --
    if lvRecNotFound = 1 then
        set lvCodPosizione = smartmobility.NewProgressivo('POS', 'Posizione');
        insert into Posizione (
            CodPosizione, Latitudine, Longitudine, CodStrada, Chilometro, CodIndirizzo
        ) VALUES (
            lvCodPosizione, lvLatitudine, lvLongitudine, lvCodStrada, lvChilometro, pCodIndirizzo
        );
    end if;
    --
    return lvCodPosizione;
END
//
DELIMITER ;
