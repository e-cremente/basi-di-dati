USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.InsUpdValutazioneAspetto;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE InsUpdValutazioneAspetto(
pCodValutazione varchar(32),
pCodAspettoValutabile varchar(12),
pVoto decimal(3,2)
)
--
InsUpdValutazioneAspetto:BEGIN
    DECLARE DUPLICATED_KEY CONDITION FOR 1062;
    DECLARE lvDuplicatedKey int default 0;
    DECLARE CONTINUE HANDLER FOR DUPLICATED_KEY set lvDuplicatedKey = 1;
    --
    insert into ValutazioneAspetti (
        CodValutazione, CodAspettoValutabile, Voto
    ) VALUES (
        pCodValutazione, pCodAspettoValutabile, pVoto
    );
    --
    if lvDuplicatedKey = 1 then
        update ValutazioneAspetti
           set Voto = pVoto
         where CodValutazione = pCodValutazione
           and CodAspettoValutabile = pCodAspettoValutabile;
    end if;
END
//
DELIMITER ;
