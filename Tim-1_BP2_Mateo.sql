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

CREATE VIEW player_character_overview AS
SELECT 
    pc.id AS PlayerCharacterID,
    p.player_name AS PlayerName,
    SUM(i.cost_amount) AS TotalItemValue,
    COUNT(DISTINCT cis.spell_id) AS NumberOfSpellsKnown,
    ci.current_hp AS CurrentHitPoints,
    SUM(a.base_armor_class) AS TotalArmorClass
FROM 
    player_character pc
    JOIN player p ON pc.player_id = p.id
    JOIN creature_instance ci ON pc.creature_instance_id = ci.id
    LEFT JOIN creature_item ci2 ON ci.id = ci2.creature_id
    LEFT JOIN item i ON ci2.item_id = i.id
    LEFT JOIN armor a ON i.id = a.item_id
    LEFT JOIN creature_instance_spells_known cis ON ci.id = cis.creature_instance_id
GROUP BY 
    pc.id, p.player_name, ci.current_hp;
    

CREATE VIEW player_character_summary AS
SELECT 
    pc.id AS PlayerCharacterID,
    p.player_name AS PlayerName,
    r.race_name AS Race,
    cl.class_name AS Class,
    COUNT(DISTINCT cis.spell_id) AS NumberOfSpellsKnown,
    GROUP_CONCAT(i.item_name SEPARATOR ', ') AS InventoryItems
FROM 
    player_character pc
    JOIN player p ON pc.player_id = p.id
    JOIN race r ON pc.race_id = r.id
    JOIN class cl ON pc.class_id = cl.id
    LEFT JOIN creature_instance_spells_known cis ON pc.creature_instance_id = cis.creature_instance_id
    LEFT JOIN creature_instance_inventory cii ON pc.creature_instance_id = cii.creature_instance_id
    LEFT JOIN item i ON cii.item_id = i.id
GROUP BY 
    pc.id, p.player_name, r.race_name, cl.class_name;
    
SELECT * FROM player_character_summary;





