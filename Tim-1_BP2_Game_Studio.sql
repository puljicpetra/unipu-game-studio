DROP DATABASE IF EXISTS game_studio;
CREATE DATABASE game_studio;
USE game_studio;

CREATE TABLE skill(
id INT PRIMARY KEY,
skill_name VARCHAR(30) NOT NULL, #Kombinacija skill + ability score mora biti unique jer mozemo staviti saving throw ko skill!
ability_score_id INT NOT NULL
);

CREATE TABLE ability_score( #kako ne bi smo morali pisati za literally svaki creature scores, mozemo imati sve varijacije od 0 do 30 jer imamo 180 kombinacija + n za sve creatures di je n broj creaturea a inace bi imali 6*n
id INT PRIMARY KEY,
ability_name ENUM("STRENGTH", "DEXTERITY", "CONSTITUTION", "INTELLIGENCE", "WISDOM", "CHARISMA")
);

CREATE TABLE dice(
id INT PRIMARY KEY,
dice ENUM ("d4", "d6", "d8", "d10", "d12", "d20") -- ???? primary keay si vamo bio stavio
);

CREATE TABLE size(
id INT PRIMARY KEY,
size ENUM ("TINY", "SMALL", "MEDIUM", "LARGE", "HUGE", "GARGANTUAN"),
space INT NOT NULL UNIQUE
);

CREATE TABLE alignment(
id INT PRIMARY KEY,
lawfulness ENUM ("LAWFUL", "NEUTRAL", "CHAOTIC"),
morality ENUM ("GOOD", "NEUTRAL", "EVIL")
);

CREATE TABLE creature_type(
id INT PRIMARY KEY,
creature_type ENUM ("ABERRATION", "BEAST", "CELESTIAL", "CONSTRUCT", "DRAGON", "ELEMENTAL", "FEY", "FIEND", "GIANT", "HUMANOID", "MONSTROSITY", "OOZE", "PLANT", "UNDEAD") -- ovdje si isto stavio mprimary key
);

CREATE TABLE creature_template(
id INT PRIMARY KEY,
creature_name VARCHAR(64),
size_id INT,
creature_type_id INT,
alignment_id INT,
STRENGTH INT, 
DEXTERITY INT,
CONSTITUTION INT,
INTELLIGENCE INT,
WISDOM INT,
CHARISMA INT,
proficiency INT,
#current_hp INT, --- ?????
hit_dice_type INT,
hit_dice_number INT,
FOREIGN KEY (size_id) REFERENCES size(id),
FOREIGN KEY (alignment_id) REFERENCES alignment(id),
FOREIGN KEY (creature_type_id) REFERENCES creature_type(id)
);

CREATE TABLE skill_proficiency( 
creature_id INT NOT NULL,
skill_id INT NOT NULL,
expertiese BOOL,
PRIMARY KEY (creature_id, skill_id),
FOREIGN KEY (skill_id) REFERENCES skill(id),
FOREIGN KEY (creature_id) REFERENCES creature_template(id) 
);

CREATE TABLE damage_type(
id INT PRIMARY KEY,
damage ENUM ("ACID", "COLD", "FIRE", "FORCE", "LIGHTNING", "NECROTIC", "POISON", "PSYCHIC", "RADIANT", "THUNDER", "BLUDGEONING", "PIERCING", "SLASHING", "MAGICAL PIERCING", "MAGICAL BLUDGEONING")
);

CREATE TABLE damage_relationship(
id INT PRIMARY KEY,
relationship ENUM ("VULNERABILITY", "RESISTANCE", "IMMUNITY")
);

CREATE TABLE creature_damage_relationship(
creature_id INT NOT NULL,
damage_type_id INT NOT NULL,
damage_relationship_id INT NOT NULL,
FOREIGN KEY (creature_id) REFERENCES creature_template(id),
FOREIGN KEY (damage_type_id) REFERENCES damage_type(id)
-- FOREIGN KEY (damage_relationship_id) REFERENCES damage_relationship(id) FALI PRIMARY KEY
);

