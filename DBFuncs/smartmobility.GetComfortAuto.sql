USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.GetComfortAuto;

delimiter //
CREATE DEFINER=root@localhost FUNCTION GetComfortAuto(
pNumTarga varchar(8)
) RETURNS decimal(3,2)
    COMMENT 'Restituisce un valore da 0 a 5 (stelle) che rappresenta il livello di comfort dell\'autovettura'
GetComfortAuto:BEGIN
    DECLARE NO_AUTOVETTURA CONDITION FOR SQLSTATE '45000';
    DECLARE NO_OPTIONAL CONDITION FOR SQLSTATE '45000';
    DECLARE lvRecNotFound int default 0;
    DECLARE lvComfort decimal(3,2);
    DECLARE lvCilindrata decimal(5);
    DECLARE lvNumOptP int;
    DECLARE lvNumOptS int;
    DECLARE lvValOptS int;
    DECLARE lvNumOptPAuto int;
    DECLARE lvNumOptSAuto int;
    DECLARE lvValOptSAuto int;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    -- Recupero la cilindrata dell'autovettura
    set lvRecNotFound = 0;
    select Cilindrata
      into lvCilindrata
      from AutovetturaRegistrata
     where NumTarga = pNumTarga;
    if lvRecNotFound = 1 then
        SIGNAL NO_AUTOVETTURA
            SET MESSAGE_TEXT = 'Vettura inesistente';
    end if;
    -- Recupero il numero di optional primari
    select count(*)
      into lvNumOptP
      from Optional
     where TipoOptional = 'P';
    if lvNumOptP = 0 then
        SIGNAL NO_OPTIONAL
            SET MESSAGE_TEXT = 'Nessun Optional PRIMARIO nell\'anagrafica degli Optional.';
    end if;
    -- Recupero il numero e la somma dei voti degli optional secondari
    select count(*), sum(Voto)
      into lvNumOptS, lvValOptS
      from Optional
     where TipoOptional = 'S';
    if lvNumOptS = 0 then
        SIGNAL NO_OPTIONAL
            SET MESSAGE_TEXT = 'Nessun Optional SECONDARIO nell\'anagrafica degli Optional.';
    end if;
    -- Recupero il numero di optional primari posseduti dall'auto
    select count(*)
      into lvNumOptPAuto
      from OptionalAuto OA
           inner join Optional O on (
               O.CodOptional = OA.CodOptional
           )
     where OA.NumTarga = pNumTarga
       and O.TipoOptional = 'P';
    -- Recupero il numero e la somma dei voti degli optional secondari posseduti dall'auto
    select count(*), sum(O.Voto)
      into lvNumOptSAuto, lvValOptSAuto
      from OptionalAuto OA
           inner join Optional O on (
               O.CodOptional = OA.CodOptional
           )
     where OA.NumTarga = pNumTarga
       and O.TipoOptional = 'S';
    --
    set lvComfort = (
        (lvNumOptPAuto/lvNumOptP) * 3 +  -- Contributo degli optional primari
        (lvValOptSAuto/lvValOptS) * 2 + -- Contributo degli optional secondari
        case
            when lvCilindrata between 0 and 599 then 2
            when lvCilindrata between 600 and 999 then 3
            when lvCilindrata between 1000 and 1199 then 3.5
            when lvCilindrata between 1200 and 1599 then 4
            when lvCilindrata between 1600 and 1999 then 4.5
            when lvCilindrata >= 2000 then 5
        end -- Contributo della cilindrata
        ) / 2;
    return MyRound(lvComfort, 0.5);
END
//
DELIMITER ;
