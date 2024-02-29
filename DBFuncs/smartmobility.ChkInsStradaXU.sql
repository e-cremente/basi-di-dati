USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.ChkInsStradaXU;

delimiter //
CREATE DEFINER=`root`@`localhost` FUNCTION `ChkInsStradaXU`(
pCodTipoStrada varchar(2),
pCodCategStrada varchar(8),
pNumero integer,
pAltroNumero integer,
pNome varchar(64),
pLunghezza decimal (9,3),
pNumCarreggiate decimal(2),
pCodClassTec varchar(3)
) RETURNS varchar(12)
--
ChkInsStradaXU:BEGIN
    DECLARE lvCodStrada varchar(12);
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select S.CodStrada
      into lvCodStrada
      from StradaExtraurbana SX
           inner join Strada S on (S.CodStrada = SX.CodStrada)
     where SX.CodTipoStrada = pCodTipoStrada
       and coalesce(SX.CodCategStrada, '#') = coalesce(pCodCategStrada, '#')
       and SX.Numero = pNumero
       and coalesce(S.Nome, '#') = coalesce(pNome, '#');
    --
    if lvRecNotFound = 1 then
        set lvCodStrada = smartmobility.NewProgressivo('STR', 'Strada');
        insert into Strada(
            CodStrada, Lunghezza, NumCarreggiate, CodClassTec, Nome
        ) VALUES (
            lvCodStrada, coalesce(pLunghezza, 0), coalesce(pNumCarreggiate, 1), pCodClassTec, pNome
        );
        --
        insert into StradaExtraurbana(
            CodStrada, CodTipoStrada, CodCategStrada, Numero, AltroNumero
        ) VALUES (
            lvCodStrada, pCodTipoStrada, pCodCategStrada, pNumero, pAltroNumero
        );
    end if;
    --
    return lvCodStrada;
END
//
DELIMITER ;
