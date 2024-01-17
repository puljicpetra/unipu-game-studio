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

DELIMITER //
CREATE TRIGGER bi_check_carry_limit
BEFORE INSERT ON creature_instance_inventory
FOR EACH ROW
BEGIN
    DECLARE total_weight DECIMAL(10,2);
    DECLARE x INTEGER;
	SET x=calc_carry_weight(creature_instance_id);

    SELECT 
    SUM(ci.amount * i.weight) INTO total_weight
FROM 
    creature_instance_inventory AS cii
JOIN 
    item AS i ON cii.item_id = i.id;
    
    
    SET total_weight = total_weight+ (NEW.amount * NEW.item.weight);

    IF total_weight > x
 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Prekoracili ste maximalnu kolicinu tereta kojeg mozete nositi';
    END IF;
END;
//
DELIMITER ;


DELIMITER //

CREATE FUNCTION calculate_modifier(ability_score INT) RETURNS INT
DETERMINISTIC
BEGIN
    RETURN FLOOR((ability_score - 10) / 2);
END //

DELIMITER ;

DELIMITER //
CREATE FUNCTION calc_carry_weight(p_creature_id INTEGER) RETURNS INTEGER
DETERMINISTIC
BEGIN
DECLARE carry_limit INTEGER;

	SELECT strength*15 INTO carry_limit
FROM creature_template
WHERE creature_template.id=p_creature_id;
RETURN carry_limit;

END//
DELIMITER ;








