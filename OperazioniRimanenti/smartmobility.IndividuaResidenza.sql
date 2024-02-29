USE smartmobility;

DROP PROCEDURE IF EXISTS smartmobility.IndividuaResidenza;

delimiter //
CREATE DEFINER=root@localhost PROCEDURE IndividuaResidenza(
pCodFiscale varchar(16)
)
--
IndividuaResidenza:BEGIN
    --
    select SU.DUG, S.Nome, I.Civico, I.Esponente, SU.Comune, SU.Provincia
      from Indirizzo I
           inner join Utente U on (U.CodIndirizzo = I.CodIndirizzo)
           inner join Strada S on (I.CodStrada = S.CodStrada)
           inner join StradaUrbana SU on (S.CodStrada = SU.CodStrada)
	 where U.CodFiscale = pCodFiscale;
    --  
END
//
DELIMITER ;
