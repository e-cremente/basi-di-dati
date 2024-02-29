USE smartmobility;

DROP FUNCTION IF EXISTS smartmobility.MyRound;

delimiter //
CREATE DEFINER=root@localhost FUNCTION smartmobility.MyRound(
pNumber decimal(65,30),
pStep   decimal(65,30)
) RETURNS decimal(65,30)
COMMENT 'Restituisce il numero pNumber arrotondato ad un multiplo di pStep'
MyRound:BEGIN
    return round(pNumber/pStep,0)*pStep;
END;
//
delimiter ;
