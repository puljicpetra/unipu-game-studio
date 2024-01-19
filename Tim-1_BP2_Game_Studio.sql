DROP DATABASE IF EXISTS game_studio;
CREATE DATABASE game_studio;
USE game_studio;

#------------------------------------
# SCHEMA
#------------------------------------


CREATE TABLE ability_score( 
	id INT AUTO_INCREMENT PRIMARY KEY,
	ability_name ENUM('STRENGTH', 'DEXTERITY', 'CONSTITUTION', 'INTELLIGENCE', 'WISDOM', 'CHARISMA') UNIQUE NOT NULL 
);

CREATE TABLE skill (
    id INT PRIMARY KEY AUTO_INCREMENT,
    skill_name VARCHAR(30) NOT NULL,
    ability_score_id INT NOT NULL,
    UNIQUE (skill_name, ability_score_id),
    FOREIGN KEY (ability_score_id) REFERENCES ability_score (id) ON UPDATE CASCADE
);

CREATE TABLE dice(
	id INT PRIMARY KEY AUTO_INCREMENT,
	dice ENUM ('d4', 'd6', 'd8', 'd10', 'd12', 'd20', 'd100') UNIQUE NOT NULL
);
    
CREATE TABLE size(
	id INT PRIMARY KEY AUTO_INCREMENT,
	size ENUM ('TINY', 'SMALL', 'MEDIUM', 'LARGE', 'HUGE', 'GARGANTUAN') NOT NULL,
	space INT NOT NULL,
    UNIQUE (size, space)
);
    
CREATE TABLE alignment(
	id INT PRIMARY KEY AUTO_INCREMENT,
	lawfulness ENUM ("LAWFUL", "NEUTRAL", "CHAOTIC") NOT NULL,
	morality ENUM ("GOOD", "NEUTRAL", "EVIL") NOT NULL,
    UNIQUE (lawfulness, morality)
);
    
CREATE TABLE creature_type(
	id INT PRIMARY KEY AUTO_INCREMENT,
	creature_type ENUM ('ABERRATION', 'BEAST', 'CELESTIAL', 'CONSTRUCT', 'DRAGON', 'ELEMENTAL', 'FEY', 'FIEND', 'GIANT', 'HUMANOID', 'MONSTROSITY', 'OOZE', 'PLANT', 'UNDEAD') UNIQUE NOT NULL DEFAULT "HUMANOID"
);

CREATE TABLE challenge_rating (
    rating NUMERIC(10, 2) PRIMARY KEY,
    experience_points INT NOT NULL DEFAULT 0, 
    CHECK (experience_points > 0)
);
    
CREATE TABLE creature_template (
	id INT PRIMARY KEY AUTO_INCREMENT,
	creature_name VARCHAR (64) UNIQUE NOT NULL,
	size_id INT NOT NULL DEFAULT 2, 
	creature_type_id INT NOT NULL DEFAULT 10,
	alignment_id INT NOT NULL DEFAULT 0,
	STRENGTH INT NOT NULL DEFAULT 10, 
	DEXTERITY INT NOT NULL DEFAULT 10,
	CONSTITUTION INT NOT NULL DEFAULT 10,
	INTELLIGENCE INT NOT NULL DEFAULT 10,
	WISDOM INT NOT NULL DEFAULT 10,
	CHARISMA INT NOT NULL DEFAULT 10,
	proficiency INT NOT NULL DEFAULT 0,
	hit_dice_type_id INT NOT NULL DEFAULT 2,
	hit_dice_number INT NOT NULL DEFAULT 1,
    challenge_rating NUMERIC (10, 2) NOT NULL DEFAULT 0,
    FOREIGN KEY (challenge_rating) REFERENCES challenge_rating (rating),
	FOREIGN KEY (size_id) REFERENCES size(id) ON UPDATE CASCADE,
	FOREIGN KEY (creature_type_id) REFERENCES creature_type(id) ON UPDATE CASCADE,
	FOREIGN KEY (alignment_id) REFERENCES alignment(id) ON UPDATE CASCADE,
	FOREIGN KEY (hit_dice_type_id) REFERENCES dice (id) ON UPDATE CASCADE
);

