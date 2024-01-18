#------------------------------------
# VALUES
#------------------------------------
INSERT INTO ability_score (ability_name) VALUES
	('STRENGTH'), ('DEXTERITY'), ('CONSTITUTION'), ('INTELLIGENCE'),  ('WISDOM'), ('CHARISMA');

INSERT INTO skill (skill_name, ability_score_id) VALUES
	('Athletics', 1), ('Acrobatics', 2), ('Sleight of Hand', 2), ('Stealth', 2), 
    ('Arcana', 4), ('History', 4), ('Investigation', 4), ('Nature', 4), ('Religion', 4), 
    ('Animal Handling', 5), ('Insight', 5), ('Medicine', 5), ('Perception', 5), ('Survival', 5), 
    ('Deception', 6), ('Intimidation', 6), ('Performance', 6), ('Persuasion', 6),
    ('Strength Saving Throw', 1), ('Dexterity Saving Throw', 2),  ('Constitution Saving Throw', 3), ('Intelligence Saving Throw', 4), ('Wisdom Saving Throw', 5), ('Charisma Saving Throw', 6);

INSERT INTO dice (dice) VALUES
	('d4'), ('d6'), ('d8'), ('d10'), ('d12'), ('d20'), ('d100');
    
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

# conditions
INSERT INTO conditions (condition_name, condition_description) VALUES
	('BLINDED', 'A blinded creature can’t see and automatically fails any ability check that requires sight. Attack rolls against the creature have advantage, and the creature’s attack rolls have disadvantage.'),
	('CHARMED', 'A charmed creature can’t attack the charmer or target the charmer with harmful abilities or magical effects. The charmer has advantage on any ability check to interact socially with the creature.'),
	('DEAFENED', 'A deafened creature can’t hear and automatically fails any ability check that requires hearing.'),
	('FRIGHTENED', 'A frightened creature has disadvantage on ability checks and attack rolls while the source of its fear is within line of sight. The creature can’t willingly move closer to the source of its fear.'),
	('GRAPPLED', 'A grappled creature’s speed becomes 0, and it can’t benefit from any bonus to its speed. The condition ends if the grappler is incapacitated (see the condition). The condition also ends if an effect removes the grappled creature from the reach of the grappler or grappling effect, such as when a creature is hurled away by the thunderwave spell.'),
	('INCAPACITATED', 'An incapacitated creature can’t take actions or reactions.'),
	('INVISIBLE', 'An invisible creature is impossible to see without the aid of magic or a special sense. For the purpose of hiding, the creature is heavily obscured. The creature’s location can be detected by any noise it makes or any tracks it leaves. Attack rolls against the creature have disadvantage, and the creature’s attack rolls have advantage.'),
	('PARALYZED', 'A paralyzed creature is incapacitated (see the condition) and can’t move or speak. The creature automatically fails Strength and Dexterity saving throws. Attack rolls against the creature have advantage. Any attack that hits the creature is a critical hit if the attacker is within 5 feet of the creature.'),
	('PETRIFIED', 'A petrified creature is transformed, along with any nonmagical object it is wearing or carrying, into a solid inanimate substance (usually stone). Its weight increases by a factor of ten, and it ceases aging. The creature is incapacitated (see the condition), can’t move or speak, and is unaware of its surroundings. Attack rolls against the creature have advantage. The creature automatically fails Strength and Dexterity saving throws. The creature has resistance to all damage. The creature is immune to poison and disease, although a poison or disease already in its system is suspended, not neutralized.'),
	('POISONED', 'A poisoned creature has disadvantage on attack rolls and ability checks.'),
	('PRONE', 'A prone creature’s only movement option is to crawl, unless it stands up and thereby ends the condition. The creature has disadvantage on attack rolls. An attack roll against the creature has advantage if the attacker is within 5 feet of the creature. Otherwise, the attack roll has disadvantage.'),
	('RESTRAINED', 'A restrained creature’s speed becomes 0, and it can’t benefit from any bonus to its speed. Attack rolls against the creature have advantage, and the creature’s attack rolls have disadvantage. The creature has disadvantage on Dexterity saving throws.'),
	('STUNNED', 'A stunned creature is incapacitated (see the condition), can’t move, and can speak only falteringly. The creature automatically fails Strength and Dexterity saving throws. Attack rolls against the creature have advantage.'),
	('UNCONSCIOUS', 'An unconscious creature is incapacitated (see the condition), can’t move or speak, and is unaware of its surroundings The creature drops whatever it’s holding and falls prone. The creature automatically fails Strength and Dexterity saving throws. Attack rolls against the creature have advantage. Any attack that hits the creature is a critical hit if the attacker is within 5 feet of the creature.'),
	('EXHAUSTION 1', 'Disadvantage on ability checks'),
	('EXHAUSTION 2', 'Speed halved'),
	('EXHAUSTION 3', 'Disadvantage on attack rolls and saving throws'),
	('EXHAUSTION 4', 'Hit point maximum halved'),
	('EXHAUSTION 5', 'Speed reduced to 0'),
	('EXHAUSTION 6', 'Death');

    
