DROP TRIGGER IF EXISTS Pedaggio_BEFORE_UPDATE;

DELIMITER $$

CREATE DEFINER = CURRENT_USER TRIGGER `smartmobility`.`Pedaggio_BEFORE_UPDATE` BEFORE UPDATE ON `Pedaggio` FOR EACH ROW
BEGIN

     DECLARE ClassStrada1 VARCHAR(3) DEFAULT '';
    DECLARE ClassStrada2 VARCHAR(3) DEFAULT '';
     
    select CodClassTec into ClassStrada1
      from Svincolo
		   natural join Strada
	 where CodSvincolo = NEW.CodSvincoloE;
	
	select CodClassTec into ClassStrada2
      from Svincolo
		   natural join Strada
	 where CodSvincolo = NEW.CodSvincoloU;
	
	if ClassStrada1 <> 'AUT' 
    or ClassStrada2 <> 'AUT' then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Le strade non sono autostrade';
    end if;

END
$$
DELIMITER ;
