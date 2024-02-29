USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.ConsegnaNoleggio;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE ConsegnaNoleggio(
pCodPrenotazione varchar(12),
pQtaCarburanteFin decimal(7,0),
pKmPercorsiFin decimal(7,0)
) 
--
ConsegnaNoleggio:BEGIN
    DECLARE lvCodNoleggio varchar(12) default NULL;
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select CodNoleggio
      into lvCodNoleggio
      from Noleggio
     where CodPrenotazione = pCodPrenotazione;
    --
    if lvRecNotFound = 1 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il noleggio non esiste';
    end if;
    --
    update Noleggio
       set QtaCarburanteFin = pQtaCarburanteFin,
           KmPercorsiFin = pKmPercorsiFin
	 where CodNoleggio = lvCodNoleggio;
	--
END
//
DELIMITER ;
