USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.RegistraAutovetturaRSoD;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE RegistraAutovetturaRSoD(
pNumTarga varchar(8)
)
--
RegistraAutovetturaRSoD:BEGIN
    DECLARE AUTOVETTURA_INESISTENTE CONDITION FOR SQLSTATE '45000';
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    if EsisteAutovettura(pNumTarga) = 'N' then
        SIGNAL AUTOVETTURA_INESISTENTE SET MESSAGE_TEXT = 'Autovettura inesistente nell''anagrafica delle autovetture';
    end if;
    --
    call InsAutoRideSharingOnDemand(pNumTarga);
END
//
DELIMITER ;
