USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.InsSinistro;

delimiter //
CREATE DEFINER=root@localhost FUNCTION InsSinistro(
pCodNoleggio varchar(12),
pDataOraSinistro datetime,
pCodPosizione varchar(12),
pDinamica varchar(256)
) RETURNS char(12)
--
InsSinistro:BEGIN
    DECLARE lvCodSinistro varchar(12) default NULL;
    DECLARE lvRecNotFound int default 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND set lvRecNotFound = 1;
    --
    select CodSinistro
      into lvCodSinistro
      from Sinistro
     where CodNoleggio = pCodNoleggio
	   and DataOraSinistro = pDataOraSinistro
       and CodPosizione = pCodPosizione;
    --
    if lvRecNotFound = 1 then
        set lvCodSinistro = smartmobility.NewProgressivo('SNR', 'Sinistro');
        insert into Sinistro (
            CodSinistro, CodNoleggio, DataOraSinistro, CodPosizione, Dinamica
        ) VALUES (
            lvCodSinistro, pCodNoleggio, pDataOraSinistro, pCodPosizione, pDinamica
        );
    end if;
    --
    return lvCodSinistro;
END
//
DELIMITER ;
