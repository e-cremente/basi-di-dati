USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.GetCodStrada;

delimiter //
/**********************************************************************
** FUNCTION GetCodStrada
** La procedura prende in input una strada (fornita nel record di
** di tracciamento da una vettura durante il suo tragitto) e ne
** restituisce il suo codice. Il buon funzionamento della procedura
** si basa sull'ipotesi che il formato della strada sia prestabilito
** ed in particolare:
** Frmt STRADA URBANA     : DUG NomeStd, Comune (Prov) [Nazione]
** Frmt STRADA EXTRAURBANA: TipoStrada[ ]Numero[/Altronumero][ ][Categoria] [Nome]
**********************************************************************/
CREATE DEFINER=root@localhost FUNCTION GetCodStrada(
pStrada varchar(256)
) RETURNS varchar(256)
    COMMENT 'Restituisce (o ne crea uno nuovo e poi lo restituisce) il codice della strada corrispondente a pStrada'
GetCodStrada:BEGIN
    DECLARE lvCodStrada varchar(12) default 'TOBEFOUND';
    DECLARE lvLen int;
    DECLARE lvIdx int;
    DECLARE lvChr varchar(1);
    DECLARE lvTok varchar(64) default '';
    DECLARE lvNextProgr int;
    DECLARE lvStato varchar(32) default 'START';
    DECLARE lvDUG varchar(32) default '';
    DECLARE lvNomeStd varchar(64) default '';
    DECLARE lvComune varchar(64) default '';
    DECLARE lvProvincia varchar(4) default '';
    DECLARE lvNazione varchar(2) default '';
    DECLARE lvTipoStrada varchar(32) default '';
    DECLARE lvNumero varchar(32) default '';
    DECLARE lvAltroNumero varchar(32) default '';
    DECLARE lvCategoria varchar(8) default '';
    DECLARE lvNome varchar(64) default '';
   -- DECLARE lvRecNotFound int default 0;
    -- DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    set pStrada = upper(pStrada);
    set lvLen = length(pStrada);
    set lvIdx = 1;
    while lvIdx <= lvLen do
        set lvChr = substr(pStrada, lvIdx, 1);
        case lvstato
            when 'START' then
                if IsNumeric(lvChr) = 'S' then
                    if isTipoStrada(lvTok) = 'S' then
                        set lvTipoStrada = lvTok;
                        set lvTok = '';
                        set lvStato = 'TIPO_STRADA';
                        set lvNumero = lvChr;
                    else
                        return concat('ERR at ', lvIdx, ' <', lvTipoStrada, '>'); 
                    end if;
                elseif lvChr = ' ' then
                    if isTipoStrada(lvTok) = 'S' then
                        set lvTipoStrada = lvTok;
                        set lvTok = '';
                        set lvStato = 'TIPO_STRADA';
                    else
                        set lvDUG = lvTok;
                        set lvTok = '';
                        set lvStato = 'DUG';
                    end if;
                else
                    set lvTok = concat(lvTok, lvChr);
                end if;
            when 'DUG' then
                if lvChr = ',' then
                    set lvStato = 'NOME_STD';
                else
                    set lvNomeStd = concat(lvNomeStd, lvChr);
                end if;
            when 'NOME_STD' then
                if lvChr = '(' then
                    set lvStato = 'COMUNE';
                else
                    set lvComune = concat(lvComune, lvChr);
                end if;
            when 'COMUNE' then
                if lvChr = ')' then
                    set lvStato = 'PROVINCIA';
                else
                    set lvProvincia = concat(lvProvincia, lvChr);
                end if;
            when 'PROVINCIA' then
                if lvIdx = lvLen then
                    set lvStato = 'NAZIONE';
                else
                    set lvNazione = concat(lvNazione, lvChr);
                end if;
           -- RICONOSCIMENTO di una strada extraurbana
            when 'TIPO_STRADA' then
                if isNumeric(lvChr) = 'N' then
                    if lvChr != ' ' and lvChr != '/' then
                        set lvTok = lvChr;
                    end if;
                    set lvStato = 'NUMERO';
                else
                    set lvNumero = concat(lvNumero, lvChr);
                end if;
            when 'NUMERO' then
                if lvChr = ' ' or lvIdx = lvLen  then
                    if lvIdx = lvLen then set lvTok = concat(lvTok, lvChr); end if;
                    -- dopo NUMERO, nella variabile lvTok potrebbe esserci: un altro numero, oppure una categoria oppure il nome
                    if isNumeric(lvTok) = 'S' then
                        set lvAltroNumero = lvTok;
                        set lvTok = '';
                        set lvStato = 'ALTRO_NUMERO';
                    elseif isCategoria(lvTok) = 'S' then
                        set lvCategoria = lvTok;
                        set lvTok = '';
                        set lvStato = 'CATEGORIA';
                    else
                        set lvNome = lvTok;
                        set lvTok = '';
                        set lvStato = 'NOME';
                    end if;
                else
                    set lvTok = concat(lvTok, lvChr);
                end if;
                --
            when 'ALTRO_NUMERO' then
                if lvChr = ' ' or lvIdx = lvLen then
                    if lvIdx = lvLen then set lvTok = concat(lvTok, lvChr); end if;
                    -- dopo ALTRO_NUMERO, nella variabile lvTok potrebbe esserci: una categoria oppure il nome
                    if isCategoria(lvTok) = 'S' then
                        set lvCategoria = lvTok;
                        set lvTok = '';
                        set lvStato = 'CATEGORIA';
                    else
                        set lvNome = lvTok;
                        set lvTok = '';
                        set lvStato = 'NOME';
                    end if;
                else
                    set lvTok = concat(lvTok, lvChr);
                end if;
            when 'CATEGORIA' then
                if lvChr = ' ' or lvIdx = lvLen then
                    if lvIdx = lvLen then set lvTok = concat(lvTok, lvChr); end if;
                    -- dopo CATEGORIA, nella variabile lvTok potrebbe esserci solo il nome
                    set lvNome = lvTok;
                    set lvTok = '';
                    set lvStato = 'NOME';
                else
                   set lvTok = concat(lvTok, lvChr);
                end  if;
            when 'NOME' then
                return concat('ERR at ', lvIdx, ' <', lvChr, '>');
            else
                return concat(lvStato, ' non gestito.');
        end case;
        --
        set lvIdx = lvIdx + 1;
    end while;
-- STRADA URBANA
 return concat(pStrada, '-', lvidx, '/', lvLen, ' (', lvChr, '): ', coalesce(nullif(lvDUG,''),'-'), ', ', coalesce(nullif(lvNomeStd,''),'-'), ', ', coalesce(nullif(lvComune,''),'-'), ', ', coalesce(nullif(lvProvincia,''),'-'), ', ', coalesce(nullif(lvNazione,''),'-'));
-- STRADA EXTRAURBANA
-- return concat(pStrada, '-', lvidx, '/', lvLen, ' (', lvChr, '): ', coalesce(nullif(lvTipoStrada,''),'-'), ', ', coalesce(nullif(lvNumero,''),'-'), ', ', coalesce(nullif(lvAltroNumero,''),'-'), ', ', coalesce(nullif(lvCategoria,''),'-'), ', ', coalesce(nullif(lvNome,''),'-'));
    if lvDug != '' then
        set lvCodStrada = ChkInsStradaUR(lvDUG, lvNomeStd, lvComune, lvProvincia, nullif(lvNazione,''));
    else
        set lvCodStrada = ChkInsStradaXU(lvTipoStrada, lvNNumero, lvAltroNumero, lvNome);
    end if;
    return lvCodStrada;
END
//
DELIMITER ;
