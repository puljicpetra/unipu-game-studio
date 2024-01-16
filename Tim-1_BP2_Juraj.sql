#------------------------------------
# FUNCTIONS
#------------------------------------
DROP FUNCTION IF EXISTS calc_mod;
DELIMITER //
CREATE FUNCTION calc_mod(ability_score INT) 
RETURNS VARCHAR(5)
DETERMINISTIC
BEGIN
    DECLARE modifier INT;
    SET modifier = FLOOR((ability_score - 10) / 2);
    
    IF modifier > 0 THEN
        RETURN CONCAT('+', modifier);
    ELSE
        RETURN CAST(modifier AS CHAR);
    END IF;
END //
DELIMITER ;
#------------------------------------
# VIEWS
#------------------------------------
DROP VIEW IF EXISTS skill_ability_view;
CREATE VIEW skill_ability_view AS
SELECT s.skill_name, a.ability_name AS ability_score_name
FROM skill s
JOIN ability_score a ON s.ability_score_id = a.id;

DROP VIEW IF EXISTS stat_block_template;
CREATE VIEW stat_block_template AS
SELECT 
    crea.creature_name, 
    s.size, 
    t.creature_type, 
    CONCAT(a.lawfulness, ' ', a.morality) AS alignment, 
    CONCAT(crea.hit_dice_number, d.dice) AS hit_dice, 
    CONCAT(GROUP_CONCAT( DISTINCT CONCAT(mov.movement, ' ', mov.distance)ORDER BY mov.movement SEPARATOR 'ft. '), 'ft. ') AS movement,
    CONCAT(crea.STRENGTH, ' (', calc_mod(crea.STRENGTH), ')') AS STR,
    CONCAT(crea.DEXTERITY, ' (', calc_mod(crea.DEXTERITY), ')') AS DEX,
    CONCAT(crea.CONSTITUTION, ' (', calc_mod(crea.CONSTITUTION), ')') AS CON,
    CONCAT(crea.INTELLIGENCE, ' (', calc_mod(crea.INTELLIGENCE), ')') AS INTE,
    CONCAT(crea.WISDOM, ' (', calc_mod(crea.WISDOM), ')') AS WIS,
    CONCAT(crea.CHARISMA, ' (', calc_mod(crea.CHARISMA), ')') AS CHR,
    GROUP_CONCAT(lang.language_name ORDER BY lang.language_name SEPARATOR ', ') AS languages,
    GROUP_CONCAT(DISTINCT CONCAT(sen.sense, ' ', sen.distance, 'ft') ORDER BY sen.sense SEPARATOR ', ') AS senses,
    GROUP_CONCAT(DISTINCT CONCAT(sk.skill_name, ': ', 
        IF(sp.expertise, crea.proficiency * 2, crea.proficiency) + 
        CASE 
            WHEN ascore.ability_name = 'STRENGTH' THEN FLOOR((crea.STRENGTH - 10) / 2)
            WHEN ascore.ability_name = 'DEXTERITY' THEN FLOOR((crea.DEXTERITY - 10) / 2)
WHEN ascore.ability_name = 'CONSTITUTION' THEN FLOOR((crea.CONSTITUTION - 10) / 2)
WHEN ascore.ability_name = 'INTELLIGENCE' THEN FLOOR((crea.INTELLIGENCE - 10) / 2)
WHEN ascore.ability_name = 'WISDOM' THEN FLOOR((crea.WISDOM - 10) / 2)
WHEN ascore.ability_name = 'CHARISMA' THEN FLOOR((crea.CHARISMA - 10) / 2)
END
) ORDER BY sk.skill_name SEPARATOR ', ') AS skills,
crea.challenge_rating,
cr.experience_points
FROM creature_template AS crea
JOIN size AS s ON crea.size_id = s.id
JOIN creature_type AS t ON crea.creature_type_id = t.id
JOIN alignment AS a ON crea.alignment_id = a.id
JOIN dice AS d ON crea.hit_dice_type_id = d.id
JOIN challenge_rating AS cr ON crea.challenge_rating = cr.rating
LEFT JOIN creature_language AS cl ON crea.id = cl.creature_id
LEFT JOIN languages AS lang ON cl.language_id = lang.id
LEFT JOIN creature_sense AS cs ON crea.id = cs.creature_id
LEFT JOIN sense AS sen ON cs.sense_id = sen.id
LEFT JOIN creature_movement AS cmov ON crea.id = cmov.creature_id
LEFT JOIN movement AS mov ON cmov.movement_id = mov.id
LEFT JOIN skill_proficiency AS sp ON crea.id = sp.creature_id
LEFT JOIN skill AS sk ON sp.skill_id = sk.id
LEFT JOIN ability_score AS ascore ON sk.ability_score_id = ascore.id
GROUP BY crea.creature_name, s.size, t.creature_type, a.lawfulness, a.morality, crea.hit_dice_number, d.dice, crea.STRENGTH, crea.DEXTERITY, crea.CONSTITUTION, crea.INTELLIGENCE, crea.WISDOM, crea.CHARISMA, crea.proficiency, crea.challenge_rating, cr.experience_points;


 

SELECT * FROM stat_block_template;
#------------------------------------
# TRIGGERS
#------------------------------------