SELECT * FROM skill;

# CREATURE TEMPLATE # ('', size, type, align, str, dex, con, int, wis, chr, prof, hitdice, hitdicenum, cr)
INSERT INTO creature_template (creature_name, size_id, creature_type_id, alignment_id, STRENGTH, DEXTERITY, CONSTITUTION, INTELLIGENCE, WISDOM, CHARISMA, proficiency, hit_dice_type_id, hit_dice_number, challenge_rating) VALUES
	('Centaur', 		4, 11, 	4, 18, 	14, 14, 9, 13, 11, 	2, 4, 6, 2),
    ('Chuul', 			4, 1, 	9, 19, 	10, 16, 5, 11, 5, 	4, 4, 11, 4),
    ('Death Knight', 	3, 14, 	9, 20, 	11, 20, 12, 16, 18, 6, 3, 19, 17),
	('Goblin', 			2, 10, 	6, 8, 	14, 10, 10, 8, 8, 	2, 2, 2, 0.25),
	('Giant Spider', 	4, 2, 	5, 14, 	16, 12, 2, 11, 4, 	2, 4, 4, 1),
	('Ogre', 			4, 9, 	9, 19, 	8, 16, 	5, 7, 7, 	2, 4, 7, 2),
	('Mimic', 			3, 11, 	5, 17, 	12, 15, 5, 13, 8, 	4, 3, 9, 2),
	('Displacer Beast', 4, 11, 	3, 18, 	15, 16, 6, 12, 8, 	2, 4, 10, 3);

SELECT * FROM size;
SELECT * FROM creature_type;
SELECT * FROM alignment;
SELECT * FROM dice;
SELECT * FROM creature_template;

# SKILL PROFICIENCY
INSERT INTO skill_proficiency (creature_id, skill_id) VALUES
	(1, 1), (1, 13), (1, 14), (2, 13),
    (3, 20), (3, 23), (3, 24), (7, 4);
    
INSERT INTO skill_proficiency VALUES
	(4, 4, true), (5, 4, true);

INSERT INTO damage_type_relationship (damage_id, damage_relationship_id) VALUES
	(7, 2), (1, 3), (3, 2);
    
INSERT INTO creature_damage_relationship (creature_id, damage_type_relationship_id) VALUES
	(7, 2);
    
INSERT INTO item (item_name, item_description, WEIGHT, cost_id, cost_amount) VALUES
	('Copper Coin', 'A humble old copper coin', 0, 1, 1), ('Silver Coin', 'A plain old Silver coin', 0, 1, 10), ('Electrum Coin', 'A weird old electrum coin', 0, 2, 5) , ('Gold Coin', 'A mighty old gold coin', 0, 3, 10), ('Platinum Coin', 'A legendary old platinum coin', 0, 4, 10); 

