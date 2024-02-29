USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.ChkInsSvincolo;

delimiter //
CREATE DEFINER=root@localhost FUNCTION ChkInsSvincolo(
pCodStrada varchar(12),
pNumCarreggiata tinyint(4),
pCodPosizione varchar(12),
pTipo char(1)
) RETURNS char(12)
--
ChkInsSvincolo:BEGIN
    DECLARE lvCodSvincolo varchar(12);
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select CodSvincolo
      into lvCodSvincolo
      from Svincolo
     where CodStrada = pCodStrada
       and NumCarreggiata = pNumCarreggiata
       and Tipo = pTipo
       and CodPosizione = pCodPosizione;
    --
    if lvRecNotFound = 1 then
		set lvCodSvincolo = smartmobility.NewProgressivo('SVI', 'Svincolo');
        insert into Svincolo (
            CodSvincolo, CodStrada, NumCarreggiata, CodPosizione, Tipo
        ) VALUES (
            lvCodSvincolo, pCodStrada, pNumCarreggiata, pCodPosizione, pTipo
        );
    end if;
    --
    return lvCodSvincolo;
END
//
DELIMITER ;
