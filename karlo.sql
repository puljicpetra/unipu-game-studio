USE game_studio;

INSERT INTO aoe_shape VALUES
    (1, "CUBE", 1000);
 
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

  -- Provjera da li su creature instance u istom gameu na istoj mapi
  SELECT COUNT(*)
  INTO instances_count
  FROM map_creatures mc1
  JOIN map_creatures mc2 ON mc1.map_id = mc2.map_id
  WHERE mc1.creature_instance_id = creature1_id AND mc2.creature_instance_id = creature2_id;

  -- Ako su u istom gameu na istoj mapi, izračunaj udaljenost
  IF instances_count > 0 THEN
    SELECT SQRT(POWER(mc1.coord_x - mc2.coord_x, 2) + POWER(mc1.coord_y - mc2.coord_y, 2) + POWER(mc1.coord_z - mc2.coord_z, 2))
    INTO distance
    FROM map_creatures mc1
    JOIN map_creatures mc2 ON mc1.map_id = mc2.map_id
    WHERE mc1.creature_instance_id = creature1_id AND mc2.creature_instance_id = creature2_id;
    RETURN distance;
  ELSE
    RETURN NULL; -- Ako nisu u istom gameu na istoj mapi, vrati NULL
  END IF;
END //


DELIMITER ;
SELECT calculateDistance(1, 2) AS distance;

INSERT INTO creature_instance_inventory VALUES
	(1,28,1),
    (1,23,1),
    (1,18,1);
    

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
SELECT
    mc2.creature_instance_id AS target_creature_instance_id,
    SQRT(POWER(mc1.coord_x - mc2.coord_x, 2) + POWER(mc1.coord_y - mc2.coord_y, 2) + POWER(mc1.coord_z - mc2.coord_z, 2)) AS distance
FROM
    map_creatures mc1
JOIN
    map_creatures mc2 ON mc1.map_id = mc2.map_id
WHERE
    mc1.creature_instance_id = 1;
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