INSERT INTO item (item_name, item_description, WEIGHT, cost_id, cost_amount) VALUES
('Padded Armor'				, 'Padded armor consists of quilted layers of cloth and batting.', 8		, 4, 5),
('Leather Armor'			, 'The breastplate and shoulder protectors of this armor are made of leather that has been stiffened by being boiled in oil. The rest of the armor is made of softer and more flexible materials.', 10	, 4, 10),
('Studded Leather Armor'	, 'Made from tough but flexible leather, studded leather is reinforced with close-set rivets or spikes.', 13	, 4, 45),
('Hide Armor'				, 'This crude armor consists of thick furs and pelts. It is commonly worn by barbarian tribes, evil humanoids, and other folk who lack access to the tools and materials needed to create better armor.', 12	, 4, 10),
('Chain Armor'				, 'Made of interlocking metal rings, a chain shirt is worn between layers of clothing or leather. This armor offers modest protection to the wearer’s upper body and allows the sound of the rings rubbing against one another to be muffled by outer layers.', 20	, 4, 50),
('Scale Armor'				, 'This armor consists of a coat and leggings (and perhaps a separate skirt) of leather covered with overlapping pieces of metal, much like the scales of a fish. The suit includes gauntlets.', 45	, 4, 50),
('Breastplate Armor'		, 'This armor consists of a fitted metal chest piece worn with supple leather. Although it leaves the legs and arms relatively unprotected, this armor provides good protection for the wearer’s vital organs while leaving the wearer relatively unencumbered.', 20	, 4, 400),
('Halfplate Armor'			, 'Half plate consists of shaped metal plates that cover most of the wearer’s body. It does not include leg protection beyond simple greaves that are attached with leather straps.', 40	, 4, 750),
('Ring Mail Armor'			, 'This armor is leather armor with heavy rings sewn into it. The rings help reinforce the armor against blows from swords and axes. Ring mail is inferior to chain mail, and its usually worn only by those who can’t afford better armor.', 40	, 4, 30),
('Chain Mail Armor'			, 'Made of interlocking metal rings, chain mail includes a layer of quilted fabric worn underneath the mail to prevent chafing and to cushion the impact of blows. The suit includes gauntlets.', 55	, 4, 75),
('Splint Armor'				, 'This armor is made of narrow vertical strips of metal riveted to a backing of leather that is worn over cloth padding. Flexible chain mail protects the joints.', 60	, 4, 20),
('Plate Armor'				, 'Plate consists of shaped, interlocking metal plates to cover the entire body. A suit of plate includes gauntlets, heavy leather boots, a visored helmet, and thick layers of padding underneath the armor. Buckles and straps distribute the weight over the body.', 65	, 4, 1500),
('Shield'					, 'A shield is made from wood or metal and is carried in one hand. Wielding a shield increases your Armor Class by 2. You can benefit from only one shield at a time.', 6, 4, 10),
('Dagger'			, '', 1, 2, 5),
('Mace'				, '', 4, 4, 5),
('Spear'			, '', 3, 4, 1),
('Shortbow'			, '', 2, 4, 25),
('Crossbow, Light'	, '', 5, 4, 25),
('Battleaxe'		, '', 4, 4, 10),
('Longsword'		, '', 3, 4, 15),
('Rapier'			, '', 2, 4, 25),
('Scimitar'			, '', 3, 4, 25),
('Crossbow, Heavy'	, '', 18, 4, 50),
('Longbow'			, '', 2, 4, 50),
('Candle'			, '', 0, 1, 1),
('Torch'			, '', 1, 1, 1),
('Bullseye Lantern'	, '', 2, 4, 10),
('Acid Vial'		, '', 2, 4, 2),
('Alchemist Fire'	, '', 1, 4, 25),
('Smokepowder Bomb'	, '', 4, 4, 50),
('Potion of Healing'			, '', 1, 4, 50),
('Greater Potion of Healing'	, '', 1, 4, 150),
('Poison'						, '', 1, 4, 100),
('Artisan Tools', 	'', 5, 4, 50),
('Thieves Tools', 	'', 10, 4, 25),
('Bedroll', 		'', 7, 4, 1),
('Blanket', 		'', 3, 2, 5),
('Bucket,', 		'', 5, 2, 2),
('Lockpick', 		'', 0, 2, 2),
('Hammer', 			'', 2, 2, 5),
('Mess Kit', 		'', 3, 4, 3)
;

