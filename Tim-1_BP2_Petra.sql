-- TRIGGERI 

DROP TRIGGER IF EXISTS bi_notes;
DELIMITER //

CREATE TRIGGER bi_notes
BEFORE INSERT ON notes
FOR EACH ROW
BEGIN
 DECLARE note_count INT;

    IF new.title IS NULL OR new.title = '' THEN
        SELECT COUNT(*) INTO note_count 
        FROM notes;
        SET new.title = CONCAT('Note ', note_count + 1);
    END IF;

END //

DELIMITER ;



ALTER TABLE notes
ADD COLUMN created_at DATETIME,
ADD COLUMN modified_at DATETIME;

DROP TRIGGER IF EXISTS bi_notes_timestamp
DELIMITER //


CREATE TRIGGER bi_notes_timestamp
BEFORE INSERT ON notes
FOR EACH ROW
BEGIN
    SET new.created_at = CURRENT_TIMESTAMP;
    SET new.modified_at = CURRENT_TIMESTAMP;
END;
//
DELIMITER ;

DROP TRIGGER IF EXISTS bu_notes_timestamp
DELIMITER //
CREATE TRIGGER bu_notes_timestamp
BEFORE UPDATE ON notes
FOR EACH ROW
BEGIN
    SET new.modified_at = CURRENT_TIMESTAMP;
END;
//
DELIMITER ;


-- FUNKCIJE

DROP FUNCTION IF EXISTS get_player_character_info;
DELIMITER //
CREATE FUNCTION get_player_character_info(player_character_id INT) RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE player_info VARCHAR(255);

    IF NOT EXISTS (SELECT 1 FROM player_character WHERE id = player_character_id) THEN
        RETURN 'Player character does not exist';
    END IF;
    
    SELECT CONCAT('Player Name: ', p.player_name, ', Race: ', r.race_name, ', Class: ', c.class_name, ', Level: ', pc.class_level) INTO player_info
    FROM player_character pc
    JOIN player p ON pc.player_id = p.id
    JOIN race r ON pc.race_id = r.id
    JOIN class c ON pc.class_id = c.id
    WHERE pc.id = player_character_id;
    
    RETURN player_info;
END //
DELIMITER ;

SELECT get_player_character_info(6) AS player_character_info;


-- PROCEDURA
-- neovisna o trigger kojeg netko ima vec (onaj da se, ako su hp<0, izbrise)

DROP PROCEDURE IF EXISTS GetPlayerInfo;
DELIMITER //

CREATE PROCEDURE GetPlayerInfo(
    IN player_character_id INT
)
BEGIN
    DECLARE current_hp INT;
    DECLARE creature_name VARCHAR(64);

    SELECT ci.current_hp, ct.creature_name
    INTO current_hp, creature_name
    FROM creature_instance ci
    JOIN creature_template ct ON ci.creature_template_id = ct.id
    WHERE ci.id = player_character_id;

    IF current_hp IS NOT NULL THEN
        SELECT
            player_character_id AS id,
            creature_name AS name,
            current_hp AS hit_points,
            CASE
                WHEN current_hp > 0 THEN 'Alive'
                ELSE 'Dead'
            END AS status;
    ELSE
        SELECT 'Player character does not exist.' AS result;
    END IF;
END //

DELIMITER ;
