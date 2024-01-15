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
INSERT INTO creature_template (creature_name, size_id, creature_type_id, alignment_id, STRENGTH, DEXTERITY, CONSTITUTION, INTELLIGENCE, WISDOM, CHARISMA, proficiency, hit_dice_type_id, hit_dice_number, challenge_rating) VALUES
	('Centaur', 4, 11, 4, 18, 14, 14, 9, 13, 11, 2, 4, 6, 2),
    ('Chuul', 4, 1, 9, 19, 10, 16, 5, 11, 5, 4, 4, 11, 4);

# SKILL PROFICIENCY
INSERT INTO skill_proficiency (creature_id, skill_id) VALUES
	(1, 1), (1, 13), (1, 14), (2, 13);
    
# conditions
INSERT INTO conditions (condition_name, condition_description) VALUES
('BLINDED', 'Description of Blinded...'),
('CHARMED', 'Description of Charmed...'),
('DEAFENED', 'Description of Deafened...'),
('FRIGHTENED', 'Description of Frightened...'),
('GRAPPLED', 'Description of Grappled...'),
('INCAPACITATED', 'Description of Incapacitated...'),
('INVISIBLE', 'Description of Invisible...'),
('PARALYZED', 'Description of Paralyzed...'),
('PETRIFIED', 'Description of Petrified...'),
('POISONED', 'Description of Poisoned...'),
('PRONE', 'Description of Prone...'),
('RESTRAINED', 'Description of Restrained...'),
('STUNNED', 'Description of Stunned...'),
('UNCONSCIOUS', 'Description of Unconscious...'),
('EXHAUSTION 1', 'Description of Exhaustion 1...'),
('EXHAUSTION 2', 'Description of Exhaustion 2...'),
('EXHAUSTION 3', 'Description of Exhaustion 3...'),
('EXHAUSTION 4', 'Description of Exhaustion 4...'),
('EXHAUSTION 5', 'Description of Exhaustion 5...'),
('EXHAUSTION 6', 'Description of Exhaustion 6...');
    
# CONDITION RELATIONSHIP KAKO TREBA
INSERT INTO condition_relationship (condition_id, condition_relationship) VALUES
	(10, 'IMMUNE');
    
# creature_condition_relationship kako treba
INSERT INTO creature_condition_relationship (creature_id, condition_relationship_id) VALUES
	(2, 1);

# sense as needed
INSERT INTO sense (sense, distance) VALUES
	('DARKVISION', 60);

# creature_sense as needed
INSERT INTO creature_sense VALUES
	(2, 1);

# movement as needed
INSERT INTO movement (movement, distance) VALUES
	('WALK', 30), ('SWIM', 30), ('WALK', 50);

# creature_movement
INSERT INTO creature_movement VALUES
	(1, 3), (2, 1), (2, 2);

# creature_language
INSERT INTO creature_language VALUES
	(1, 3), (1, 15), (2, 12);

# item as needed 
# armor as needed
# weapon as needed
# weapon properties as needed
# spell as needed
# components as needed
# spell_components as needed
# aoe_shape as needed
# spell_aoe_shape as needed 
# weapon_property_match as needed 
# features as needed


# creature instance as needed
# creature item as needed
# class ass needed
# spell_class as needed 

# race as needed
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

