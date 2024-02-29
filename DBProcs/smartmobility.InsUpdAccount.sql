USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.InsUpdAccount;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE InsUpdAccount(
pCodFiscale varchar(16),
pUsername varchar(32),
pPassword varchar(16),
pDomandaDiRiserva varchar(128),
pRisposta varchar(128)
)
--
InsUpdAccount:BEGIN
    DECLARE DUPLICATED_KEY CONDITION FOR 1602;
    DECLARE lvDuplicatedKey int default 0;
    DECLARE CONTINUE HANDLER FOR DUPLICATED_KEY set lvDuplicatedKey = 1;
    --
    insert into Account (
        CodFiscale, Username, Password, DomandaDiRiserva, Risposta
    ) VALUES (
        pCodFiscale, pUsername, pPassword, pDomandaDiRiserva, pRisposta
    );
    --
    if lvDuplicatedKey = 1 then
        update Account
           set Username = pUsername,
               Password = pPassword,
               DomandaDiRiserva = pDomandaDiRiserva,
               Risposta = pRisposta
         where CodFiscale = pCodFiscale;
    end if;
END
//
DELIMITER ;