CREATE TABLE conditions(
id INT PRIMARY KEY,
condition_name ENUM("BLINDED", "CHARMED", "DEAFENED", "FRIGHTENED", "GRAPPLED", "INCAPACITATED", "INVISIBLE", "PARALYZED", "PETRIFIED", "POISONED", "PRONE", "RESTRAINED", "STUNNED", "UNCONSCIOUS", "EXHAUSTION 1", "EXHAUSTION 2", "EXHAUSTION 3", "EXHAUSTION 4", "EXHAUSTION 5", "EXHAUSTION 6"),
condition_description TEXT
);

CREATE TABLE creature_condition(
creature_id INT,
condition_id INT,
FOREIGN KEY (creature_id) REFERENCES creature_template(id),
FOREIGN KEY (condition_id) REFERENCES conditions(id)
);

CREATE TABLE condition_relationship(
condition_id INT,
condition_relationship ENUM ("ADVANTAGE", "IMMUNE"),
FOREIGN KEY (condition_id) REFERENCES conditions(id)
);

CREATE TABLE creature_condition_relationship(
creature_id INT,
condition_relationship_id INT,
FOREIGN KEY (creature_id) REFERENCES creature_template(id)
-- DOPUNITIII!!!!!!!
);

CREATE TABLE languages(
id INT PRIMARY KEY,
language_name VARCHAR(16),
is_exotic BOOL 
);

CREATE TABLE creature_language(
creature_id INT,
language_id INT,
FOREIGN KEY (creature_id) REFERENCES creature_template(id),
FOREIGN KEY (language_id) REFERENCES languages(id)
);

CREATE TABLE challenge_rating(
rating NUMERIC (10, 2) PRIMARY KEY,
experience_points INT
);
-- NEMA SMISLAAA!!!!!!!!!!!!!!!!!!-----------

CREATE TABLE creature_challenge(
creature_id INT,
rating NUMERIC (10, 2),
FOREIGN KEY (creature_id) REFERENCES creature_template(id)
);

CREATE TABLE sense(
id INT PRIMARY KEY,
sense ENUM("BLINDSIGHT", "DARKVISION", "TREMORSENSE", "TRUESIGHT"),
distance INT
);

CREATE TABLE creature_sense(
creature_id INT,
sense_id INT,
FOREIGN KEY (creature_id) REFERENCES creature_template(id),
FOREIGN KEY (sense_id) REFERENCES sense(id)
);

CREATE TABLE movement(
id INT PRIMARY KEY,
distance INT,
movement ENUM ("WALK", "BURROW", "CLIMB", "FLY", "SWIM")
);

CREATE TABLE creature_movement(
creature_id INT,
movement_id INT,
FOREIGN KEY (creature_id) REFERENCES creature_template(id),
FOREIGN KEY (movement_id) REFERENCES movement(id)
);

CREATE TABLE item(
id INT PRIMARY KEY,
item_name VARCHAR(64),
item_description TEXT,
WEIGHT NUMERIC(10, 2),
cost_id INT, -- ??????????
cost_amount INT 
);

CREATE TABLE creature_item(
creature_id INT,
item_id INT,
FOREIGN KEY (creature_id) REFERENCES creature_template(id),
FOREIGN KEY (item_id) REFERENCES item(id)
);

CREATE TABLE armor(
id INT PRIMARY KEY,
item_id INT,
armor_type ENUM ("CLOTHING", "LIGHT", "MEDIUM", "HEAVY"),
strength_minimum INT,
stealth_disadvantage BOOL,
base_armor_class INT,
maximum_dex_modifier INT,
FOREIGN KEY (item_id) REFERENCES item(id)
);

