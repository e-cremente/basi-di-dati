DROP TRIGGER IF EXISTS Incrocio_BEFORE_UPDATE;

DELIMITER $$

CREATE DEFINER = CURRENT_USER TRIGGER `smartmobility`.`Incrocio_BEFORE_UPDATE` BEFORE UPDATE ON `Incrocio` FOR EACH ROW
BEGIN

    DECLARE ClassStrada1 VARCHAR(3) DEFAULT '';
    DECLARE ClassStrada2 VARCHAR(3) DEFAULT '';
    DECLARE lvCarreggiata1 TINYINT DEFAULT 0;
    DECLARE lvCarreggiata2 TINYINT DEFAULT 0;
    
    select CodClassTec into ClassStrada1
      from Strada
	 where CodStrada = NEW.CodStrada;
	
	select CodClassTec into ClassStrada2
      from Strada
	 where CodStrada = NEW.CodStradaX;
	
	select if(Numcorsie > NumSensiMarcia, 1, 0) into lvCarreggiata1
      from Carreggiata
	 where NumCarreggiata = NEW.NumCarreggiata
		   AND CodStrada = NEW.CodStrada;
	
	select if(Numcorsie > NumSensiMarcia, 1, 0) into lvCarreggiata2
      from Carreggiata
	 where CodStrada = NEW.CodStradaX
		   AND NumCarreggiata = NEW.NumCarreggiata;
    
	-- caso in cui hanno più di una corsia per senso di marcia
	if ClassStrada1 = 'SXP' OR ClassStrada2 = 'SXP'
           OR ClassStrada1 = 'AUT' OR ClassStrada2 = 'AUT' then
           SIGNAL SQLSTATE '45000'
		   SET MESSAGE_TEXT = 'Le strade non possono avere un incrocio';
    elseif (ClassStrada1 = 'SXS' AND lvCarreggiata1) OR (ClassStrada2 = 'SXS' AND lvCarreggiata2) then
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Le strade non possono avere un incrocio';
    end if;

END $$

DELIMITER ;
