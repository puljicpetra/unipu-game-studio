DELIMITER //
CREATE TRIGGER validate_creature_hp_before_insert
BEFORE INSERT ON creature_instance FOR EACH ROW
BEGIN
    IF NEW.current_hp < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Hit points can not be negative.';
    END IF;
END;
//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE move_player_character(IN player_character_id INT, IN new_x INT, IN new_y INT, IN new_z INT)
BEGIN
    IF EXISTS (SELECT 1 FROM map_creatures WHERE creature_instance_id = player_character_id) THEN
        UPDATE map_creatures
        SET coord_x = new_x, coord_y = new_y, coord_z = new_z
        WHERE creature_instance_id = player_character_id;
    END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE FUNCTION calculate_combat_power(player_character_id INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE ability_score_bonus INT DEFAULT 0;
    DECLARE spell_bonus INT DEFAULT 0;
    DECLARE combat_power INT DEFAULT 0;
    
    SELECT SUM(STRENGTH + DEXTERITY + CONSTITUTION + INTELLIGENCE + WISDOM + CHARISMA) INTO ability_score_bonus
    FROM creature_template
    WHERE id = (SELECT creature_template_id FROM player_character WHERE id = player_character_id);

    SELECT COUNT(*) * 5 INTO spell_bonus
    FROM spell
    INNER JOIN creature_instance_spells_known ON spell.id = creature_instance_spells_known.spell_id
    WHERE creature_instance_spells_known.creature_instance_id = (SELECT creature_instance_id FROM player_character WHERE id = player_character_id);

    SET combat_power = ability_score_bonus + spell_bonus;

    RETURN combat_power;
END;
//
DELIMITER ;

DELIMITER //

CREATE FUNCTION calculate_spell_aoe(spell_id INT, target_x INT, target_y INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE p_aoe_shape VARCHAR(32);
    DECLARE p_aoe_size INT;
    DECLARE affected_tiles INT;

    SELECT a_s.aoe_shape, sas.spell_aoe_shape INTO p_aoe_shape, p_aoe_size
    FROM spell_aoe_shape AS sas
    INNER JOIN aoe_shape AS a_s ON sas.aoe_id = a_s.id
    WHERE sas.spell_id = spell_id;

    CASE aoe_shape
        WHEN 'CONE' THEN
            SET affected_tiles = POW(aoe_size, 2);
        WHEN 'CUBE' THEN
            SET affected_tiles = POW(aoe_size, 2);
        WHEN 'CYLINDER' THEN
            SET affected_tiles = PI() * POW(aoe_size / 2, 2);
        WHEN 'LINE' THEN
            SET affected_tiles = aoe_size;
        WHEN 'SPHERE' THEN
            SET affected_tiles = (4/3) * PI() * POW(aoe_size / 2, 3);
        ELSE
            SET affected_tiles = 0;
    END CASE;

    RETURN affected_tiles;
END;
//
DELIMITER ;


