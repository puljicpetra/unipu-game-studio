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