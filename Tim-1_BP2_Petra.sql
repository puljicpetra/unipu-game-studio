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
