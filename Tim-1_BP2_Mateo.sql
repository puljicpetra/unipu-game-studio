DELIMITER //
CREATE TRIGGER validate_creature_hp_before_insert
BEFORE INSERT ON creature_instance FOR EACH ROW
BEGIN
    IF NEW.current_hp <= 0 THEN
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

SELECT 
    ct.creature_type AS 'Creature Type',
    ctemp.creature_name AS 'Creature Name',
    ctemp.challenge_rating AS 'Challenge Rating',
    (ctemp.STRENGTH + ctemp.DEXTERITY + ctemp.CONSTITUTION + ctemp.INTELLIGENCE + ctemp.WISDOM + ctemp.CHARISMA) AS 'Total Ability Score',
    ctemp.proficiency AS 'Proficiency Bonus'
FROM 
    creature_template ctemp
    JOIN creature_type ct ON ctemp.creature_type_id = ct.id
ORDER BY 
    ct.creature_type, ctemp.challenge_rating DESC;
    
    

CREATE VIEW race_summary AS
SELECT 
    r.race_name,
    a.lawfulness,
    a.morality,
    s.size,
    CONCAT(r.height_min, ' - ', r.height_max, ' cm') AS HeightRange,
    CONCAT(r.weight_min, ' - ', r.weight_max, ' kg') AS WeightRange,
    CONCAT(r.maturity_age, ' - ', r.maximum_age, ' years') AS Lifespan,
    GROUP_CONCAT(l.language_name SEPARATOR ', ') AS Languages
FROM 
    race r
    JOIN alignment a ON r.typical_alignment_id = a.id
    JOIN size s ON r.size_id = s.id
    JOIN race_language rl ON r.id = rl.race_id
    JOIN languages l ON rl.language_id = l.id
GROUP BY 
    r.id;

SELECT * FROM race_summary;





