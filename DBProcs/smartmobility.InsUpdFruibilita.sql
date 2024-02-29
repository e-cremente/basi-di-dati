USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.InsUpdFruibilita;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE InsUpdFruibilita(
pNumTarga varchar(8),
pProgrFascia int,
pTipoFruibilita varchar(3), -- PER=Periodica; FAS=Fascia
pNomeGiorno varchar(3), -- LUN, MAR, ..., DOM (Valido se TipoFruibilita = PER)
pGiornoIni date,
pGiornoFin date,
pOraIni time,
pOraFin time
)
--
InsUpdFruibilita:BEGIN
    DECLARE DUPLICATED_KEY CONDITION FOR 1062;
    DECLARE lvDuplicatedKey int default 0;
    DECLARE CONTINUE HANDLER FOR DUPLICATED_KEY set lvDuplicatedKey = 1;
    --
    insert into Fruibilita (
        NumTarga, ProgrFascia, TipoFruibilita, NomeGiorno,
        GiornoIni, GiornoFin, OraIni, OraFin
    ) VALUES (
        pNumTarga, pProgrFascia, pTipoFruibilita, pNomeGiorno,
        pGiornoIni, pGiornoFin, pOraIni, pOraFin
    );
    --
    if lvDuplicatedKey = 1 then
        update Fruibilita
           set TipoFruibilita = pTipoFruibilita,
               NomeGiorno = pNomeGiorno,
               GiornoIni = pGiornoIni,
               GiornoFin = pGiornoFin,
               OraIni = pOraIni,
               OraFin = pOraFin
         where NumTarga = pNumTarga
           and ProgrFascia = pProgrFascia;
    end if;
END
//
DELIMITER ;

