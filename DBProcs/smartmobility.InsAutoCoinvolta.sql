USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.InsAutoCoinvolta;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE InsAutoCoinvolta(
pCodSinistro varchar(12), 
pNumTarga varchar(8), 
pCasaProduttrice varchar(32),
pModello varchar(16)
)
--
InsAutoCoinvolta:BEGIN
    DECLARE DUPLICATED_KEY CONDITION FOR 1062;
    DECLARE lvDuplicatedKey int default 0;
    DECLARE CONTINUE HANDLER FOR DUPLICATED_KEY set lvDuplicatedKey = 1;
    --
    insert into Autovettura (
        NumTarga, CasaProdruttrice, Modello
    ) VALUES (
        pNumTarga, pCasaProdruttrice, pModello
    );
    --
    if lvDuplicatedKey = 1 then
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La vettura è già presente';
    end if;
    
    insert into AutoCoinvolta (
		CodSinistro, NumTarga
	) VALUES (
		pCodSinistro, pNumTarga
	);
END
//
DELIMITER ;
