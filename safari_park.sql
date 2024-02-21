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
    enclosure_id INT REFERENCES enclosures(id)
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

-- The names of the animals in a given enclosure:
    SELECT animals.name FROM animals LEFT JOIN enclosures ON animals.enclosure_id = enclosures.id;

-- The names of the staff working in a given enclosure:
    SELECT DISTINCT(staffs.name) FROM staffs LEFT JOIN assignments ON assignments.employee_id = staffs.id RIGHT JOIN enclosures ON assignments.enclosure_id = enclosures.id;

-- The names of staff working in enclosures which are closed for maintenance:
    SELECT DISTINCT(staffs.name) FROM staffs LEFT JOIN assignments ON assignments.employee_id = staffs.id RIGHT JOIN enclosures ON assignments.enclosure_id = enclosures.id WHERE enclosures.closed_for_maintenance = true;

-- The name of the enclosure where the oldest animal lives:
    SELECT animals.name FROM animals LEFT JOIN enclosures ON animals.enclosure_id = enclosures.id ORDER BY animals.age DESC LIMIT 1;

-- The number of different animal types a given keeper has been assigned to work with:
   SELECT COUNT(animals.type) FROM animals LEFT JOIN enclosures ON animals.enclosure_id = enclosures.id RIGHT JOIN assignments ON assignments.enclosure_id = enclosures.id;