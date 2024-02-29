USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.IsAutovetturaCSFruibile;

delimiter //
CREATE DEFINER=root@localhost FUNCTION IsAutovetturaCSFruibile(
pNumTarga varchar(8),
pGiorno   date
) RETURNS char(1)
    COMMENT 'Restituisce S o N a seconda che l''autovettura (Car Sharing) individuata da pNumTarga sia fruibile o meno nel giorno pGiorno'
IsAutovetturaCSFruibile:BEGIN
    DECLARE lvRes char(1) default 'N';
    select 'S'
      into lvRes
      from Fruibilita
     where NumTarga = pNumTarga
       and (
            (TipoFruibilita = 'FAS' and pGiorno between GiornoIni and GiornoFin)
            or
            (TipoFruibilita = 'PER' and GiornoSettimana(NomeGiorno) = dayofweek(pGiorno))
           )
    ;
    return lvRes;
END
//
DELIMITER ;
