USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.ChkInsRaccordo;

delimiter //
CREATE DEFINER=root@localhost FUNCTION ChkInsRaccordo(
pCodStradaU varchar(12),
pNumCarreggiataU tinyint(4),
pCodPosizioneU varchar(12),
pCodStradaE varchar(12),
pNumCarreggiataE tinyint(4),
pCodPosizioneE varchar(12)
) RETURNS char(16)
--
ChkInsRaccordo:BEGIN
    DECLARE lvCodRaccordo varchar(12);
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select CodRaccordo
      into lvCodRaccordo
      from Raccordo
     where CodStradaU = pCodStradaU
       and CodStradaE = pCodStradaE
       and NumCarreggiataU = pNumCarreggiataU
       and NumCarreggiataE = pNumCarreggiataE
       and CodPosizioneU = pCodPosizioneU
       and CodPosizioneE = pCodPosizioneE;
    --
    if lvRecNotFound = 1 then
		set lvCodRaccordo = smartmobility.NewProgressivo('RAC', 'Raccordo');
        insert into Raccordo (
            CodRaccordo, CodStradaU, NumCarreggiataU, CodPosizioneU, CodStradaE, NumCarreggiataE, CodPosizioneE
        ) VALUES (
            lvCodRaccordo, pCodStradaU, pNumCarreggiataU, pCodPosizioneU, pCodStradaE, pNumCarreggiataE, pCodPosizioneE
        );
    end if;
    --
    return lvCodRaccordo;
END
//
DELIMITER ;