CREATE TABLE skill_proficiency( 
    creature_id INT,
    skill_id INT,
    expertise BOOL NOT NULL DEFAULT false,
    PRIMARY KEY (creature_id, skill_id),
    FOREIGN KEY (skill_id) REFERENCES skill(id) ON UPDATE CASCADE,
    FOREIGN KEY (creature_id) REFERENCES creature_template(id) ON DELETE CASCADE
);

CREATE TABLE damage_type (
    id INT PRIMARY KEY AUTO_INCREMENT,
    damage ENUM('ACID', 'COLD', 'FIRE', 'FORCE', 'LIGHTNING', 'NECROTIC', 'POISON', 'PSYCHIC', 'RADIANT', 'THUNDER', 'BLUDGEONING', 'PIERCING', 'SLASHING', 'MAGICAL PIERCING', 'MAGICAL BLUDGEONING', 'MAGICAL SLASHING') NOT NULL DEFAULT 'BLUDGEONING'
);

CREATE TABLE damage_relationship (
    id INT PRIMARY KEY AUTO_INCREMENT,
    relationship ENUM('VULNERABILITY', 'RESISTANCE', 'IMMUNITY') NOT NULL UNIQUE
);

CREATE TABLE damage_type_relationship (
	id INT PRIMARY KEY AUTO_INCREMENT,
	damage_id INT NOT NULL,
    damage_relationship_id INT NOT NULL,
    UNIQUE (damage_id, damage_relationship_id),
    FOREIGN KEY (damage_id) REFERENCES damage_type (id) ON UPDATE CASCADE,
    FOREIGN KEY (damage_relationship_id) REFERENCES damage_relationship (id) ON UPDATE CASCADE
);

CREATE TABLE creature_damage_relationship (
    creature_id INT,
    damage_type_relationship_id INT,
    PRIMARY KEY (creature_id, damage_type_relationship_id),  
    FOREIGN KEY (creature_id) REFERENCES creature_template (id),
    FOREIGN KEY (damage_type_relationship_id) REFERENCES damage_type_relationship (id) ON UPDATE CASCADE
);

CREATE TABLE conditions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    condition_name ENUM('BLINDED', 'CHARMED', 'DEAFENED', 'FRIGHTENED', 'GRAPPLED', 'INCAPACITATED', 'INVISIBLE', 'PARALYZED', 'PETRIFIED', 'POISONED', 'PRONE', 'RESTRAINED', 'STUNNED', 'UNCONSCIOUS', 'EXHAUSTION 1', 'EXHAUSTION 2', 'EXHAUSTION 3', 'EXHAUSTION 4', 'EXHAUSTION 5', 'EXHAUSTION 6') NOT NULL,
    condition_description TEXT
);

CREATE TABLE condition_relationship (
    id INT PRIMARY KEY AUTO_INCREMENT,
    condition_id INT,
    condition_relationship ENUM('ADVANTAGE', "DISADVANTAGE", 'IMMUNE') NOT NULL DEFAULT 'IMMUNE',
    UNIQUE (condition_id, condition_relationship),
    FOREIGN KEY (condition_id) REFERENCES conditions (id) ON DELETE CASCADE
);

CREATE TABLE creature_condition_relationship (
    creature_id INT,
    condition_relationship_id INT,
    PRIMARY KEY (creature_id, condition_relationship_id),
    FOREIGN KEY (creature_id) REFERENCES creature_template (id) ON DELETE CASCADE,
    FOREIGN KEY (condition_relationship_id) REFERENCES condition_relationship (id) ON DELETE CASCADE
);
    
CREATE TABLE languages (
    id INT PRIMARY KEY AUTO_INCREMENT,
    language_name VARCHAR(16) NOT NULL UNIQUE,
    is_exotic BOOL NOT NULL DEFAULT false
);

CREATE TABLE creature_language (
    creature_id INT,
    language_id INT,
    PRIMARY KEY (creature_id, language_id),
    FOREIGN KEY (creature_id) REFERENCES creature_template (id) ON DELETE CASCADE,
    FOREIGN KEY (language_id) REFERENCES languages (id) ON DELETE CASCADE
);