CREATE TABLE weapon(
id INT PRIMARY KEY,
item_id INT,
damage_type_id INT, 
damage_dice_id INT,
damage_dice_amount INT,
is_martial BOOl,
min_range INT,
max_range INT,
FOREIGN KEY (damage_type_id) REFERENCES damage_type(id),
FOREIGN KEY (damage_dice_id) REFERENCES dice(id), -- ????????
FOREIGN KEY (item_id) REFERENCES item(id)
);

CREATE TABLE weapon_properties( # maybe just hardcode all the properties how to use instead of description so gameplay can be automated?
id INT PRIMARY KEY,
property_name VARCHAR(32),
property_description TEXT
);

CREATE TABLE weapon_property_match(
weapon_id INT,
weapon_property_id INT,
FOREIGN KEY (weapon_id) REFERENCES weapon(id),
FOREIGN KEY (weapon_property_id) REFERENCES weapon_properties(id)
);

/*
CREATE TABLE creature_template(
id INT PRIMARY KEY,
creature_name VARCHAR(64),
size_id INT,
creature_type_id INT,
alignment_id INT,
STRENGTH INT, 
DEXTERITY INT,
CONSTITUTION INT,
INTELLIGENCE INT,
WISDOM INT,
CHARISMA INT,
proficiency INT,
#current_hp INT, --- ?????
hit_dice_type INT,
hit_dice_number INT,
FOREIGN KEY (size_id) REFERENCES size(id),
FOREIGN KEY (alignment_id) REFERENCES alignment(id),
FOREIGN KEY (creature_type_id) REFERENCES creature_type(id)
);
*/
CREATE TABLE time_units(
id INT,
unit ENUM("ACTION", "BONUS ACTION", "REACTION", "MINUTE", "HOUR", "DAY", "INSTANTANEOUS")
);

CREATE TABLE spell(
id INT PRIMARY KEY,
spell_name VARCHAR(128),
spell_school ENUM ("ABJURATION", "CONJURATION", "DIVINATION", "ENCHANTMENT", "EVOCATION", "ILLUSION", "NECROMANCY", "TRANSMUTATION"),
spell_level INT, 
is_ritual BOOL,
is_concentration BOOL,
casting_unit INT,
casting_unit_amount INT, -- ?????????????
duration_unit INT,
duration_unit_amount INT,
save_type INT, 
casting_range INT,
number_of_targets INT,
damage_dice_type INT,
damage_dice_amount INT,
uses_damage_modifier BOOL,
is_attack_roll BOOL,
saving_throw_id INT,
spell_description TEXT
);

CREATE TABLE components(
id INT PRIMARY KEY,
verbal BOOL,
somatic BOOL,
material BOOL,
material_item_id INT,
FOREIGN KEY (material_item_id) REFERENCES creature_type(id)-- ?????
);

CREATE TABLE spell_components(
spell_id INT,
components_id INT,
FOREIGN KEY (spell_id) REFERENCES spell(id),
FOREIGN KEY (components_id) REFERENCES components(id)
);

CREATE TABLE aoe_shape(
id INT PRIMARY KEY,
shape ENUM("CONE", "CUBE", "CYLINDER", "LINE", "SPHERE"),
size INT
);

CREATE TABLE spell_aoe_shape(
spell_id INT,
aoe_id INT,
FOREIGN KEY (spell_id) REFERENCES spell(id),
FOREIGN KEY (aoe_id) REFERENCES aoe_shape(id)
);
/*
CREATE TABLE spell(
id INT,
spell_name VARCHAR(128),
spell_school ENUM ("ABJURATION", "CONJURATION", "DIVINATION", "ENCHANTMENT", "EVOCATION", "ILLUSION", "NECROMANCY", "TRANSMUTATION"),
spell_level INT, 
is_ritual BOOL,
is_concentration BOOL,
casting_unit INT,
casting_unit_amount INT, -- ?????????????
duration_unit INT,
duration_unit_amount INT,
save_type INT, 
casting_range INT,
number_of_targets INT,
damage_dice_type INT,
damage_dice_amount INT,
uses_damage_modifier BOOL,
is_attack_roll BOOL,
saving_throw_id INT,
spell_description TEXT
);
*/
CREATE TABLE spell_class(
class_id INT, 
spell_id INT,
FOREIGN KEY (spell_id) REFERENCES spell(id)
);

