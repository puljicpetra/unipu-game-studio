
-- trigger za smrt creaturea u igrici
DROP TRIGGER IF EXISTS death;
DELIMITER //
CREATE TRIGGER death
BEFORE UPDATE ON creature_instance FOR EACH ROW
BEGIN
	IF new.current_hp <= 0 THEN
		DELETE FROM creature_instance WHERE id = new.id;
	END IF;
END //
DELIMITER ;


-- funkcija koja pokazuje creaturea s najnizim levelom i najvisim levelom koje igrac ima
DROP FUNCTION IF EXISTS characters_level;
DELIMITER //
CREATE FUNCTION characters_level(p_id INTEGER) RETURNS VARCHAR(300)
DETERMINISTIC
BEGIN
	DECLARE min_level INT;
    DECLARE max_level INT;
    DECLARE min_character VARCHAR(50);
    DECLARE max_character VARCHAR(50);
    SELECT MIN(class_level), MAX(class_level) INTO min_level, max_level
		FROM player_character
        WHERE player_id = p_id;
	SELECT ct.character_name, pc.class_level INTO max_character, max_level
		FROM player_character AS pc
        INNER JOIN creature_instance AS ci ON ci.id = pc.creature_instance.id
        INNER JOIN creature_template AS ct ON ct.id = ci.creature_template.id;
	SELECT ct.character_name, pc.class_level INTO min_character, min_level
		FROM player_character AS pc
        INNER JOIN creature_instance AS ci ON ci.id = pc.creature_instance.id
        INNER JOIN creature_template AS ct ON ct.id = ci.creature_template.id;
	RETURN CONCAT('Character with the lowest level: ', min_character, ' Level ', min_level, ' | Character with the highest level: ', max_character, ' Level ', max_level,'');
END //
DELIMITER ;

-- pogled koji sam sortira stvorenja u igrici prema velicini
DROP VIEW IF EXISTS creatures_size_sorted;
CREATE VIEW creatures_size_sorted AS
SELECT creature_name, s.size
	FROM creature_template AS ct
	INNER JOIN size AS s ON ct.size_id = s.id
	ORDER BY FIELD(size, 'TINY', 'SMALL', 'MEDIUM', 'LARGE', 'HUGE', 'GARGANTUAN');

SELECT * FROM creatures_size_sorted;

-- procedura koja dodaje igraca u određeni game
DROP PROCEDURE IF EXISTS add_player_to_game;
DELIMITER //
CREATE PROCEDURE add_player_to_game( IN p_game_instance_id INT, p_player_id INT)
BEGIN
	DECLARE l_num INTEGER;
    SELECT COUNT(*) INTO l_num
		FROM game_players AS gp
        WHERE game_id = p_game_instance_id AND player_id = p_player_id;
    IF l_num > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Player is already in the game.';
    ELSE
        INSERT INTO game_players (game_id, player_id)
        VALUES (p_game_instance_id, p_player_id);
        
        SELECT  'Player added successfully' AS result;
    END IF;
END //
DELIMITER ;

