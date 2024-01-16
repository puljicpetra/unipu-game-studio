drop function  if exists initiative_roll;
DELIMITER //
CREATE FUNCTION roll_die (p_dice_type INTEGER) RETURNS INTEGER
DETERMINISTIC
BEGIN
    DECLARE rezultat,dice_type INTEGER;
    
    SELECT p_dice_type INTO dice_type
    FROM dice
    WHERE p_dice_type=(CAST(SUBSTRING(dice, 2) AS SIGNED));
    
    SET rezultat=FLOOR(1 + RAND() * dice_type);
    RETURN rezultat;
    END//
DELIMITER ;

DELIMITER //
CREATE FUNCTION initiative_roll(p_creature_id INTEGER) RETURNS INTEGER
DETERMINISTIC
BEGIN
	DECLARE rezultat,roll,dex INTEGER;
    
    SET roll=roll_die(20);
    
    select calculate_modifier(dexterity) into dex
	from creature_template
    WHERE id=p_creature_id;
    
    SET rezultat=roll+dex;
    
    RETURN rezultat;
    END//
DELIMITER ;