CREATE TABLE sense (
    id INT PRIMARY KEY AUTO_INCREMENT,
    sense ENUM('BLINDSIGHT', 'DARKVISION', 'TREMORSENSE', 'TRUESIGHT') NOT NULL,
    distance INT NOT NULL DEFAULT 30,
    CHECK (distance > 0),
    UNIQUE (sense, distance)
);

CREATE TABLE creature_sense (
    creature_id INT,
    sense_id INT,
    PRIMARY KEY (creature_id, sense_id),
    FOREIGN KEY (creature_id) REFERENCES creature_template (id) ON DELETE CASCADE,
    FOREIGN KEY (sense_id) REFERENCES sense (id) ON UPDATE CASCADE
);

CREATE TABLE movement (
    id INT PRIMARY KEY AUTO_INCREMENT,
	movement ENUM('WALK', 'BURROW', 'CLIMB', 'FLY', 'SWIM') NOT NULL DEFAULT 'WALK',
    distance INT NOT NULL DEFAULT 30,
    UNIQUE (distance, movement)
);

CREATE TABLE creature_movement (
    creature_id INT,
    movement_id INT,
    PRIMARY KEY (creature_id, movement_id),
    FOREIGN KEY (creature_id) REFERENCES creature_template (id) ON DELETE CASCADE,
    FOREIGN KEY (movement_id) REFERENCES movement (id) ON UPDATE CASCADE
);

CREATE TABLE item (
    id INT PRIMARY KEY AUTO_INCREMENT,
    item_name VARCHAR(64) NOT NULL UNIQUE,
    item_description TEXT,
    WEIGHT NUMERIC(10 , 2) NOT NULL DEFAULT 0,
    cost_id INT NOT NULL DEFAULT 0,
    cost_amount INT CHECK (cost_amount >= 0),
    FOREIGN KEY (cost_id) REFERENCES item (id)
);

CREATE TABLE creature_instance(
    id INT PRIMARY KEY AUTO_INCREMENT,
    creature_template_id INT NOT NULL,
    current_hp INT NOT NULL,
    initiative INT NOT NULL DEFAULT 1,
    FOREIGN KEY (creature_template_id) REFERENCES creature_template(id) 
);


CREATE TABLE armor(
    id INT PRIMARY KEY AUTO_INCREMENT,
    item_id INT NOT NULL UNIQUE,
    armor_type ENUM ('CLOTHING', 'LIGHT', 'MEDIUM', 'HEAVY', 'SHIELD') NOT NULL,
    strength_minimum INT NOT NULL DEFAULT 0,
    stealth_disadvantage BOOL NOT NULL DEFAULT false,
    base_armor_class INT NOT NULL DEFAULT 10,
    maximum_dex_modifier INT DEFAULT NULL,
    FOREIGN KEY (item_id) REFERENCES item(id) ON DELETE CASCADE
);

CREATE TABLE weapon(
    id INT PRIMARY KEY AUTO_INCREMENT,
    item_id INT NOT NULL UNIQUE,
    damage_type_id INT NOT NULL, 
    damage_dice_id INT NOT NULL DEFAULT 0,
    damage_dice_amount INT NOT NULL DEFAULT 1,
    is_martial BOOl NOT NULL DEFAULT false,
    min_range INT NOT NULL DEFAULT 5,
    max_range INT NOT NULL DEFAULT 5,
    FOREIGN KEY (damage_type_id) REFERENCES damage_type(id) ON UPDATE CASCADE,
    FOREIGN KEY (damage_dice_id) REFERENCES dice(id) ON UPDATE CASCADE, 
    FOREIGN KEY (item_id) REFERENCES item(id) ON DELETE CASCADE
);

CREATE TABLE weapon_properties( 
    id INT PRIMARY KEY AUTO_INCREMENT,
    property_name VARCHAR(32) NOT NULL UNIQUE,
    property_description TEXT NOT NULL
);

