DROP TRIGGER IF EXISTS death;
DELIMITER //
CREATE TRIGGER death
BEFORE UPDATE ON creature_instance FOR EACH ROW
BEGIN
	IF new.current_hp <= 0 THEN
		DELETE FROM creature_instance WHERE id = new.id;
	END IF;
END;
DELIMITER;

DROP FUNCTION IF EXISTS characters_level;
DELIMITER //
CREATE FUNCTION characters_level(p_id INTEGER) RETURNS VARCHAR(150)
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