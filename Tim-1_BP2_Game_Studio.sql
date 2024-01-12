DROP DATABASE IF EXISTS game_studio;
CREATE DATABASE game_studio;
USE game_studio;

CREATE TABLE skill(
id INT PRIMARY KEY,
skill_name VARCHAR(30) NOT NULL, #Kombinacija skill + ability score mora biti unique jer mozemo staviti saving throw ko skill!
ability_score_id INT NOT NULL
);

CREATE TABLE skill_proficiency( 
creature_id INT NOT NULL,
skill_id INT NOT NULL,
expertiese BOOL,
PRIMARY KEY (creature_id, skill_id)
);

CREATE TABLE ability_score( #kako ne bi smo morali pisati za literally svaki creature scores, mozemo imati sve varijacije od 0 do 30 jer imamo 180 kombinacija + n za sve creatures di je n broj creaturea a inace bi imali 6*n
id INT PRIMARY KEY,
ability_name ENUM("STRENGTH", "DEXTERITY", "CONSTITUTION", "INTELLIGENCE", "WISDOM", "CHARISMA")
);

CREATE TABLE dice(
id INT PRIMARY KEY,
dice ENUM ("d4", "d6", "d8", "d10", "d12", "d20") PRIMARY KEY
);

CREATE TABLE damage_type(
id INT PRIMARY KEY,
damage ENUM ("ACID", "COLD", "FIRE", "FORCE", "LIGHTNING", "NECROTIC", "POISON", "PSYCHIC", "RADIANT", "THUNDER", "BLUDGEONING", "PIERCING", "SLASHING", "MAGICAL BLUDGEONING", "MAGICAL PIERCING", "MAGICAL BLUDGEONING")
);

CREATE TABLE damage_relationship(
id INT PRIMARY KEY,
relationship ENUM ("VULNERABILITY", "RESISTANCE", "IMMUNITY")
);

CREATE TABLE creature_damage_relationship(
creature_id INT NOT NULL,
damage_type_id INT NOT NULL,
damage_relationship_id INT NOT NULL
);

CREATE TABLE alignment(
id INT PRIMARY KEY,
lawfulness ENUM ("LAWFUL", "NEUTRAL", "CHAOTIC"),
morality ENUM ("GOOD", "NEUTRAL", "EVIL")
);

CREATE TABLE size(
id INT PRIMARY KEY,
size ENUM ("TINY", "SMALL", "MEDIUM", "LARGE", "HUGE", "GARGANTUAN"),
space INT NOT NULL UNIQUE
);

CREATE TABLE creature_type(
id INT PRIMARY KEY,
creature_type ENUM ("ABERRATION", "BEAST", "CELESTIAL", "CONSTRUCT", "DRAGON", "ELEMENTAL", "FEY", "FIEND", "GIANT", "HUMANOID", "MONSTROSITY", "OOZE", "PLANT", "UNDEAD") PRIMARY KEY
);

CREATE TABLE conditions(
id INT PRIMARY KEY,
condition_name ENUM("BLINDED", "CHARMED", "DEAFENED", "FRIGHTENED", "GRAPPLED", "INCAPACITATED", "INVISIBLE", "PARALYZED", "PETRIFIED", "POISONED", "PRONE", "RESTRAINED", "STUNNED", "UNCONSCIOUS", "EXHAUSTION 1", "EXHAUSTION 2", "EXHAUSTION 3", "EXHAUSTION 4", "EXHAUSTION 5", "EXHAUSTION 6"),
condition_description TEXT
);

CREATE TABLE creature_condition(
creature_id INT,
condition_id INT
);

CREATE TABLE condition_relationship(
condition_id INT,
condition_relationship ENUM ("ADVANTAGE", "IMMUNE")
);

CREATE TABLE creature_condition_relationship(
creature_id INT,
condition_relationship_id INT
);

CREATE TABLE languages(
id INT PRIMARY KEY,
language_name VARCHAR(16),
is_exotic BOOL 
);

CREATE TABLE creature_language(
creature_id INT,
language_id INT
);

CREATE TABLE challenge_rating(
rating NUMERIC (10, 2) PRIMARY KEY,
experience_points INT
);

CREATE TABLE creature_challenge(
creature_id INT,
rating NUMERIC (10, 2)
);

CREATE TABLE sense(
id INT PRIMARY KEY,
sense ENUM("BLINDSIGHT", "DARKVISION", "TREMORSENSE", "TRUESIGHT"),
distance INT
);

