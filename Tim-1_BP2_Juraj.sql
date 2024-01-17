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

DROP FUNCTION IF EXISTS calculate_skill_bonus;
DELIMITER //
CREATE FUNCTION calculate_skill_bonus(ability_score INT, proficiency_bonus INT, has_expertise BOOL)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    DECLARE modifier INT;
    DECLARE skill_bonus INT;
    DECLARE result VARCHAR(10);
    
    SET modifier = FLOOR((ability_score - 10) / 2);
    IF has_expertise THEN
        SET skill_bonus = modifier + (2 * proficiency_bonus);
    ELSE
        SET skill_bonus = modifier + proficiency_bonus;
    END IF;
        IF skill_bonus > 0 THEN
        SET result = CONCAT('+', skill_bonus);
    ELSEIF skill_bonus < 0 THEN
        SET result = CAST(skill_bonus AS CHAR);
    ELSE
        SET result = '0';
    END IF;
    
    RETURN result;
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

DROP VIEW IF EXISTS items_armor;
CREATE VIEW items_armor AS
SELECT 
    itm.item_name, 
    itm.item_description,
    itm.WEIGHT, 
    CONCAT(itm.cost_amount, 'x ', cost_item.item_name) AS cost,
    arm.armor_type, 
    arm.strength_minimum, 
    arm.stealth_disadvantage, 
    arm.base_armor_class, 
    arm.maximum_dex_modifier
FROM armor AS arm
JOIN item AS itm ON arm.item_id = itm.id
LEFT JOIN item AS cost_item ON itm.cost_id = cost_item.id;

SELECT * FROM items_armor;

DROP VIEW IF EXISTS items_weapons;
CREATE VIEW items_weapons AS
SELECT 
    itm.item_name, 
    itm.item_description,
    itm.WEIGHT, 
    CONCAT(itm.cost_amount, 'x ', cost_item.item_name) AS cost,
    wpn.is_martial, 
    wpn.min_range, 
    wpn.max_range,
    CONCAT(wpn.damage_dice_amount, dice.dice, ' ', dt.damage) AS damage,
    GROUP_CONCAT(wp.property_name ORDER BY wp.property_name SEPARATOR ', ') AS weapon_properties
FROM weapon AS wpn
JOIN item AS itm ON wpn.item_id = itm.id
LEFT JOIN item AS cost_item ON itm.cost_id = cost_item.id
LEFT JOIN dice ON wpn.damage_dice_id = dice.id
LEFT JOIN damage_type AS dt ON wpn.damage_type_id = dt.id
LEFT JOIN weapon_property_match AS wpm ON wpn.id = wpm.weapon_id
LEFT JOIN weapon_properties AS wp ON wpm.weapon_property_id = wp.id
GROUP BY itm.item_name, itm.item_description, itm.WEIGHT, cost, wpn.is_martial, wpn.min_range, wpn.max_range, damage;

SELECT * FROM items_weapons;

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
    GROUP_CONCAT(DISTINCT lang.language_name ORDER BY lang.language_name SEPARATOR ', ') AS languages,
    GROUP_CONCAT(DISTINCT CONCAT(sen.sense, ' ', sen.distance, 'ft') ORDER BY sen.sense SEPARATOR ', ') AS senses,
    GROUP_CONCAT(DISTINCT CONCAT(sk.skill_name, ': ', 
        calculate_skill_bonus(
            CASE 
                WHEN ascore.ability_name = 'STRENGTH' THEN crea.STRENGTH
                WHEN ascore.ability_name = 'DEXTERITY' THEN crea.DEXTERITY
                WHEN ascore.ability_name = 'CONSTITUTION' THEN crea.CONSTITUTION
                WHEN ascore.ability_name = 'INTELLIGENCE' THEN crea.INTELLIGENCE
                WHEN ascore.ability_name = 'WISDOM' THEN crea.WISDOM
                WHEN ascore.ability_name = 'CHARISMA' THEN crea.CHARISMA
            END,
            crea.proficiency, sp.expertise
        ) ) ORDER BY sk.skill_name SEPARATOR ', ') AS skills,
GROUP_CONCAT(DISTINCT CONCAT(c.condition_name, ' ', cr.condition_relationship) ORDER BY c.condition_name SEPARATOR ', ') AS condition_relationships,
GROUP_CONCAT(DISTINCT CONCAT(dt.damage, ' ', dr.relationship) ORDER BY dt.damage SEPARATOR ', ') AS damage_relationships,
crea.challenge_rating, crt.experience_points
FROM creature_template AS crea
JOIN size AS s ON crea.size_id = s.id
JOIN creature_type AS t ON crea.creature_type_id = t.id
JOIN alignment AS a ON crea.alignment_id = a.id
JOIN dice AS d ON crea.hit_dice_type_id = d.id
JOIN challenge_rating AS crt ON crea.challenge_rating = crt.rating
LEFT JOIN creature_language AS cl ON crea.id = cl.creature_id
LEFT JOIN languages AS lang ON cl.language_id = lang.id
LEFT JOIN creature_sense AS cs ON crea.id = cs.creature_id
LEFT JOIN sense AS sen ON cs.sense_id = sen.id
LEFT JOIN creature_movement AS cmov ON crea.id = cmov.creature_id
LEFT JOIN movement AS mov ON cmov.movement_id = mov.id
LEFT JOIN skill_proficiency AS sp ON crea.id = sp.creature_id
LEFT JOIN skill AS sk ON sp.skill_id = sk.id
LEFT JOIN ability_score AS ascore ON sk.ability_score_id = ascore.id
LEFT JOIN creature_damage_relationship AS cdr ON crea.id = cdr.creature_id
LEFT JOIN damage_type_relationship AS dtr ON cdr.damage_type_relationship_id = dtr.id
LEFT JOIN damage_type AS dt ON dtr.damage_id = dt.id
LEFT JOIN damage_relationship AS dr ON dtr.damage_relationship_id = dr.id
LEFT JOIN creature_condition_relationship AS ccr ON crea.id = ccr.creature_id
LEFT JOIN condition_relationship AS cr ON ccr.condition_relationship_id = cr.id
LEFT JOIN conditions AS c ON cr.condition_id = c.id
GROUP BY crea.creature_name, s.size, t.creature_type, a.lawfulness, a.morality, crea.hit_dice_number, d.dice, crea.STRENGTH, crea.DEXTERITY, crea.CONSTITUTION, crea.INTELLIGENCE, crea.WISDOM, crea.CHARISMA, crea.proficiency, crea.challenge_rating, crt.experience_points;

#------------------------------------
# TRIGGERS
#------------------------------------