CREATE TABLE time_units(
    id INT PRIMARY KEY AUTO_INCREMENT,
    unit ENUM( "INSTANTANEOUS", "ACTION", "BONUS ACTION", "REACTION", "MINUTE", "HOUR", "DAY") NOT NULL UNIQUE
);

CREATE TABLE spell(
    id INT PRIMARY KEY AUTO_INCREMENT,
    spell_name VARCHAR(128) NOT NULL UNIQUE,
    spell_school ENUM ("ABJURATION", "CONJURATION", "DIVINATION", "ENCHANTMENT", "EVOCATION", "ILLUSION", "NECROMANCY", "TRANSMUTATION") NOT NULL,
    spell_level INT NOT NULL DEFAULT 0, 
    is_ritual BOOL NOT NULL DEFAULT false,
    is_concentration BOOL NOT NULL DEFAULT false,
    casting_time_unit_id INT NOT NULL DEFAULT 1,
    casting_unit_amount INT NOT NULL DEFAULT 1, 
    duration_time_unit_id INT NOT NULL DEFAULT 0,
    duration_unit_amount INT NOT NULL DEFAULT 1,
    casting_range INT NOT NULL DEFAULT 5,
    number_of_targets INT NOT NULL DEFAULT 1,
    damage_dice_type_id INT NOT NULL DEFAULT 0,
    damage_dice_amount INT NOT NULL DEFAULT 0,
    uses_damage_modifier BOOL NOT NULL DEFAULT false,
    is_attack_roll BOOL NOT NULL,
    saving_throw_id INT DEFAULT NULL,
    spell_description TEXT NOT NULL,
    FOREIGN KEY (casting_time_unit_id) REFERENCES time_units (id) ON UPDATE CASCADE,
    FOREIGN KEY (duration_time_unit_id) REFERENCES time_units (id) ON UPDATE CASCADE,
    FOREIGN KEY (damage_dice_type_id) REFERENCES dice (id) ON UPDATE CASCADE,
    FOREIGN KEY (saving_throw_id) REFERENCES ability_score (id) ON UPDATE CASCADE
);


CREATE TABLE components(
    id INT PRIMARY KEY AUTO_INCREMENT,
    verbal BOOL NOT NULL DEFAULT false,
    somatic BOOL NOT NULL DEFAULT false,
    material BOOL NOT NULL DEFAULT false,
    material_item_id INT DEFAULT NULL,
    FOREIGN KEY (material_item_id) REFERENCES item(id) ON UPDATE CASCADE
);

CREATE TABLE spell_components(
    spell_id INT,
    components_id INT,
    PRIMARY KEY (spell_id, components_id),
    FOREIGN KEY (spell_id) REFERENCES spell(id) ON DELETE CASCADE,
    FOREIGN KEY (components_id) REFERENCES components(id) ON UPDATE CASCADE
);

CREATE TABLE aoe_shape(
    id INT PRIMARY KEY AUTO_INCREMENT,
    shape ENUM("CONE", "CUBE", "CYLINDER", "LINE", "SPHERE") NOT NULL,
    shape_size INT NOT NULL DEFAULT 5
);

CREATE TABLE spell_aoe_shape(
    spell_id INT,
    aoe_id INT,
    PRIMARY KEY (spell_id, aoe_id),
    FOREIGN KEY (spell_id) REFERENCES spell(id) ON DELETE CASCADE,
    FOREIGN KEY (aoe_id) REFERENCES aoe_shape(id) ON UPDATE CASCADE 
);

CREATE TABLE class(
    id INT PRIMARY KEY AUTO_INCREMENT,
    class_name VARCHAR(32) NOT NULL UNIQUE,
    class_description TEXT NOT NULL,
    hit_dice_id INT NOT NULL DEFAULT 1,
    primary_ability_id INT NOT NULL DEFAULT 0,
    FOREIGN KEY (hit_dice_id) REFERENCES dice(id),
    FOREIGN KEY (primary_ability_id) REFERENCES ability_score(id)
);

CREATE TABLE spell_class(
    class_id INT, 
    spell_id INT,
    PRIMARY KEY (class_id, spell_id),
    FOREIGN KEY (class_id) REFERENCES class(id) ON DELETE CASCADE,
    FOREIGN KEY (spell_id) REFERENCES spell(id) ON DELETE CASCADE
);

