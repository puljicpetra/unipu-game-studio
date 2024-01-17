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


-- ???
/*
DROP PROCEDURE Calculate_Experience
 
DELIMITER //

CREATE PROCEDURE Calculate_Experience(IN player1_level INT, IN player2_level INT, IN player3_level INT, IN player4_level INT, IN creature_id INT)
BEGIN
    DECLARE totalExperience INT;

    SELECT SUM(cr.experience_points) INTO totalExperience
    FROM creature_template ct
    JOIN challenge_rating cr ON ct.challenge_rating = cr.rating
    WHERE ct.id = creature_id;

    IF totalExperience IS NOT NULL THEN
        SET totalExperience = totalExperience * (player1_level + player2_level + player3_level + player4_level);

        SELECT totalExperience AS 'Total Experience Points for the Party';
    ELSE
        SELECT 'Creature not found with the specified ID' AS 'Error';
    END IF;
END //

DELIMITER ;
*/
