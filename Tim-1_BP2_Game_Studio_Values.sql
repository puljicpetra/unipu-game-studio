#------------------------------------
# VALUES
#------------------------------------


INSERT INTO ability_score (ability_name) VALUES
	('STRENGTH'), ('DEXTERITY'), ('CONSTITUTION'), ('INTELLIGENCE'),  ('WISDOM'), ('CHARISMA');


INSERT INTO skill (skill_name, ability_score_id) VALUES
	('Athletics', 1), ('Acrobatics', 2), ('Sleight of Hand', 2), ('Stealth', 2), 
    ('Arcana', 4), ('History', 4), ('Investigation', 4), ('Nature', 4), ('Religion', 4), 
    ('Animal Handling', 5), ('Insight', 5), ('Medicine', 5), ('Perception', 5), ('Survival', 5), 
    ('Deception', 6), ('Intimidation', 6), ('Performance', 6), ('Persuasion', 6);

INSERT INTO dice (dice) VALUES
	('d4'), ('d6'), ('d8'), ('d10'), ('d12'), ('d20');
    
INSERT INTO size (size, space) VALUES
	('TINY', 2), ('SMALL', 3), ('MEDIUM', 5), ('LARGE', 10), ('HUGE', 15), ('GARGANTUAN', 20);

INSERT INTO alignment (lawfulness, morality) VALUES
	('LAWFUL', 'GOOD'), ('LAWFUL', 'NEUTRAL'), ('LAWFUL', 'EVIL'), 
    ('NEUTRAL', 'GOOD'), ('NEUTRAL', 'NEUTRAL'), ('NEUTRAL', 'EVIL'), 
    ('CHAOTIC', 'GOOD'), ('CHAOTIC', 'NEUTRAL'), ('CHAOTIC', 'EVIL');
    
INSERT INTO creature_type (creature_type) VALUES
	('ABERRATION'), ('BEAST'), ('CELESTIAL'), ('CONSTRUCT'), ('DRAGON'), ('ELEMENTAL'), ('FEY'), ('FIEND'), ('GIANT'), ('HUMANOID'), ('MONSTROSITY'), ('OOZE'), ('PLANT'), ('UNDEAD');
    
INSERT INTO challenge_rating (rating, experience_points) VALUES
	(0, 10), (0.125, 25), (0.25, 50), (0.5, 100), (1, 200), (2, 450), (3, 700), (4, 1100), (5, 1800), 
    (6, 2300), (7, 2900), (8, 3900), (9, 5000), (10, 5900), (11, 7200), (12, 8400), (13, 10000), (14, 11500), (15, 13000), 
    (16, 15000), (17, 18000), (18, 20000), (19, 22000), (20, 25000), (21, 33000), (22, 41000), (23, 50000), (24, 62000), (25, 75000), 
    (26, 90000), (27, 105000), (28, 120000), (29, 135000), (30, 115000);

INSERT INTO damage_type (damage) VALUES
('ACID'), ('COLD'), ('FIRE'), ('FORCE'), ('LIGHTNING'), ('NECROTIC'), ('POISON'), ('PSYCHIC'), ('RADIANT'), 
('THUNDER'), ('BLUDGEONING'), ('PIERCING'), ('SLASHING'), ('MAGICAL PIERCING'), ('MAGICAL BLUDGEONING'), ('MAGICAL SLASHING');

INSERT INTO damage_relationship (relationship) VALUES
	('VULNERABILITY'), ('RESISTANCE'), ('IMMUNITY');

INSERT INTO languages (language_name) VALUES
('Common'), ('Dwarvish'), ('Elvish'), ('Giant'), ('Gnomish'), ('Goblin'), ('Halfling'), ('Orc'); 

INSERT INTO languages (language_name, is_exotic) VALUES
('Abyssal', true), ('Celestial', true), ('Draconic', true), ('Deep Speech', true), ('Infernal', true), ('Primordial', true), ('Sylvan', true), ('Undercommon', true);

INSERT INTO experience_for_level (which_level, experience_needed) VALUES
(1, 0), (2, 300), (3, 900), (4, 2700), (5, 6500), (6, 14000), (7, 23000), (8, 34000), (9, 48000), (10, 64000), (11, 85000), (12, 100000),
(13, 120000), (14, 140000), (15, 165000), (16, 195000), (17, 225000), (18, 265000), (19, 305000), (20, 355000);

# CREATURE TEMPLATE
# SKILL PROFICIENCY
# CONDITION RELATIONSHIP KAKO TREBA 
# creature_condition_relationship kako treba
# sense as needed
# creature_sense as needed
# movement as needed
# item as needed 
# creature instance as needed
# creature item as needed
# armor as needed
# weapon as needed
# weapon properties as needed
# spell as needed
# components as needed
# spell_components as needed
# aoe_shape as needed
# spell_aoe_shape as needed 
# class ass needed
# spell_class as needed 
# race as needed
# weapon_property_match as needed 
# features as needed
# race_feature as needed 
# race_item_prof as needed
# racial_spells as needed 
# race_skill_prof as needed
# race_damage_relationship as needed 
# race_movement as needed 
# race_sense as needed
# race_asi as needed
# common_names as needed
# race_names as needed
# race_language as needed
# race_condition_relationship as needed 
# personality as needed
# player as needed
# background as needed
# background_skills as needed
# background_item_prof as needed 
# background_languages as needed
# background_equipment as needed
# light_source as needed 
# consumable as needed
# creature_condition as needed 
# creature_instance_spell_slots as needed 
# creature_template_spells_known
# creature_instance_spells_known
# creature_instance_inventory 
# game_instance 
# game_players
# map
# map_creatures
# class_saving_prof
# player_character
# notes
# object_template
# object_damage_relationship
# object_instance
# class_proficiency
# class_levels 
# class_level_feature
# class_level_spellslots
# throwable
# 