CREATE TABLE race(
id INT PRIMARY KEY,
flavor TEXT,
culture TEXT,
maturity_age INT,
maximum_age INT,
typical_alignment_id INT,
size_id INT, 
creature_type_id INT,
height_min INT,
height_max INT,
weight_min INT,
weight_max INT,
FOREIGN KEY (creature_type_id) REFERENCES creature_type(id),
FOREIGN KEY (size_id) REFERENCES size(id)
);

CREATE TABLE features( # OOF needs lots of work for many things to fit such as trigger uses type etc.
id INT PRIMARY KEY,
feature_description TEXT
);

CREATE TABLe race_feature(
race_id INT,
feature_id INT,
FOREIGN KEY (race_id) REFERENCES race(id),
FOREIGN KEY (feature_id) REFERENCES features(id)
);

CREATE TABLE race_item_prof(
race_id INT,
item_id INT,
FOREIGN KEY (race_id) REFERENCES race(id),
FOREIGN KEY (item_id) REFERENCES item(id)
);

CREATE TABLE racial_spells(
race_id INT,
spell_id INT,
at_level INT,
FOREIGN KEY (race_id) REFERENCES race(id),
FOREIGN KEY (spell_id) REFERENCES spell(id)
);

CREATE TABLE race_skill_prof(
race_id INT,
skill_id INT,
FOREIGN KEY (race_id) REFERENCES race(id),
FOREIGN KEY (skill_id) REFERENCES skill(id)
);

CREATE TABLE race_damage_relationship(
race_id INT,
damage_relationship_id INT,
FOREIGN KEY (race_id) REFERENCES race(id),
FOREIGN KEY (damage_relationship_id) REFERENCES damage_relationship(id)
);

CREATE TABLE race_movement(
race_id INT,
movement_id INT,
FOREIGN KEY (race_id) REFERENCES race(id),
FOREIGN KEY (movement_id) REFERENCES movement(id)
);

CREATE TABLE race_sense(
race_id INT,
sense_id INT,
FOREIGN KEY (race_id) REFERENCES race(id),
FOREIGN KEY (sense_id) REFERENCES sense(id)
);

CREATE TABLE race_asi(
race_id INT,
ability_id INT,
increase INT,
FOREIGN KEY (race_id) REFERENCES race(id)
-- FOREIGN KEY (ability_id) REFERENCES ability(id)
);

CREATE TABLE common_names(
id INT PRIMARY KEY,
common_name VARCHAR(32),
is_family_name BOOL,
gender ENUM ("NEUTRAL", "MASCULINE", "FEMINENE")
);

CREATE TABLE race_names(
id_race INT,
id_common_name INT,
FOREIGN KEY (id_race) REFERENCES race(id), -- zasto odjednom id_race
FOREIGN KEY (id_common_name) REFERENCES common_names(id)
);


CREATE TABLE race_language(
race_id INT,
language_id INT,
FOREIGN KEY (race_id) REFERENCES race(id),
FOREIGN KEY (language_id) REFERENCES languages(id)
);

CREATE TABLE race_condition_relationship(
race_id INT,
condition_relationship_id INT,
FOREIGN KEY (race_id) REFERENCES race(id)
-- FOREIGN KEY (condition_relationship_id) REFERENCES condition_relationship(id) -- ??????????
);

CREATE TABLE personality(
id INT PRIMARY KEY,
personality_traits TEXT,
ideals TEXT,
bonds TEXT,
flaws TEXT
);

CREATE TABLE player(
id INT PRIMARY KEY,
player_name INT,
character_id INT,
is_DM BOOL
-- FOREIGN KEY (character_id) REFERENCES characters(id) -- ????
);

