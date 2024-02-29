DROP TRIGGER IF EXISTS Svincolo_BEFORE_UPDATE;

DELIMITER $$

CREATE DEFINER = CURRENT_USER TRIGGER `smartmobility`.`Svincolo_BEFORE_UPDATE` BEFORE UPDATE ON `Svincolo` FOR EACH ROW
BEGIN

    DECLARE lvClassTec varchar(3);
    
    -- Ricavo il codice di classificazione tecnica della strada
    select CodClassTec
      into lvClassTec
      from Strada
     where CodStrada = NEW.CodStrada; 
    
    -- Eseguo i controlli
    if lvClassTec = 'SUR' then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Uno svincolo non può trovarsi in una strada urbana';
    end if;
    
    if lvClassTec = 'SXS' then
        if not exists(
            select *
              from Carreggiata
             where NumCorsie > NumSensiMarcia
               and NumCarreggiata = NEW.NumCarreggiata
            ) then
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Uno svincolo non può trovarsi in una strada extraurbana secondaria con meno di 2 corsie per almeno un senso di marcia';
        end if;
    end if;

END
$$
DELIMITER ;