CREATE TABLE race(
    id INT PRIMARY KEY AUTO_INCREMENT,
    race_name VARCHAR(32) NOT NULL UNIQUE,
    flavor TEXT NOT NULL,
    culture TEXT NOT NULL,
    maturity_age INT NOT NULL DEFAULT 18,
    maximum_age INT NOT NULL DEFAULT 100,
    typical_alignment_id INT NOT NULL,
    size_id INT NOT NULL,  
    creature_type_id INT NOT NULL,
    height_min INT NOT NULL DEFAULT 150,
    height_max INT NOT NULL DEFAULT 200,
    weight_min INT NOT NULL DEFAULT 80,
    weight_max INT NOT NULL DEFAULT 300,
    FOREIGN KEY (creature_type_id) REFERENCES creature_type(id) ON UPDATE CASCADE,
    FOREIGN KEY (typical_alignment_id) REFERENCES alignment(id) ON UPDATE CASCADE,
    FOREIGN KEY (size_id) REFERENCES size(id) ON UPDATE CASCADE
);

CREATE TABLE weapon_property_match (
    weapon_id INT NOT NULL,
    weapon_property_id INT NOT NULL,
    PRIMARY KEY (weapon_id, weapon_property_id),
    FOREIGN KEY (weapon_id) REFERENCES weapon (id) ON DELETE CASCADE,
    FOREIGN KEY (weapon_property_id) REFERENCES weapon_properties (id) ON DELETE CASCADE
);

CREATE TABLE features ( 
    id INT PRIMARY KEY AUTO_INCREMENT,
    feature_name VARCHAR(32),
    feature_description TEXT NOT NULL
);

CREATE TABLE race_feature (
    race_id INT,
    feature_id INT,
    PRIMARY KEY (race_id, feature_id),
    FOREIGN KEY (race_id) REFERENCES race (id) ON DELETE CASCADE,
    FOREIGN KEY (feature_id) REFERENCES features (id) ON DELETE CASCADE
);