CREATE TABLE notes(
id INT PRIMARY KEY,
title VARCHAR(64),
note TEXT,
note_owner_id INT
);

CREATE TABLE background(
id INT PRIMARY KEY,
skill_proficiency_1_id INT,
skill_proficiency_2_id INT,
item_proficiency_1_id INT,
item_proficiency_2_id INT,
language_1_id INT,
language_2_id INT
);

CREATE TABLE background_equipment(
background_id INT,
item_id INT,
FOREIGN KEY (item_id) REFERENCES item(id)
);

CREATE TABLE light_source(
item_id INT,
aoe_id INT, # oblik u kojem sija svjetlo
duration_in_minutes INT
);

CREATE TABLE throwable(
item_id INT,
range_min INT,
range_max INT,
aoe_id INT,
saving_throw_ability_id INT,
saving_throw_DC INT,
damage_dice_id INT,
damage_dice_amount INT,
damage_type_id INT 
);

CREATE TABLE consumable(
item_id INT,
dice_id INT,
dice_amount INT,
is_healing BOOl,
saving_throw_ability_id INT,
saving_throw_DC INT,
condition_id INT,
feature_id INT
);

CREATE TABLE creature_instance(
id INT PRIMARY KEY,
creature_template_id INT,
current_hp INT,
initiative INT
);

CREATE TABLE creature_instance_spell_slots(
creature_instance_id INT,
slot_level INT,
amount INT
);

CREATE TABLE creature_template_spells_known(
creature_instance_id INT,
spell_id INT
);

CREATE TABLE creature_instance_spells_known(
creature_instance_id INT,
spell_id INT
);

CREATE TABLE creature_instance_inventory(
creature_instance_id INT,
item_id INT,
amount INT
);

CREATE TABLE game_instance(
id INT PRIMARY KEY,
game_name VARCHAR(32),
game_owner_id INT,
start_date DATETIME
);

CREATE TABLE game_players(
game_id INT PRIMARY KEY,
player_id INT 
);

CREATE TABLE map(
id INT PRIMARY KEY,
aoe_id INT, # ovime se definiraju dimenzije
game_instance_id INT
);

CREATE TABLE map_creatures(
creature_instance_id INT,
map_id INT,
coord_x INT,
coord_y INT,
coord_z INT 
);

CREATE TABLE experience_for_level(
which_level INT,
experience_needed INT
);

CREATE TABLE player_character(
id INT PRIMARY KEY,
player_id INT,
creature_instance_id INT,
race_id INT,
background_id INT,
class_id INT,
class_levl INT,
experience INT,
death_save_fail INT,
death_save_success INT
);

CREATE TABLE object_template(
id INT PRIMARY KEY,
object_name VARCHAR(32),
object_description TEXT,
size_id INT,
health_points INT 
);

CREATE TABLE object_damage_relationship(
object_template_id INT,
damage_replationship_id INT 
);

CREATE TABLE object_instance(
id INT PRIMARY KEY,
object_template_id INT,
map_id INT,
current_health_points INT,
coord_x INT,
coord_y INT,
coord_z INT 
);

CREATE TABLE class(
id INT PRIMARY KEY,
class_name VARCHAR(32),
class_description TEXT,
hit_dice_id INT,
primary_ability_id INT,
saving_proficiency_id_1 INT,
saving_proficiency_id_2 INT
);

CREATE TABLE class_proficiency(
class_id INT,
item_id INT 
);

CREATE TABLE class_levels(
id INT PRIMARY KEY,
class_level INT,
class_id INT,
proficiency_bonus INT,
learn_cantrip_amount INT,
learn_spell_amount INT
);

CREATE TABLE class_level_feature(
class_level_id INT,
feature_id INT
);

CREATE TABLE class_level_spellslots(
class_level_id INT,
slot_level INT,
slot_amount INT
);

# features su ostali
# takodjer i guess actions??