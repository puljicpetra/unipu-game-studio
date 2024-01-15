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

# CREATURE TEMPLATE

# SKILL PROFICIENCY
    
# CONDITION RELATIONSHIP KAKO TREBA 

# creature_condition_relationship kako treba