CREATE TABLE race_item_prof (
    race_id INT,
    item_id INT,
	PRIMARY KEY (race_id, item_id),
    FOREIGN KEY (race_id) REFERENCES race (id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES item (id) ON DELETE CASCADE
);

CREATE TABLE racial_spells (
    race_id INT,
    spell_id INT,
    at_level INT,
    PRIMARY KEY (race_id, spell_id, at_level),
    FOREIGN KEY (race_id) REFERENCES race (id) ON DELETE CASCADE,
    FOREIGN KEY (spell_id) REFERENCES spell (id) ON DELETE CASCADE
);

CREATE TABLE race_skill_prof (
    race_id INT,
    skill_id INT,
    PRIMARY KEY (race_id, skill_id),
    FOREIGN KEY (race_id) REFERENCES race (id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES skill (id) ON DELETE CASCADE
);


CREATE TABLE race_damage_relationship (
    race_id INT,
    damage_type_relationship_id INT,
    PRIMARY KEY (race_id, damage_type_relationship_id),
    FOREIGN KEY (race_id) REFERENCES race (id) ON DELETE CASCADE,
    FOREIGN KEY (damage_type_relationship_id) REFERENCES damage_type_relationship (id) ON DELETE CASCADE
);

CREATE TABLE race_movement (
    race_id INT,
    movement_id INT,
    PRIMARY KEY (race_id, movement_id),
    FOREIGN KEY (race_id) REFERENCES race (id) ON DELETE CASCADE,
    FOREIGN KEY (movement_id) REFERENCES movement (id) ON DELETE CASCADE
);

CREATE TABLE race_sense (
    race_id INT,
    sense_id INT,
    PRIMARY KEY (race_id, sense_id),
    FOREIGN KEY (race_id) REFERENCES race (id) ON DELETE CASCADE,
    FOREIGN KEY (sense_id) REFERENCES sense (id) ON DELETE CASCADE
);

CREATE TABLE race_asi (
    race_id INT,
    ability_id INT,
    increase INT NOT NULL,
    PRIMARY KEY (race_id, ability_id),
    FOREIGN KEY (race_id) REFERENCES race (id) ON DELETE CASCADE,
    FOREIGN KEY (ability_id) REFERENCES ability_score (id) ON UPDATE CASCADE
);

CREATE TABLE common_names (
    id INT PRIMARY KEY AUTO_INCREMENT,
    common_name VARCHAR(32) NOT NULL,
    is_family_name BOOL NOT NULL DEFAULT false,
    gender ENUM('NEUTRAL', 'MASCULINE', 'FEMININE') NOT NULL DEFAULT 'NEUTRAL'
);

CREATE TABLE race_names (
    race_id INT,
    common_name_id INT,
    PRIMARY KEY (race_id, common_name_id),
    FOREIGN KEY (race_id) REFERENCES race (id) ON DELETE CASCADE,
    FOREIGN KEY (common_name_id) REFERENCES common_names (id) ON DELETE CASCADE
);

CREATE TABLE race_language (
    race_id INT,
    language_id INT,
    PRIMARY KEY (race_id, language_id),
    FOREIGN KEY (race_id) REFERENCES race (id) ON DELETE CASCADE,
    FOREIGN KEY (language_id) REFERENCES languages (id) ON DELETE CASCADE
);

CREATE TABLE race_condition_relationship (
    race_id INT,
    condition_relationship_id INT,
    PRIMARY KEY (race_id, condition_relationship_id),
    FOREIGN KEY (race_id) REFERENCES race (id) ON DELETE CASCADE,
    FOREIGN KEY (condition_relationship_id) REFERENCES condition_relationship (id) ON UPDATE CASCADE
);

CREATE TABLE personality (
    id INT PRIMARY KEY AUTO_INCREMENT,
    creature_instance_id INT NOT NULL,
    personality_traits TEXT NOT NULL,
    ideals TEXT NOT NULL,
    bonds TEXT NOT NULL,
    flaws TEXT NOT NULL,
    FOREIGN KEY (creature_instance_id) REFERENCES creature_instance (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE player (
    id INT PRIMARY KEY AUTO_INCREMENT,
    player_name VARCHAR (32),
    is_DM BOOL NOT NULL DEFAULT false
);


CREATE TABLE background(
    id INT PRIMARY KEY AUTO_INCREMENT,
    background_name VARCHAR (16) NOT NULL,
    background_description TEXT NOT NULL
);

CREATE TABLE background_skills(
    background_id INT,
    skill_id INT,
    PRIMARY KEY (background_id, skill_id),
    FOREIGN KEY (background_id) REFERENCES background (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES skill (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE background_item_prof(
    background_id INT,
    item_id INT,
    PRIMARY KEY (background_id, item_id),
    FOREIGN KEY (background_id) REFERENCES background (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES item (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE background_languages(
    background_id INT,
    language_id INT,
    PRIMARY KEY (background_id, language_id),
    FOREIGN KEY (background_id) REFERENCES background (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (language_id) REFERENCES languages (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE background_equipment (
    background_id INT,
    item_id INT,
    amount INT NOT NULL DEFAULT 1,
    CHECK (amount > 0),
    PRIMARY KEY (background_id, item_id),
    FOREIGN KEY (item_id) REFERENCES item (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (background_id) REFERENCES background (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE light_source (
    item_id INT PRIMARY KEY,
    aoe_id INT NOT NULL, 
    duration_in_minutes INT NOT NULL DEFAULT 1,
    FOREIGN KEY (item_id) REFERENCES item (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (aoe_id) REFERENCES aoe_shape (id) ON UPDATE CASCADE
);

CREATE TABLE consumable(
    item_id INT NOT NULL PRIMARY KEY,
    dice_id INT DEFAULT NULL,
    dice_amount INT DEFAULT NULL,
    is_healing BOOl NOT NULL DEFAULT false,
    saving_throw_ability_id INT DEFAULT NULL,
    saving_throw_DC INT DEFAULT NULL,
    condition_id INT DEFAULT NULL,
    feature_id INT DEFAULT NULL,
    FOREIGN KEY (item_id) REFERENCES item(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (dice_id) REFERENCES dice(id) ON UPDATE CASCADE,
    FOREIGN KEY (saving_throw_ability_id) REFERENCES ability_score(id) ON UPDATE CASCADE,
    FOREIGN KEY (condition_id) REFERENCES conditions(id) ON UPDATE CASCADE,
    FOREIGN KEY (feature_id) REFERENCES features(id) ON UPDATE CASCADE
);

CREATE TABLE creature_condition(
    creature_id INT,
    condition_id INT,
    PRIMARY KEY (creature_id, condition_id),
    FOREIGN KEY (creature_id) REFERENCES creature_instance(id) ON DELETE CASCADE,
    FOREIGN KEY (condition_id) REFERENCES conditions(id) ON DELETE CASCADE
);

CREATE TABLE creature_instance_spell_slots(
    creature_instance_id INT,
    slot_level INT,
    amount INT NOT NULL DEFAULT 0,
    PRIMARY KEY (creature_instance_id, slot_level),
    FOREIGN KEY (creature_instance_id) REFERENCES creature_instance (id)
);

CREATE TABLE creature_template_spells_known(
    creature_template_id INT,
    spell_id INT,
    PRIMARY KEY (creature_template_id, spell_id),
    FOREIGN KEY (spell_id) REFERENCES spell(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (creature_template_id) REFERENCES creature_template(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE creature_instance_spells_known(
    creature_instance_id INT,
    spell_id INT,
    PRIMARY KEY (creature_instance_id, spell_id),
    FOREIGN KEY (creature_instance_id) REFERENCES creature_instance(id) ON UPDATE CASCADE ON DELETE CASCADE, 
    FOREIGN KEY (spell_id) REFERENCES spell(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE creature_instance_inventory(
    creature_instance_id INT,
    item_id INT,
    amount INT NOT NULL DEFAULT 1,
    CHECK (amount > 0),
    PRIMARY KEY (creature_instance_id, item_id),
    FOREIGN KEY (creature_instance_id) REFERENCES creature_instance(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES item(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE game_instance(
    id INT PRIMARY KEY AUTO_INCREMENT,
    game_name VARCHAR(32), # isto ko note i playername NOT NULL DEFAULT (CONCAT ('GAME: ', id)),
    game_owner_id INT NOT NULL,
    start_date DATETIME, # dodati timestamp after insert isto NOT NULL DEFAULT (CURRENT_TIMESTAMP),
    FOREIGN KEY (game_owner_id) REFERENCES player(id) ON UPDATE CASCADE
);

CREATE TABLE game_players(
    game_id INT,
    player_id INT NOT NULL,
    PRIMARY KEY(game_id,player_id),
    FOREIGN KEY (player_id) REFERENCES player(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (game_id) REFERENCES game_instance(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE map(
    id INT PRIMARY KEY AUTO_INCREMENT,
    aoe_id INT NOT NULL,
    game_instance_id INT NOT NULL,
    FOREIGN KEY (game_instance_id) REFERENCES game_instance(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (aoe_id) REFERENCES aoe_shape(id) ON UPDATE CASCADE
);

CREATE TABLE map_creatures(
    creature_instance_id INT,
    map_id INT,
    coord_x INT NOT NULL DEFAULT 0,
    coord_y INT NOT NULL DEFAULT 0,
    coord_z INT NOT NULL DEFAULT 0,
    PRIMARY KEY (creature_instance_id, map_id),
    FOREIGN KEY (creature_instance_id) REFERENCES creature_instance(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (map_id) REFERENCES map(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE experience_for_level(
    which_level INT,
    experience_needed INT,
    PRIMARY KEY (which_level, experience_needed)
);

CREATE TABLE class_saving_prof(
    class_id INT,
    saving_prof_id INT,
    PRIMARY KEY (class_id, saving_prof_id),
    FOREIGN KEY (class_id) REFERENCES class (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (saving_prof_id) REFERENCES ability_score (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE player_character(
    id INT PRIMARY KEY AUTO_INCREMENT,
    player_id INT NOT NULL,
    creature_instance_id INT NOT NULL,
    race_id INT NOT NULL,
    background_id INT NOT NULL,
    class_id INT NOT NULL,
    class_level INT NOT NULL DEFAULT 1,
    experience INT NOT NULL DEFAULT 0,
    death_save_fail INT NOT NULL DEFAULT 0,
    death_save_success INT NOT NULL DEFAULT 0,
    FOREIGN KEY (player_id) REFERENCES player(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (creature_instance_id) REFERENCES creature_instance(id) ON UPDATE CASCADE,
    FOREIGN KEY (race_id) REFERENCES race(id) ON UPDATE CASCADE,
    FOREIGN KEY (background_id) REFERENCES background(id) ON UPDATE CASCADE,
    FOREIGN KEY (class_id) REFERENCES class(id) ON UPDATE CASCADE 
);

CREATE TABLE notes(
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(64), # isto ko i player name NOT NULL DEFAULT (CONCAT('Note: ', id)),
    note TEXT NOT NULL,
    note_owner_id INT NOT NULL,
    FOREIGN KEY (note_owner_id) REFERENCES player_character (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE object_template (
    id INT PRIMARY KEY AUTO_INCREMENT,
    object_name VARCHAR(32) NOT NULL UNIQUE,
    object_description TEXT,
    size_id INT NOT NULL,
    health_points INT NOT NULL DEFAULT 1,
    FOREIGN KEY (size_id) REFERENCES size (id) ON UPDATE CASCADE
);

CREATE TABLE object_damage_relationship (
    object_template_id INT,
    damage_type_relationship_id INT,
    PRIMARY KEY (object_template_id, damage_type_relationship_id),
    FOREIGN KEY (object_template_id) REFERENCES object_template (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (damage_type_relationship_id) REFERENCES damage_type_relationship (id) ON UPDATE CASCADE
);

CREATE TABLE object_instance (
    id INT PRIMARY KEY AUTO_INCREMENT,
    object_template_id INT NOT NULL,
    map_id INT NOT NULL,
    current_health_points INT NOT NULL DEFAULT 1,
    coord_x INT NOT NULL DEFAULT 0,
    coord_y INT NOT NULL DEFAULT 0,
    coord_z INT NOT NULL DEFAULT 0,
    FOREIGN KEY (object_template_id) REFERENCES object_template (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (map_id) REFERENCES map (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE class_proficiency (
    class_id INT,
    item_id INT,
    PRIMARY KEY (class_id, item_id),
    FOREIGN KEY (class_id) REFERENCES class (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES item (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE class_levels (
    id INT PRIMARY KEY AUTO_INCREMENT,
    class_level INT NOT NULL,
    class_id INT NOT NULL,
    proficiency_bonus INT NOT NULL DEFAULT 2,
    learn_cantrip_amount INT NOT NULL DEFAULT 0,
    learn_spell_amount INT NOT NULL DEFAULT 0,
    FOREIGN KEY (class_id) REFERENCES class (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE class_level_feature (
    class_level_id INT,
    feature_id INT,
    PRIMARY KEY (class_level_id, feature_id),
    FOREIGN KEY (class_level_id) REFERENCES class_levels (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (feature_id) REFERENCES features (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE class_level_spellslots (
    class_level_id INT NOT NULL,
    slot_level INT NOT NULL DEFAULT 0,
    slot_amount INT NOT NULL DEFAULT 0,
    FOREIGN KEY (class_level_id) REFERENCES class_levels (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE throwable (
    item_id INT PRIMARY KEY,
    range_min INT,
    range_max INT,
    aoe_id INT,
    saving_throw_ability_id INT,
    saving_throw_DC INT,
    damage_dice_id INT,
    damage_dice_amount INT,
    damage_type_id INT,
    FOREIGN KEY (item_id) REFERENCES item (id),
    FOREIGN KEY (saving_throw_ability_id) REFERENCES ability_score (id),
    FOREIGN KEY (damage_dice_id) REFERENCES dice (id),
    FOREIGN KEY (damage_type_id) REFERENCES damage_type (id),
    FOREIGN KEY (aoe_id) REFERENCES aoe_shape (id)
);