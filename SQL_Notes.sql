------------------------
-- Basic Syntax MySQL --
------------------------

SELECT * FROM table; -- Select all from table name
SELECT * FROM table where fieldname = 'string value' -- Select all from table where field name equal a value
CREATE DATABASE putdatabasename; -- Create database with the name provide
DROP DATABASE putdatabasename; -- Delete database match the name provided BECAREFUL THIS WILL DELETE ALL DATA in that DATABASE ** almost never use**
USE putdatabasename; -- make the current database become active (script run on this particular database)
CREATE TABLE puttablename (putcolumn_name datatype); -- Create the table name and adding column name and its datatype (int, string)
------------------------
ALTER TABLE puttablename
ADD another_column VARCHAR(255); -- Adding column to existing table
------------------------
DROP TABLE puttablename; -- Drop that table completely
------------------------
-- NOT NULL -- will not allow null value in this column
-- id will be primary key, auto increment make the index never be the same for each record
-- PRIMARY KEY (id) --- making id column a primary key
CREATE TABLE bands (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);
-----------------------
-- to reference another table aka foreign key
CREATE TABLE albums (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    release_year INT,
    band_id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (band_id) REFERENCES bands(id)
);
-----------------------
-- insert data into table
INSERT INTO puttablename (column_name)
VALUES ('value to put into that column');

-- insert multiple value into table
INSERT INTO puttablename (column_name)
VALUES ('value1'), ('value2'), ('value3');

-----------------------
SELECT column_name from table_name; -- select on specific column
Select column_nmae from table_name LIMIT 2; -- select first 2 records

-- Select Column and rename the column name
SELECT id AS 'ID', name AS 'Band Name'
FROM bands;

-----------------------
-- order by
SELECT * FROM Bands ORDER BY name DESC; -- DESC make it descending, if remove DESC it's default to ASC or Ascending

-----------------------
-- insert value into multiple columns
SELECT * FROM Bands ORDER BY name DESC

INSERT INTO albums (name, release_year, band_id)
VALUE   ('The Number of the Beasts', 1985, 1),
        ('Power Slave', 1984, 1),
        ('Nightmare', 2018, 2),
        ('Nightmare', 2010, 3),
        ('Test Album', NULL, 3);
------------------------
-- Select unique value from table

SELECT DISTINCT putcolumn_name FROM puttablename;

-- Update value in column

UPDATE puttablename
SET column_name = value_to_update -- if it's string make sure to put '' ALWAYS USE WHERE CLAUSE
WHERE id = ID_NUMBER; -- make sure that this ID match the record ID you want to update. Without this ID it will update all records so BECAREFUL!!!!

-- LIKE, OR, AND where clause
SELECT * FROM puttablename
WHERE putcolumn_name LIKE '%er%' OR putcolumn_name = 'value' AND putcolumn_name = 'value'; --% start with anything until er is found and anything after er is found, OR will test both where clause
--------------------------

-- BETWEEN 
SELECT * FROM puttablename
WHERE putcolumn_name BETWEEN value1 AND value2;

-- Check NULL
SELECT * FROM puttablename
WHERE putcolumn_name IS NULL;

-- DELETE record
DELETE FROM puttablename WHERE id = id_value; -- ALWAYS NEED WHERE CLAUSE and ID link to specific records!!

-- JOIN statement
SELECT * FROM bands
JOIN albums ON bands.id = albums.band_ID; 

-- INNER JOIN -- ** Only return value when both table can join
SELECT * FROM bands
INNER JOIN albums ON bands.id = albums.band_ID; 

-- LEFT JOIN -- ** Will show everything from left table + records that can be join
-- RIGHT JOIN -- ** Will show everything from right table + records that can be join ** Not use as much.

-------------------------
---AGGREGRATE FUNCTION---
-------------------------
-- Sum -- SUM()
SELECT SUM(release_year) FROM albums;

-- Average function -- AVG()
SELECT AVG(release_year) FROM albums;

-- Count -- COUNT() with GROUP BY
SELECT band_id, COUNT(band_id) FROM albums
GROUP BY band_id;
-- ** To make the data more readable **
SELECT b.name AS band_name, COUNT(a.id) AS num_albums
FROM bands AS b
LEFT JOIN albums AS a on b.id = a.band_id
GROUP BY b.id;
-- output of query above look like this --
------------------------------------------
------band_name----|-----num_albums-------
-------------------|----------------------
--Iron Maiden------|---------2------------
--Deuce------------|---------1------------
--Avenged Servant--|---------1------------
--Ankor------------|---------1------------

------------------------------------------------------------------------------------------------------------
--------------------------------------------------
---subquery with CTE (Common Table Expressions)---
--------------------------------------------------
-- we want to average number of orders per customer per country

-- original subquery----

SELECT shipcountry, AVG(num_orders) FROM
    (SELECT customerid, shipcountry, count(*) as num_orders
    FROM orders
    GROUP BY 1,2) sub
GROUP BY 1

--- with CTE---

WITH cte_orders AS (
    SELECT customerid, shipcountry, count(*) as num_orders
    FROM orders
    GROUP BY 1,2) 
SELECT shipcountry, AVG(num_orders)
FROM cte_orders
GROUP BY 1
------------------------------------------------------------------------------------------------------------
-- to join CTE---

WITH cte_orders AS (
    SELECT customerid, shipcountry, count(*) as num_orders
    FROM orders
    GROUP BY 1,2), 

    cte_customers AS (
    SELECT customerid, Companyname
    FROM customers
    )
SELECT shipcountry, AVG(num_orders)
FROM cte_orders
JOIN cte customers USING(customerid)
GROUP BY 1