INSERT INTO consumable VALUES
(36, 1, 2, true, null, null, null, null),
(37, 1, 4, true, null, null, null, null),
(38, 3, 3, false, 3, 15, 10, null)
;

INSERT INTO aoe_shape (shape, shape_size) VALUES 
('SPHERE', 10), ('SPHERE', 60), ('CONE', 120), ('SPHERE', 15), ('SPHERE', 20);

INSERT INTO throwable VALUES
(33, 10, 30, 1, 2, 15, 1, 2, 1),
(34, 10, 45, 4, 2, 12, 2, 1, 3),
(35, 10, 25, 5, 2, 18, 4, 4, 10)
;

INSERT INTO light_source (item_id, aoe_id, duration_in_minutes) VALUES
(30, 1, 30), (31, 2, 60), (32, 3, 180);

INSERT INTO armor (item_id, armor_type, strength_minimum, stealth_disadvantage, base_armor_class, maximum_dex_modifier) VALUES
 (6, 	"LIGHT", 	0, 	true, 11, NULL),
 (7, 	"LIGHT", 	0, 	false, 11, NULL),
 (8, 	"LIGHT", 	0, 	false, 12, NULL),
 (9, 	"MEDIUM", 	0, 	false, 12, 2),
 (10, 	"MEDIUM", 	0, 	false, 13, 2),
 (11, 	"MEDIUM", 	0, 	true, 14, 2),
 (12, 	"MEDIUM", 	0, 	false, 14, 2),
 (13, 	"MEDIUM", 	0, 	true, 15, 2),
 (14, 	"HEAVY", 	0, 	true, 14, 0),
 (15, 	"HEAVY", 	13, true, 16, 0),
 (16, 	"HEAVY", 	15, true, 17, 0),
 (17, 	"HEAVY", 	15, true, 18, 0),
 (18, 	"SHIELD",	0,	false, 2, 0);
 
INSERT INTO weapon (item_id, damage_type_id, damage_dice_id, damage_dice_amount, is_martial, min_range, max_range) VALUES
(19, 12, 1, 1, false, 0, 5),
(20, 11, 2, 1, false, 0, 5),
(21, 12, 2, 1, false, 0, 5),
(22, 12, 2, 1, false, 10, 80),
(23, 12, 3, 1, false, 10, 60),
(24, 13, 2, 2, true, 0, 5),
(25, 13, 3, 1, true, 0, 5),
(26, 12, 3, 1, true, 0, 5),
(27, 13, 2, 1, true, 0, 5),
(28, 12, 4, 1, true, 10, 400),
(29, 12, 3, 1, true, 10, 600);


INSERT INTO weapon_properties (property_name, property_description) VALUES
	('Finesse', 'You use dexterity instead of strength'), ('Ammunition', 'Your weapons use arrows each attack'), ('Heavy', 'Small creatures have disadvantage');

SELECT * FROM weapon;
SELECT * FROM weapon_properties;

INSERT INTO weapon_property_match (weapon_id, weapon_property_id) VALUES
	(1, 1), (4, 2), (5, 2), (8, 1), (9, 1), (10, 2), (10, 3), (11, 2);

# CONDITION RELATIONSHIP KAKO TREBA
INSERT INTO condition_relationship (condition_id, condition_relationship) VALUES
	(10, 'IMMUNE'), (2, 'ADVANTAGE'), (10, 'ADVANTAGE'), (11, 'IMMUNE');

# creature_condition_relationship kako treba
INSERT INTO creature_condition_relationship (creature_id, condition_relationship_id) VALUES
	(2, 1), (7, 4);    
    
