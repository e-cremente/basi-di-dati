USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.MostraDisponibilitaAutoCS;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE MostraDisponibilitaAutoCS(
pNumTarga varchar(12),
pDataIni date,
pDataFin date
)
--
MostraDisponibilitaAutoCS:BEGIN
    DECLARE lvGG date;
    DECLARE lvWD int;
    DECLARE lvFlgPrimaRiga bool default true;
    DECLARE lvSep char(1) default ',';
    DECLARE lvFru char(1) default 'N';
    DECLARE lvPrn char(1) default '';
    set lvGG = pDataIni;
    set @lvSQL = 'select ''DOM'', ''LUN'', ''MAR'', ''MER'', ''GIO'', ''VEN'', ''SAB'' ';
    while lvGG <= pDataFin do
        set lvWD = dayofweek(lvGG);
        if isAutovetturaCSFruibile(pNumTarga, lvGG) = 'S' then
            set lvPrn = case isAutovetturaCSPrenotata(pNumTarga, lvGG) when 'S' then '*' else '' end;
            if lvWD = 1 or lvFlgPrimaRiga then set @lvSQL = concat(@lvSQL, ' union select '); end if;
            if lvFlgPrimaRiga then 
                begin
                    DECLARE lvIdx int default 1;
                    while lvIdx < lvWD do
                        set @lvSQL = concat(@lvSQL, '''-''', lvSep);
                        set lvIdx = lvIdx + 1;
                    end while;
                    set lvFlgPrimaRIga = false;
                end;
            end if;
            set lvSep = case lvWD when 7 then '' else ',' end;
            set @lvSQL = concat(@lvSQL, '''', day(lvGG), lvPrn, '''', lvSep);
        end if;
        set lvGG = date_add(lvGG, interval 1 day);
    end while;
    while lvWD <= 6 do
        set lvSep = case lvWD when 6 then '' else ',' end;
        set @lvSQL = concat(@lvSQL, '''-''', lvSep);
        set lvWD = lvWD + 1;
    end while;
    -- select @lvSQL;
    prepare lvStmt from @lvSQL;
    execute lvStmt;
    deallocate prepare lvStmt;
END
//
DELIMITER ;