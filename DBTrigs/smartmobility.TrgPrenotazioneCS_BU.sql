DROP TRIGGER IF EXISTS PrenotazioneCS_BU;

DELIMITER $$

CREATE DEFINER=`root`@`localhost` TRIGGER `smartmobility`.`PrenotazioneCS_BU`
BEFORE UPDATE ON `smartmobility`.`prenotazionecs`
FOR EACH ROW
BEGIN

   DECLARE lvTipoFruibilita varchar(3);
   DECLARE lvGiornoIni date;
   DECLARE lvGiornoFin date;
   DECLARE lvIteratore date default NEW.DataIni - interval 1 day;
   
   select TipoFruibilita, GiornoIni, GiornoFin
     into lvTipoFruibilita, lvGiornoIni, lvGiornoFin
     from Fruibilita
    where NumTarga = NEW.NumTarga;
     
    if lvTipoFruibilita = 'FAS' then
        if lvGiornoIni > NEW.DataIni
        or lvGiornoFin < NEW.DataFin then
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Il periodo inserito non corrisponde con il periodo in cui la vettura può essere noleggiata';
        elseif exists(
            select *
              from PrenotazioneCS
             where NumTarga = NEW.NumTarga
               and NEW.DataIni < DataFin
               and NEW.DataFin > DataIni
               and Stato = 'ACCETTATA'
            ) then
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Il periodo inserito non è valido poiché è stata già accettata un altra prenotazione negli stessi giorni';
        end if;
    elseif lvTipoFruibilita = 'PER' then
        if datediff(NEW.DataFin, NEW.DataIni) > 7 
       and (select count(*)
              from Fruibilita
             where NumTarga = NEW.NumTarga
               and ((OraIni = '00:00:00' and OraFin = '24:00:00')
                or (OraIni is null and OraFin is null))) < 7 then
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La vettura non può essere prenotata per un periodo di tempo così esteso';
        end if;
        elseif datediff(NEW.DataFin, NEW.DataIni) <= 7 then
            verifica: LOOP
                SET lvIteratore = lvIteratore + interval 1 day;
                 if lvIteratore = NEW.DataIni then
                     if not exists(
                            select *
                              from Fruibilita
                             where NumTarga = NEW.NumTarga
                               and dayofweek(lvIteratore) = GiornoSettimana(NomeGiorno)
                            )   
                     or exists(
                        select *
                          from Fruibilita
                         where NumTarga = NEW.NumTarga
                           and dayofweek(lvIteratore) = GiornoSettimana(NomeGiorno)
                           and OraFin <> '24:00:00'
                        ) then
                            SIGNAL SQLSTATE '45000'
                            SET MESSAGE_TEXT = 'La vettura non può essere prenotata per un periodo di tempo così esteso, o non è disponibile per gli orari selezionati';
                     else ITERATE verifica;
                     end if;
             elseif lvIteratore > NEW.DataIni and lvIteratore < NEW.DataFin then
                     if not exists(
                            select *
                              from Fruibilita
                             where NumTarga = NEW.NumTarga
                               and dayofweek(lvIteratore) = GiornoSettimana(NomeGiorno)
                            )  
                     or exists(
                        select *
                          from Fruibilita
                         where NumTarga = NEW.NumTarga
                           and dayofweek(lvIteratore) = GiornoSettimana(NomeGiorno)
                           and (OraIni <> '00:00:00' or OraFin <> '24:00:00')
                        ) then
                            SIGNAL SQLSTATE '45000'
                            SET MESSAGE_TEXT = 'La vettura non può essere prenotata per un periodo di tempo così esteso, o non è disponibile per gli orari selezionati';
                     else ITERATE verifica;       
                     end if; 
             elseif lvIteratore = NEW.DataFin then
                     if not exists(
                            select *
                              from Fruibilita
                             where NumTarga = NEW.NumTarga
                               and dayofweek(lvIteratore) = GiornoSettimana(NomeGiorno)
                            )  
                     or exists(
                        select *
                          from Fruibilita
                         where NumTarga = NEW.NumTarga
                           and dayofweek(lvIteratore) = GiornoSettimana(NomeGiorno)
                           and (OraIni <> '00:00:00')
                        ) then
                            SIGNAL SQLSTATE '45000'
                            SET MESSAGE_TEXT = 'La vettura non può essere prenotata per un periodo di tempo così esteso, o non è disponibile per gli orari selezionati';
                     else LEAVE verifica;
                     end if;
                 end if;
            END LOOP verifica;
    end if;    
END
$$
DELIMITER ;
