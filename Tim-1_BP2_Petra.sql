DELIMITER //

CREATE TRIGGER bi_notes
BEFORE INSERT ON notes
FOR EACH ROW
BEGIN
 DECLARE note_count INT;

    IF new.title IS NULL OR new.title = '' THEN
        SELECT COUNT(*) INTO note_count FROM notes;
        SET new.title = CONCAT('Note ', note_count + 1);
    END IF;

END //

DELIMITER ;