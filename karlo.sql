USE game_studio;

INSERT INTO player VALUES
    (1,222, true);

INSERT INTO game_instance VALUES
    (1,"Greece figth", 1, '2024-01-17 12:34:56' );

INSERT INTO map VALUES
    (1, 1, 1);
 
INSERT INTO creature_instance VALUES
    (1,3,100,1),
    (2,5,100,2),
    (3,6,100,2),
    (4,7,100,2),
    (5,8,100,2);

INSERT INTO map_creatures VALUES
    (1,1,200,450,0),
    (2,1,200,400,0),
    (3,1,200,350,0),
    (4,1,200,700,0),
    (5,1,200,500,0);

DROP FUNCTION IF EXISTS calculateDistance;
DELIMITER //

CREATE FUNCTION calculateDistance(creature1_id INT, creature2_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE instances_count INT;
  DECLARE distance INT;

  SELECT COUNT(*)
  INTO instances_count
  FROM map_creatures mc1
  JOIN map_creatures mc2 ON mc1.map_id = mc2.map_id
  WHERE mc1.creature_instance_id = creature1_id AND mc2.creature_instance_id = creature2_id;

  IF instances_count > 0 THEN
    SELECT SQRT(POWER(mc1.coord_x - mc2.coord_x, 2) + POWER(mc1.coord_y - mc2.coord_y, 2) + POWER(mc1.coord_z - mc2.coord_z, 2))
    INTO distance
    FROM map_creatures mc1
    JOIN map_creatures mc2 ON mc1.map_id = mc2.map_id
    WHERE mc1.creature_instance_id = creature1_id AND mc2.creature_instance_id = creature2_id;
    RETURN distance;
  ELSE
    RETURN NULL;
  END IF;
END //

DELIMITER ;

SELECT calculateDistance(1, 2) AS distance;

INSERT INTO creature_instance_inventory VALUES
	(1,28,1),
    (1,23,1),
    (1,18,1);
    
INSERT INTO object_template VALUES
	(1,"chest","Includes the items or other type of treasures.",1,30);
    
SELECT ci.item_id, i.item_name, w.min_range, w.max_range, calculateDistance(1, 2) AS distance
FROM creature_instance_inventory ci
JOIN weapon w ON ci.item_id = w.item_id
JOIN item i ON ci.item_id = i.id
WHERE ci.creature_instance_id = 1
  AND calculateDistance(1, 2) >= w.min_range AND calculateDistance(1, 2) <= w.max_range;
  
-------

SELECT * FROM 
creature_instance_inventory cii 
join item on item.id = cii.item_id
join weapon on weapon.item_id = item.id
where cii.creature_instance_id = 1
;

------
CREATE VIEW Creatures_distance AS 
SELECT
    mc2.creature_instance_id AS target_creature_instance_id,
    SQRT(POWER(mc1.coord_x - mc2.coord_x, 2) + POWER(mc1.coord_y - mc2.coord_y, 2) + POWER(mc1.coord_z - mc2.coord_z, 2)) AS distance
FROM
    map_creatures mc1
JOIN
    map_creatures mc2 ON mc1.map_id = mc2.map_id
WHERE
    mc1.creature_instance_id = 1;
    
SELECT * FROM Creatures_distance;

-----

SELECT
    ci.id AS attacker_id,
    i.item_name AS weapon_name,
    mc2.creature_instance_id AS target_id,
    SQRT(POWER(mc1.coord_x - mc2.coord_x, 2) + POWER(mc1.coord_y - mc2.coord_y, 2) + POWER(mc1.coord_z - mc2.coord_z, 2)) AS distance
FROM
    creature_instance ci
JOIN
    creature_instance_inventory cii ON ci.id = cii.creature_instance_id
JOIN
    weapon w ON cii.item_id = w.item_id
JOIN
    item i ON w.item_id = i.id
JOIN
    map_creatures mc1 ON ci.id = mc1.creature_instance_id
JOIN
    map_creatures mc2 ON mc1.map_id = mc2.map_id
WHERE
    ci.id = 1
    AND SQRT(POWER(mc1.coord_x - mc2.coord_x, 2) + POWER(mc1.coord_y - mc2.coord_y, 2) + POWER(mc1.coord_z - mc2.coord_z, 2)) BETWEEN w.min_range AND w.max_range
LIMIT 0, 1000;

----

DROP PROCEDURE IF EXISTS HandleCreatureDeath;

DELIMITER //
CREATE PROCEDURE HandleCreatureDeath(creature_instance_id INT)
BEGIN
    DECLARE creature_name VARCHAR(64);
    DECLARE creature_description TEXT;
    DECLARE coord_x INT;
    DECLARE coord_y INT;
    DECLARE coord_z INT;
    DECLARE creature_map_id INT;

    SELECT
        ct.creature_name,
        CONCAT('Inventory of ', ct.creature_name),
        mc.coord_x,
        mc.coord_y,
        mc.coord_z,
		mc.map_id
    INTO
        creature_name,
        creature_description,
        coord_x,
        coord_y,
        coord_z,
		creature_map_id
    FROM
        creature_instance ci
    JOIN
        creature_template ct ON ci.creature_template_id = ct.id
    JOIN
        map_creatures mc ON ci.id = mc.creature_instance_id
    WHERE
        ci.id = creature_instance_id;

    INSERT INTO object_template (object_name, object_description, size_id, health_points)
    VALUES
        (CONCAT(creature_name, '_chest'), creature_description, 1, 1);

    INSERT INTO object_instance (object_template_id, map_id, coord_x, coord_y, coord_z)
    VALUES
        ((SELECT id FROM object_template WHERE object_template.object_name=(CONCAT(creature_name, '_chest'))),creature_map_id, coord_x, coord_y, coord_z);

END //
DELIMITER ;

-- CALL HandleCreatureDeath(1);

SELECT * FROM creature_instance;
SELECT * FROM creature_template;
SELECT * FROM object_instance;
SELECT * FROM object_template;
SELECT * FROM map_creatures;
-- SELECT * FROM creature_instance_inventory;



