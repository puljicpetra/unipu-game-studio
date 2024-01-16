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
