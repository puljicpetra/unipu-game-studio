DELIMITER //
CREATE TRIGGER death
BEFORE UPDATE ON creature_instance FOR EACH ROW
BEGIN
	IF new.current_hp <= 0 THEN
		DELETE FROM creature_instance WHERE id = new.id;
	END IF;
END;
DELIMITER;