# creature_language
INSERT INTO creature_language VALUES
	(1, 3), (1, 15), (2, 12), (4, 1), (4, 6), (6, 1), (6, 4), (3, 1), (3, 9);

# sense as needed
INSERT INTO sense (sense, distance) VALUES
	('DARKVISION', 60), ('BLINDSIGHT', 10), ('DARKVISION', 120);

# creature_sense as needed
INSERT INTO creature_sense VALUES
	(2, 1), (4, 1), (5, 1), (6, 1), (7, 1), (8, 1), (5, 2), (3,3);

# movement as needed
INSERT INTO movement (movement, distance) VALUES
 	('WALK', 30), ('SWIM', 30), ('WALK', 50), ('WALK', 25), ('WALK', 40), ('WALK', 15), ('CLIMB', 30);

# creature_movement
INSERT INTO creature_movement VALUES
	(1, 3), (2, 1), (2, 2), (3, 1), (4, 1), (5, 1), (6, 5), (7, 6), (8, 5), (5, 7);

INSERT INTO background (background_name, background_description) VALUES
('Criminal', 'Vou are an experienced criminal wilh a hislory of breaking lhe law. Vou have spent a lot of time among olher criminais and still have contacts wilhin lhe criminal underworld. Youre far closer than most people to the world of murder, theft, and violence that pervades the underbelly of civilization, and you have survived up to this point by flouting the rules and regulations of society.'),
('Guild Artisan', 'You are a member of an artisans guild, skilled in a particular field and closely associated with other artisans. You are a well-established part of the mercantile world, freed by talent and wealth from the constraints of a feudal social order. You learned your skills as an apprentice to a master artisan, under the sponsorship of your guild, until you became a master in your own right.'),
('Soldier', 'War has been your life for as long as you care to remember. You trained as a youth, studied the use of weapons and armor, learned basic survival techniques, including how to stay alive on the battlefield. You might have been part of a standing national army or a mercenary company, or perhaps a member of a local militia who rose to prominence during a recent war.');

INSERT INTO background_skills VALUES
(1, 15), (1, 4), (2, 11), (2, 18), (3, 1), (3, 16);

INSERT INTO background_languages VALUES
(1, 16), (2, 2);

INSERT INTO background_item_prof VALUES
(1, 19), (1, 23), (1, 40), (2, 19), (2, 45), (3, 25), (3, 18), (3, 10);

INSERT INTO background_equipment VALUES
(1, 19, 1), (1, 42, 1), (1, 30, 3), (1, 44, 1), (1, 36, 1), (1, 4, 25), (1, 38, 1), 
(2, 4, 50), (2, 32, 1), (2, 35, 2), (2, 34, 1), (2, 39, 1), (2, 37, 1), 
(3, 25, 1), (3, 31, 5), (3, 46, 1), (3, 4, 5), (3, 43, 1), (3, 41, 1);

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

INSERT INTO race_asi VALUES
	(1,2,2), (1,4,1), (2,1,2), (2,3,2), (3,1,1), (3,2,1), (3,3,1), (3,4,1),	(3,5,1), (3,6,1), (4,4,1), (4,6,2);    

INSERT INTO race_skill_prof VALUES
	(1, 13), (2, 6);

INSERT INTO race_condition_relationship VALUES
	(1, 2), (2, 3);
    
INSERT INTO race_language VALUES
	(1, 1), (1, 3), (2, 1), (2, 2), (3, 1), (4, 1), (4, 13);
    
INSERT INTO race_sense VALUES 
	(1, 1), (2, 1), (4, 1);

INSERT INTO race_movement VALUES
	(1, 1), (2, 4), (3, 1), (4, 1);

INSERT INTO race_damage_relationship VALUES
	(2, 1), (4, 3);
    
INSERT INTO race_item_prof VALUES 
(2, 39), (1, 26);

INSERT INTO features VALUES
(1, 'Elvish Trance', 'Instead of sleeping, you can meditate for 4 hours.');

