USE Project;

-- Data Exploration
SELECT *
FROM Project..amenities;

--SELECT *
--FROM Project..market_analysis;

-- Noticing the unified_id is not the same structure for both;

--DROP TABLE Project..market_analysis;

-- Finding the table with the same unified_id structure;

SELECT *
FROM Project..market_analysis_2019;

-- Finding out how many properties have a hot_tub
SELECT COUNT(unified_id) AS hot_tub_properties
FROM Project..amenities
WHERE hot_tub = 1;

-- Finding out the average number of guests
SELECT AVG(CAST(guests AS INT)) AS average_guests_no
FROM Project..market_analysis_2019;

-- Fixing the data type

ALTER TABLE Project..market_analysis_2019
ALTER COLUMN occupancy DECIMAL(10, 10);

-- Top 10 best performing properties

SELECT TOP 10 *
FROM Project..market_analysis_2019
ORDER BY revenue DESC;

-- Select those properties that have both a hot tub and a pool

SELECT unified_id
FROM Project..amenities
WHERE hot_tub = 1 AND pool = 1;

-- THE REVENUE AND OCCUPANCY RATE OF PROPERTIES IN BIG BEAR LAKE WHICH HAVE A POOL
SELECT m.unified_id, m.pool, n.city, n.revenue, n.occupancy
FROM Project..amenities m
JOIN Project..market_analysis_2019 n
ON m.unified_id = n.unified_id 
WHERE m.pool = 1 AND city LIKE '%Bear%'
ORDER BY n.occupancy DESC;

--TOP 10 BEST PERFORMERS FROM BIG BEAR LAKE WITH A POOL

SELECT TOP 10 m.unified_id, m.pool, n.city, n.revenue, n.nightly_rate
FROM Project..amenities m
JOIN Project..market_analysis_2019 n
ON m.unified_id = n.unified_id 
WHERE n.city LIKE '%Bear%' AND m.pool = 1
ORDER BY n.revenue DESC;


