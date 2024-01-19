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


-- view koji prikazuje sva  'finesse' oruzja te prikazati silazno najjaca, tj. maksimalni damage output

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
    
    
    DELIMITER //
    
CREATE PROCEDURE add_spell(
    IN p_spell_name VARCHAR(128),
    IN p_spell_school ENUM('ABJURATION', 'CONJURATION', 'DIVINATION', 'ENCHANTMENT', 'EVOCATION', 'ILLUSION', 'NECROMANCY', 'TRANSMUTATION'),
    IN p_spell_level INT,
    IN p_is_ritual BOOL,
    IN p_is_concentration BOOL,
    IN p_casting_time_unit_id INT,
    IN p_casting_unit_amount INT,
    IN p_duration_time_unit_id INT,
    IN p_duration_unit_amount INT,
    IN p_casting_range INT,
    IN p_number_of_targets INT,
    IN p_damage_dice_type_id INT,
    IN p_damage_dice_amount INT,
    IN p_uses_damage_modifier BOOL,
    IN p_is_attack_roll BOOL,
    IN p_saving_throw_id INT,
    IN p_spell_description TEXT,
    IN p_components INT,
    IN p_aoe_shape ENUM('CONE', 'CUBE', 'CYLINDER', 'LINE', 'SPHERE'),
    IN p_aoe_shape_size INT,
    IN p_class_list INT
)
BEGIN
    DECLARE new_spell_id INT;
    START TRANSACTION;

    INSERT INTO spell (
        spell_name, spell_school, spell_level, is_ritual, is_concentration,
        casting_time_unit_id, casting_unit_amount, duration_time_unit_id,
        duration_unit_amount, casting_range, number_of_targets, damage_dice_type_id,
        damage_dice_amount, uses_damage_modifier, is_attack_roll, saving_throw_id,
        spell_description
    ) VALUES (
        p_spell_name, p_spell_school, p_spell_level, p_is_ritual, p_is_concentration,
        p_casting_time_unit_id, p_casting_unit_amount, p_duration_time_unit_id,
        p_duration_unit_amount, p_casting_range, p_number_of_targets, p_damage_dice_type_id,
        p_damage_dice_amount, p_uses_damage_modifier, p_is_attack_roll, p_saving_throw_id,
        p_spell_description
    );

    SET new_spell_id = LAST_INSERT_ID();

    INSERT INTO spell_components (spell_id, components_id) VALUES (new_spell_id,p_components);
   
    INSERT INTO spell_aoe_shape (spell_id, aoe_id)
    VALUES (new_spell_id, (SELECT id FROM aoe_shape WHERE shape = p_aoe_shape AND shape_size = p_aoe_shape_size));

    INSERT INTO spell_class (class_id, spell_id) VALUES (p_class_list,new_spell_id);

	COMMIT;
END //

DELIMITER ;



DELIMITER //
CREATE PROCEDURE add_item(IN player_character_id INT,IN item_id INT,IN amount INT)
BEGIN
	START TRANSACTION;
        INSERT INTO creature_instance_inventory (creature_instance_id, item_id, amount)
        VALUES (player_character_id, item_id, amount);
	COMMIT;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER bi_inventory BEFORE INSERT ON creature_instance_inventory
FOR EACH ROW
BEGIN
    DECLARE existing_amount INT;
    
    SELECT amount INTO existing_amount
    FROM creature_instance_inventory as cii
    WHERE cii.item_id = NEW.item_id;

    IF existing_amount IS NOT NULL THEN
        UPDATE creature_instance_inventory
        SET amount = existing_amount + 1;
        SIGNAL SQLSTATE '45002'
        SET MESSAGE_TEXT = 'već postoji taj item u inventoryu, nadodana kolicina';
    END IF;
END //
DELIMITER ;








    
    