INSERT INTO race_feature VALUES
(2, 1);


INSERT INTO common_names (common_name, is_family_name, gender) VALUES
    ('Blackwood', TRUE, 'NEUTRAL'), ('Fairmont', TRUE, 'NEUTRAL'), ('Hawthorne', TRUE, 'NEUTRAL'), ('Silvershade', TRUE, 'NEUTRAL'), ('Moonwhisper', TRUE, 'NEUTRAL'),
    ('Starflower', TRUE, 'NEUTRAL'), ('Ironheart', TRUE, 'NEUTRAL'), ('Axebeard', TRUE, 'NEUTRAL'), ('Stonefist', TRUE, 'NEUTRAL'), ('Nightwalker', TRUE, 'NEUTRAL'),
    ('Flamescar', TRUE, 'NEUTRAL'), ('Shadowhorn', TRUE, 'NEUTRAL'), ('John', FALSE, 'MASCULINE'), ('Emma', FALSE, 'FEMININE'), ('Oliver', FALSE, 'MASCULINE'),
    ('Sophia', FALSE, 'FEMININE'), ('William', FALSE, 'MASCULINE'), ('Isabella', FALSE, 'FEMININE'), ('Elandriel', FALSE, 'NEUTRAL'), ('Luthien', FALSE, 'FEMININE'),
    ('Feanor', FALSE, 'MASCULINE'), ('Galadriel', FALSE, 'FEMININE'), ('Arwen', FALSE, 'FEMININE'), ('Legolas', FALSE, 'MASCULINE'), ('Thorin', FALSE, 'MASCULINE'),
    ('Gimli', FALSE, 'MASCULINE'), ('Dwalin', FALSE, 'MASCULINE'), ('Balin', FALSE, 'MASCULINE'), ('Kili', FALSE, 'MASCULINE'), ('Fili', FALSE, 'MASCULINE'),
    ('Zariel', FALSE, 'NEUTRAL'), ('Akmenos', FALSE, 'NEUTRAL'), ('Mephistopheles', FALSE, 'NEUTRAL'), ('Ravix', FALSE, 'NEUTRAL'), ('Bel', FALSE, 'NEUTRAL'),('Malcanthet', FALSE, 'FEMININE');
INSERT INTO race_names (race_id, common_name_id) VALUES
    (1, 4),  (1, 5),  (1, 6), (3, 14),  (3, 15),  (3, 16), (3, 17),  (3, 18),  (1, 19), 
    (2, 7), (2, 8), (2, 9), (4, 20), (1, 21), (1, 22),  (1, 23), (1, 24), (2, 25),
    (3, 1), (3, 2), (3, 3), (3, 10), (4, 11), (4, 12), (3, 13), (2, 26), (2, 27), 
    (2, 28), (2, 29), (2, 30), (4, 31), (4, 32),(4, 33),(4, 34),(4, 35), (4, 36); 

INSERT INTO time_units (unit) VALUES
    ('INSTANTANEOUS'), ('ACTION'), ('BONUS ACTION'), ('REACTION'), ('MINUTE'), ('HOUR'), ('DAY');

INSERT INTO spell VALUES
(1, 'Firebolt', 'EVOCATION', 0, false, false, 2, 1, 1, 1, 60, 1, 4, 1, false, true, null, 'Hurls a bolt of fire'),
(2, 'Acid Splash', 'CONJURATION', 0, false, false, 2, 1, 1, 1, 30, 1, 2, 1, false, true, null, 'Hurls two bubbles of acid'),
(3, 'Fireball', 'EVOCATION', 1, false, false, 2, 1, 1, 1, 120, 1, 3, 6, false, false, 2, 'Hurls a ball of fire');

INSERT INTO components VALUES 
(1, true, true, false, null);

INSERT INTO spell_components VALUES
(1, 1), (2, 1), (3, 1);

INSERT INTO spell_aoe_shape VALUES 
(3, 1);

# item as needed 
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
