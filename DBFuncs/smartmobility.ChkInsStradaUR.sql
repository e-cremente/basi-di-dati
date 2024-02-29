USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.ChkInsStradaUR;

delimiter //
CREATE DEFINER=`root`@`localhost` FUNCTION `ChkInsStradaUR`(
pDUG varchar(32),
pNome varchar(64),
pComune varchar(64),
pProvincia varchar(4),
pRegione varchar(3),
pNazione varchar(2),
pCAP varchar(5),
pLunghezza decimal (9,3),
pNumCarreggiate decimal(2),
pCodClassTec varchar(3)
) RETURNS varchar(12)
--
ChkInsStradaUR:BEGIN
    DECLARE lvCodStrada varchar(12);
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select S.CodStrada
      into lvCodStrada
      from StradaUrbana SU
           inner join Strada S on (S.CodStrada = SU.CodStrada)
     where SU.Nazione = coalesce(pNazione, 'IT')
       and SU.Provincia = pProvincia
       and SU.Comune = pComune
       and SU.DUG = pDUG
       and S.Nome = pNome;
    --
    if lvRecNotFound = 1 then
        set lvCodStrada = smartmobility.NewProgressivo('STR', 'Strada');
        insert into Strada(
            CodStrada, Lunghezza, NumCarreggiate, CodClassTec, Nome
        ) VALUES (
            lvCodStrada, coalesce(pLunghezza, 0), coalesce(pNumCarreggiate, 1), pCodClassTec, pNome
        );
        --
        insert into StradaUrbana(
            CodStrada, DUG, CAP, Nazione, Regione, Provincia, Comune
        ) VALUES (
            lvCodStrada, pDUG, pCAP, coalesce(pNazione, 'IT'), pRegione, pProvincia, pComune
        );
    end if;
    --
    return lvCodStrada;
END
//
DELIMITER ;
