DROP TABLE assignments;
DROP TABLE animals;
DROP TABLE staffs;
DROP TABLE enclosures;

CREATE TABLE staffs (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    employee_number INT
);

CREATE TABLE enclosures (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    capacity INT,
    closed_for_maintenance BOOLEAN
);

CREATE TABLE assignments (
    id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES staffs(id),
    enclosure_id INT REFERENCES enclosures(id),
    day VARCHAR(255)
);

CREATE TABLE animals (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    type VARCHAR(255),
    age INT,
    enclosure_id INT REFERENCES enclosures(id) -- this property hints that there will be a one to may relationship
    -- with enclosures and animals as we hav this foreign key and the fact that enclosures does not have a foreign key
);

INSERT INTO staffs (name, employee_number) VALUES ('captain Rik', 12345);
INSERT INTO staffs (name, employee_number) VALUES ('Joe', 23456);
INSERT INTO staffs (name, employee_number) VALUES ('Emily', 98765);
INSERT INTO staffs (name, employee_number) VALUES ('Brice', 78787);

INSERT INTO enclosures (name, capacity, closed_for_maintenance) VALUES ('big cat field', 30, false); -- 1
INSERT INTO enclosures (name, capacity, closed_for_maintenance) VALUES ('bird sanctuary', 40, true); -- 2
INSERT INTO enclosures (name, capacity, closed_for_maintenance) VALUES ('hippo hideaway', 10, false); -- 3

INSERT INTO animals (name, type, age, enclosure_id) VALUES ('Tony', 'Tiger', 59, 1);
INSERT INTO animals (name, type, age, enclosure_id) VALUES ('Sally', 'Parrot', 23, 2);
INSERT INTO animals (name, type, age, enclosure_id) VALUES ('Henry', 'Hippo', 40, 3);
INSERT INTO animals (name, type, age, enclosure_id) VALUES ('Xavier', 'Rhino', 19, 2);
INSERT INTO animals (name, type, age, enclosure_id) VALUES ('Justin', 'Flamingo', 4, 3);

INSERT INTO assignments (employee_id, enclosure_id, day) VALUES (1, 2, 'Monday');
INSERT INTO assignments (employee_id, enclosure_id, day) VALUES (2, 3, 'Tuesday');
INSERT INTO assignments (employee_id, enclosure_id, day) VALUES (3, 2, 'Friday');
INSERT INTO assignments (employee_id, enclosure_id, day) VALUES (4, 1, 'Saturday');
INSERT INTO assignments (employee_id, enclosure_id, day) VALUES (1, 3, 'Tuesday');

MVP:
-- The names of the animals in a given enclosure:
    SELECT animals.name FROM animals 
    INNER JOIN enclosures 
    ON animals.enclosure_id = enclosures.id 
    WHERE enclosures.id = 'hippo hideaway'/3;

-- The names of the staff working in a given enclosure:
    SELECT DISTINCT(staffs.name) FROM staffs LEFT JOIN assignments ON assignments.employee_id = staffs.id RIGHT JOIN enclosures ON assignments.enclosure_id = enclosures.id;
        -- model solution:
    SELECT employees.name FROM employees -- we don't need two joins as assignments table holds all the info
    we need
    INNER JOIN assignments
    ON assignments.employee_id = employees.id
    WHERE assignments.enclosure_id = 1;

EXTENSION:
-- The names of staff working in enclosures which are closed for maintenance:
    SELECT DISTINCT(staffs.name) FROM staffs 
    INNER JOIN assignments 
    ON assignments.employee_id = staffs.id 
    INNER JOIN enclosures 
    ON assignments.enclosure_id = enclosures.id 
    WHERE enclosures.closed_for_maintenance IS true;

-- The name of the enclosure where the oldest animal lives:
    SELECT enclosures.name FROM animals 
    INNER JOIN enclosures 
    ON animals.enclosure_id = enclosures.id 
    ORDER BY animals.age 
    DESC LIMIT 1;

-- The number of different animal types a given keeper has been assigned to work with:
   SELECT COUNT(DISTINCT animals.type) FROM animals 
   LEFT JOIN enclosures 
   ON animals.enclosure_id = enclosures.id 
   RIGHT JOIN assignments 
   ON assignments.enclosure_id = enclosures.id
   WHERE assignments.employee_id = 1; -- this line is to get details for a given keeper

-- The number of different keepers who have been assigned to work in a given enclosure:
SELECT COUNT(DISTINCT employees.name) FROM employees
INNER JOIN assignments
ON employees.id = assignments.employee_id
WHERE assignments.enclosure_id = 1;

-- The names of the other animals sharing an enclosure with a given animal: