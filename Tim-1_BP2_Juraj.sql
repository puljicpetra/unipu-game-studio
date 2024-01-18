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

DROP FUNCTION IF EXISTS get_race_names;
DELIMITER //
CREATE FUNCTION get_race_names(race_id INT, gender ENUM('MASCULINE', 'FEMININE', 'NEUTRAL'), include_family_names BOOL)
RETURNS VARCHAR(255) READS SQL DATA
BEGIN
    DECLARE names VARCHAR(255);
    IF include_family_names THEN
        SELECT GROUP_CONCAT(DISTINCT cn.common_name ORDER BY cn.common_name SEPARATOR ', ') INTO names
        FROM race_names rn
        JOIN common_names cn ON rn.common_name_id = cn.id
        WHERE rn.race_id = race_id AND (cn.gender = gender AND cn.is_family_name = TRUE);
    ELSE
        SELECT GROUP_CONCAT(DISTINCT cn.common_name ORDER BY cn.common_name SEPARATOR ', ') INTO names
        FROM race_names rn
        JOIN common_names cn ON rn.common_name_id = cn.id
        WHERE rn.race_id = race_id AND (cn.gender = gender AND cn.is_family_name = FALSE);
    END IF;
    RETURN names;
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

DROP VIEW IF EXISTS items_consumable;
CREATE VIEW items_consumable AS
SELECT 
    itm.item_name, 
    itm.item_description,
    itm.WEIGHT, 
    CONCAT(itm.cost_amount, 'x ', cost_item.item_name) AS cost,
    IF(con.is_healing, CONCAT(con.dice_amount, dice.dice, ' Healing'), NULL) AS healing,
    CASE 
        WHEN con.saving_throw_ability_id IS NOT NULL THEN CONCAT(ability.ability_name, ' DC ', con.saving_throw_DC)
        ELSE NULL
    END AS saving_throw,
    cond.condition_name AS condition_effect,
    feat.feature_name AS feature
FROM consumable AS con
JOIN item AS itm ON con.item_id = itm.id
LEFT JOIN item AS cost_item ON itm.cost_id = cost_item.id
LEFT JOIN dice ON con.dice_id = dice.id
LEFT JOIN ability_score AS ability ON con.saving_throw_ability_id = ability.id
LEFT JOIN conditions AS cond ON con.condition_id = cond.id
LEFT JOIN features AS feat ON con.feature_id = feat.id;

DROP VIEW IF EXISTS items_throwable;
CREATE VIEW items_throwable AS
SELECT 
    itm.item_name, 
    itm.item_description,
    itm.WEIGHT, 
    CONCAT(itm.cost_amount, 'x ', cost_item.item_name) AS cost,
    CONCAT(throw.range_min, '/', throw.range_max, ' ft.') AS throw_range,
    CONCAT(aoe.shape, ' (', aoe.shape_size, ' ft.)') AS aoe,
    CASE 
        WHEN throw.saving_throw_ability_id IS NOT NULL THEN CONCAT(ability.ability_name, ' DC ', throw.saving_throw_DC)
        ELSE NULL
    END AS saving_throw,
    CONCAT(throw.damage_dice_amount, dice.dice, ' ', dt.damage) AS damage
FROM throwable AS throw
JOIN item AS itm ON throw.item_id = itm.id
LEFT JOIN item AS cost_item ON itm.cost_id = cost_item.id
LEFT JOIN aoe_shape AS aoe ON throw.aoe_id = aoe.id
LEFT JOIN ability_score AS ability ON throw.saving_throw_ability_id = ability.id
LEFT JOIN dice ON throw.damage_dice_id = dice.id
LEFT JOIN damage_type AS dt ON throw.damage_type_id = dt.id;

DROP VIEW IF EXISTS items_light_source;
CREATE VIEW items_light_source AS
SELECT 
    itm.item_name, 
    itm.item_description,
    itm.WEIGHT, 
    CONCAT(itm.cost_amount, 'x ', cost_item.item_name) AS cost,
    CONCAT(aoe.shape, ' (', aoe.shape_size, ' ft.)') AS light_aoe,
    CONCAT(light.duration_in_minutes, ' minutes') AS duration
FROM light_source AS light
JOIN item AS itm ON light.item_id = itm.id
LEFT JOIN item AS cost_item ON itm.cost_id = cost_item.id
LEFT JOIN aoe_shape AS aoe ON light.aoe_id = aoe.id;

DROP VIEW IF EXISTS player_backgrounds;
CREATE VIEW player_backgrounds AS
SELECT 
    bg.background_name, 
    bg.background_description,
    GROUP_CONCAT(DISTINCT skl.skill_name ORDER BY skl.skill_name SEPARATOR ', ') AS skills,
    GROUP_CONCAT(DISTINCT lang.language_name ORDER BY lang.language_name SEPARATOR ', ') AS languages,
    GROUP_CONCAT(DISTINCT item_prof.item_name ORDER BY item_prof.item_name SEPARATOR ', ') AS item_proficiencies,
    GROUP_CONCAT(DISTINCT CONCAT(eq.item_name, ' x', be.amount) ORDER BY eq.item_name SEPARATOR ', ') AS equipment
FROM background AS bg
LEFT JOIN background_skills AS bgs ON bg.id = bgs.background_id
LEFT JOIN skill AS skl ON bgs.skill_id = skl.id
LEFT JOIN background_languages AS bgl ON bg.id = bgl.background_id
LEFT JOIN languages AS lang ON bgl.language_id = lang.id
LEFT JOIN background_item_prof AS bip ON bg.id = bip.background_id
LEFT JOIN item AS item_prof ON bip.item_id = item_prof.id
LEFT JOIN background_equipment AS be ON bg.id = be.background_id
LEFT JOIN item AS eq ON be.item_id = eq.id
GROUP BY bg.background_name, bg.background_description;

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

DROP VIEW IF EXISTS player_race;
CREATE VIEW player_race AS
SELECT 
    r.race_name, 
    r.flavor,
    r.culture,
    r.maturity_age,
    r.maximum_age,
    CONCAT(al.lawfulness, ' ', al.morality) AS typical_alignment,
    sz.size,
    ct.creature_type,
    CONCAT(r.height_min, ' - ', r.height_max, ' cm') AS height_range,
    CONCAT(r.weight_min, ' - ', r.weight_max, ' lbs') AS weight_range,
    GROUP_CONCAT(DISTINCT feat.feature_name ORDER BY feat.feature_name SEPARATOR ', ') AS features,
    GROUP_CONCAT(DISTINCT itm.item_name ORDER BY itm.item_name SEPARATOR ', ') AS item_proficiencies,
    GROUP_CONCAT(DISTINCT CONCAT(spl.spell_name, ' (Level ', spl.spell_level, ')') ORDER BY spl.spell_name SEPARATOR ', ') AS racial_spells,
    GROUP_CONCAT(DISTINCT sk.skill_name ORDER BY sk.skill_name SEPARATOR ', ') AS skill_proficiencies,
    GROUP_CONCAT(DISTINCT CONCAT(mov.movement, ' ', mov.distance, 'ft') ORDER BY mov.movement SEPARATOR ', ') AS movements,
    GROUP_CONCAT(DISTINCT CONCAT(sen.sense, ' ', sen.distance, 'ft') ORDER BY sen.sense SEPARATOR ', ') AS senses,
    GROUP_CONCAT(DISTINCT CONCAT(ascore.ability_name, ' +', ra.increase) ORDER BY ascore.ability_name SEPARATOR ', ') AS ability_score_increases,
    GROUP_CONCAT(DISTINCT lang.language_name ORDER BY lang.language_name SEPARATOR ', ') AS languages,
    GROUP_CONCAT(DISTINCT CONCAT(dt.damage, ' ', dr.relationship) ORDER BY dt.damage SEPARATOR ', ') AS damage_relationships,
    GROUP_CONCAT(DISTINCT cn.common_name ORDER BY cn.common_name SEPARATOR ', ') AS common_names,
    GROUP_CONCAT(DISTINCT CONCAT(cond.condition_name, ' ', cr.condition_relationship) ORDER BY cond.condition_name SEPARATOR ', ') AS condition_relationships,
    get_race_names(r.id, 'MASCULINE', FALSE) AS masculine_names,
    get_race_names(r.id, 'FEMININE', FALSE) AS feminine_names,
    get_race_names(r.id, 'NEUTRAL', FALSE) AS neutral_names,
    get_race_names(r.id, 'NEUTRAL', TRUE) AS family_names
FROM race AS r
LEFT JOIN alignment AS al ON r.typical_alignment_id = al.id
LEFT JOIN size AS sz ON r.size_id = sz.id
LEFT JOIN creature_type AS ct ON r.creature_type_id = ct.id
LEFT JOIN race_feature AS rf ON r.id = rf.race_id
LEFT JOIN features AS feat ON rf.feature_id = feat.id
LEFT JOIN race_item_prof AS rip ON r.id = rip.race_id
LEFT JOIN item AS itm ON rip.item_id = itm.id
LEFT JOIN racial_spells AS rsp ON r.id = rsp.race_id
LEFT JOIN spell AS spl ON rsp.spell_id = spl.id
LEFT JOIN race_skill_prof AS rspf ON r.id = rspf.race_id
LEFT JOIN skill AS sk ON rspf.skill_id = sk.id
LEFT JOIN race_movement AS rm ON r.id = rm.race_id
LEFT JOIN movement AS mov ON rm.movement_id = mov.id
LEFT JOIN race_sense AS rs ON r.id = rs.race_id
LEFT JOIN sense AS sen ON rs.sense_id = sen.id
LEFT JOIN race_asi AS ra ON r.id = ra.race_id
LEFT JOIN ability_score AS ascore ON ra.ability_id = ascore.id
LEFT JOIN race_language AS rlang ON r.id = rlang.race_id
LEFT JOIN languages AS lang ON rlang.language_id = lang.id
LEFT JOIN race_damage_relationship AS rdr ON r.id = rdr.race_id
LEFT JOIN damage_type_relationship AS dtr ON rdr.damage_type_relationship_id = dtr.id
LEFT JOIN damage_type AS dt ON dtr.damage_id = dt.id
LEFT JOIN damage_relationship AS dr ON dtr.damage_relationship_id = dr.id
LEFT JOIN race_names AS rn ON r.id = rn.race_id
LEFT JOIN common_names AS cn ON rn.common_name_id = cn.id
LEFT JOIN race_condition_relationship AS rcr ON r.id = rcr.race_id
LEFT JOIN condition_relationship AS cr ON rcr.condition_relationship_id = cr.id
LEFT JOIN conditions AS cond ON cr.condition_id = cond.id
GROUP BY r.race_name, r.flavor, r.culture, r.maturity_age, r.maximum_age, typical_alignment, sz.size, ct.creature_type, height_range, weight_range;

SELECT * FROM player_race;

#------------------------------------
# TRIGGERS
#------------------------------------

