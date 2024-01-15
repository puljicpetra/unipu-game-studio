#------------------------------------
# VALUES
#------------------------------------


INSERT INTO ability_score (ability_name) VALUES
	('STRENGTH'), ('DEXTERITY'), ('CONSTITUTION'), ('INTELLIGENCE'),  ('WISDOM'), ('CHARISMA');
    select*
    from ability_score;


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

INSERT INTO race VALUES
(1,'Elf','Elves are a magical people of otherworldly grace, living in the world but not entirely part of it. They live in places of ethereal beauty, in the midst of ancient forests or in silvery spires glittering with faerie light, where soft music drifts through the air and gentle fragrances waft on the breeze. Elves love nature and magic, art and artistry, music and poetry, and the good things of the world.',
'Elves who lived among humans, of whom there were many, tended to take on roles that favored the arts, such as minstrels, artists, or sages. Many were also valued as martial instructors, given the elven races well-known skills with both the bow and the sword.',
110,700,7,3,10,160,190,90,190),
(2,'Dwarf','Bold and hardy, dwarves are known as skilled warriors, miners, and workers of stone and metal. Though they stand well under 5 feet tall, dwarves are so broad and compact that they can weigh as much as a human standing nearly two feet taller. Their courage and endurance are also easily a match for any of the larger folk.',
'Dwarves highly valued the ties between family members and friends, weaving tightly knit clans. Dwarves particularly respected elders, from whom they expected sound leadership and the wisdom of experience, as well as ancestral heroes or clan founders. This idea carried on to relations with other races and dwarves were deferential even to the elders of another, non-dwarven race',
50,400,1,3,10,110,140,140,180),
(3,'Human','In the reckonings of most worlds, humans are the youngest of the common races, late to arrive on the world scene and short-lived in comparison to dwarves, elves, and dragons. Perhaps it is because of their shorter lives that they strive to achieve as much as they can in the years they are given. Or maybe they feel they have something to prove to the elder races, and that’s why they build their mighty empires on the foundation of conquest and trade. Whatever drives them, humans are the innovators, the achievers, and the pioneers of the worlds.',
'Their cosmopolitan nature encourages openness, fostering cultural exchange. Religion varies widely, encompassing diverse pantheons and belief systems. Political structures range from monarchies to tribal councils, showcasing the ever-evolving societal landscapes.',
25,100,5,3,10,150,200,40,310),
(4,'Tiefling','Tieflings are descended from fiends, demons, and other dark entities. As a result, they often bear infernal traits such as horns, pointed tails, and glowing eyes. Despite their ominous appearance, tieflings are not inherently evil and can be found pursuing various paths in life.',
'Tieflings are often shunned by other races due to their infernal heritage, leading many to become adept at stealth and subterfuge. Some embrace their dark lineage and become formidable rogues and thieves, navigating the shadows with finesse and cunning.',
18,100,9,3,10,160,180,80,220);

INSERT INTO features VALUES
(1,'Dwarven Resilience', 'You have advantage on saving throws against poison, and you have resistance against poison damage.'),
(2,'Darkvision','You can see in dim light within 60 feet of you as if it were bright light, and in darkness as if it were dim light.'),
(3,'Hellish Resistance', 'You have resistance to fire damage.'),
(4,'Fey Ancestry', 'You have advantage on saving throws against being charmed');

INSERT INTO race_feature  VALUES
    (2,5),
    (1,1),
    (3,4),
    (4,4);
    
insert into race_asi values
(3,1,1),
(3,2,1),
(3,3,1),
(3,4,1),
(3,5,1),
(3,6,1);

    



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

