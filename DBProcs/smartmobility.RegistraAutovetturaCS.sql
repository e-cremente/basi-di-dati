USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.RegistraAutovetturaCS;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE RegistraAutovetturaCS(
pNumTarga varchar(8),
pDisponibilita varchar(16)
)
--
RegistraAutovetturaCS:BEGIN
    DECLARE AUTOVETTURA_INESISTENTE CONDITION FOR SQLSTATE '45000';
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    if EsisteAutovettura(pNumTarga) = 'N' then
        SIGNAL AUTOVETTURA_INESISTENTE SET MESSAGE_TEXT = 'Autovettura inesistente nell''anagrafica delle autovetture';
    end if;
    --
    call InsUpdAutoCarSharing(pNumTarga, pDisponibilita);
 END
//
DELIMITER ;
