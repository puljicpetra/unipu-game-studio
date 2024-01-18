drop function  if exists initiative_roll;
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
        SIGNAL SQLSTATE '45001'
        SET MESSAGE_TEXT = 'Prekoracili ste maksimalnu kolicinu tereta kojeg mozete nositi';
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

DELIMITER //
CREATE FUNCTION roll_die(p_dice_type INTEGER) RETURNS INTEGER
DETERMINISTIC
BEGIN
    DECLARE rezultat,dice_type INTEGER;
    
    IF p_dice_type IN (4, 6, 8, 10, 12,20,100) THEN
        SET rezultat = FLOOR(1 + RAND() * p_dice_type);
        RETURN rezultat;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pogresan unos kocke, dozvoljene kocke su tipa: 4, 6, 8, 10, 12,20 ili 100.';
    END IF;
END//
DELIMITER ;

drop function if exists roll_die;

-- view koji prikazuje sva  'finesse' oruzja te prikazati silazno najjaca, tj. maksimalni damage output

drop view if exists strongest_finesse_weapon;
CREATE VIEW strongest_finesse_weapon AS
SELECT
    w.id AS weapon_id,
    i.item_name,
    d.dice,
    w.damage_dice_amount,
    CASE WHEN w.is_martial = 1 THEN 'Yes' ELSE 'No' END AS is_martial,
    w.min_range,
    w.max_range,
    (w.damage_dice_amount * SUBSTRING(d.dice, 2)) AS damage_potential
FROM
    weapon AS w
JOIN
    item AS i ON w.item_id = i.id
JOIN
    weapon_property_match AS wpm ON w.id = wpm.weapon_id
JOIN
    weapon_properties AS wp ON wpm.weapon_property_id = wp.id
JOIN
    dice AS d ON w.damage_dice_id = d.id
WHERE
    wp.property_name = 'Finesse'
ORDER BY
    damage_potential DESC;
    
    