CREATE TABLE creature_sense(
creature_id INT,
sense_id INT
);

CREATE TABLE movement(
id INT,
distance INT,
movement ENUM ("WALK", "BURROW", "CLIMB", "FLY", "SWIM")
);

CREATE TABLE creature_movement(
creature_id INT,
movement_id INT
);

CREATE TABLE item(
id INT PRIMARY KEY,
item_name VARCHAR(64),
item_description TEXT,
WEIGHT NUMERIC(10, 2),
cost_id INT,
cost_amount INT 
);

CREATE TABLE creature_item(
creature_id INT,
item_id INT
);

CREATE TABLE armor(
id INT PRIMARY KEY,
item_id INT,
armor_type ENUM ("CLOTHING", "LIGHT", "MEDIUM", "HEAVY"),
strength_minimum INT,
stealth_disadvantage BOOL,
base_armor_class INT,
maximum_dex_modifier INT
);

CREATE TABLE weapon(
id INT PRIMARY KEY,
item_id INT,
damage_type_id INT, 
damage_dice_id INT,
damage_dice_amount INT,
is_martial BOOl,
min_range INT,
max_range INT
);

CREATE TABLE weapon_properties( # maybe just hardcode all the properties how to use instead of description so gameplay can be automated?
id INT PRIMARY KEY,
property_name VARCHAR(32),
property_description TEXT
);

CREATE TABLE weapon_property_match(
weapon_id INT,
weapon_property_id INT
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
#current_hp INT,
hit_dice_type INT,
hit_dice_number INT
);

CREATE TABLE time_units(
id INT,
unit ENUM("ACTION", "BONUS ACTION", "REACTION", "MINUTE", "HOUR", "DAY", "INSTANTANEOUS")
);

CREATE TABLE components(
id INT PRIMARY KEY,
verbal BOOL,
somatic BOOL,
material BOOL,
material_item_id INT
);

CREATE TABLE spell_components(
spell_id INT,
components_id INT
);

CREATE TABLE aoe_shape(
id INT PRIMARY KEY,
shape ENUM("CONE", "CUBE", "CYLINDER", "LINE", "SPHERE"),
size INT
);

CREATE TABLE spell_aoe_shape(
spell_id INT,
aoe_id INT
);

CREATE TABLE spell(
id INT,
spell_name VARCHAR(128),
spell_school ENUM ("ABJURATION", "CONJURATION", "DIVINATION", "ENCHANTMENT", "EVOCATION", "ILLUSION", "NECROMANCY", "TRANSMUTATION"),
spell_level INT, 
is_ritual BOOL,
is_concentration BOOL,
casting_unit INT,
casting_unit_amount INT,
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

CREATE TABLE spell_class(
class_id INT, 
spell_id INT
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
weight_max INT
);

CREATE TABLE features( # OOF needs lots of work for many things to fit such as trigger uses type etc.
id INT PRIMARY KEY,
feature_description TEXT
);

CREATE TABLe race_feature(
race_id INT,
feature_id INT
);

CREATE TABLE race_item_prof(
race_id INT,
item_id INT
);

CREATE TABLE racial_spells(
race_id INT,
spell_id INT,
at_level INT
);

CREATE TABLE race_skill_prof(
race_id INT,
skill_id INT
);

CREATE TABLE race_damage_relationship(
race_id INT,
damage_relationship_id INT
);

CREATE TABLE race_movement(
race_id INT,
movement_id INT
);

CREATE TABLE race_sense(
race_id INT,
sense_id INT
);

CREATE TABLE race_asi(
race_id INT,
ability_id INT,
increase INT
);

CREATE TABLE race_names(
id_race INT,
id_common_name INT
);

CREATE TABLE common_names(
id INT PRIMARY KEY,
common_name VARCHAR(32),
is_family_name BOOL,
gender ENUM ("NEUTRAL", "MASCULINE", "FEMINENE")
);

CREATE TABLE race_language(
race_id INT,
language_id INT
);

CREATE TABLE race_condition_relationship(
race_id INT,
condition_relationship_id INT
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
item_id INT
);


# ADD TABLE FOR NORMAL ITEMS SUCH AS LIGHT SOURCES, TOOLS, THROWABLES, ETC. 
# order of combat, initative, surprise, turns 
# actions 
# class 
# player and DM permissions
# maps 
# game 
# magic items 
