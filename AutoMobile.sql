/* AUTOMOBILE DATA CLEANING IN SQL MINI PROJECT


*/





SELECT *
FROM PortfoiloProject..automobile_data

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- INSPECTING THE FUEL TYPE COLUMN



SELECT 
DISTINCT fuel_type
FROM PortfoiloProject..automobile_data


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- INSPECTING THE LENGTH COLUMN



SELECT 
MAX(length) AS Max_Length
FROM PortfoiloProject..automobile_data

SELECT 
MIN(length) AS Max_Length
FROM PortfoiloProject..automobile_data

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- FILL IN MISSING DATA


SELECT *
FROM PortfoiloProject..automobile_data
WHERE num_of_doors IS NULL


UPDATE PortfoiloProject..automobile_data
SET num_of_doors = 'four'
WHERE make ='dodge' 
AND fuel_type ='gas'
AND body_style ='sedan'

UPDATE PortfoiloProject..automobile_data
SET num_of_doors = 'four'
WHERE make ='mazda' 
AND fuel_type ='diesel'
AND body_style ='sedan'

SELECT *
FROM PortfoiloProject..automobile_data
WHERE num_of_doors IS NULL

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- IDENTIFYING POTENTIAL ERRORS

SELECT
DISTINCT num_of_cylinders
FROM PortfoiloProject..automobile_data

UPDATE PortfoiloProject..automobile_data
SET num_of_cylinders = 'two'
WHERE num_of_cylinders ='tow'


--x


SELECT 
MIN(compression_ratio) AS Min_compression
FROM PortfoiloProject..automobile_data

SELECT 
MAX(compression_ratio) AS Max_compression
FROM PortfoiloProject..automobile_data


SELECT 
COUNT(*) AS num_of_rows_to_delete
FROM PortfoiloProject..automobile_data
WHERE compression_ratio = 70

DELETE PortfoiloProject..automobile_data
WHERE compression_ratio = 70


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------



-- ENSUIRING CONSISTENCY


SELECT 
DISTINCT drive_wheels
FROM PortfoiloProject..automobile_data

SELECT 
DISTINCT drive_wheels
FROM PortfoiloProject..automobile_data

SELECT
LEN(drive_wheels) AS Length_String
FROM PortfoiloProject..automobile_data

UPDATE PortfoiloProject..automobile_data
SET drive_wheels = TRIM(drive_wheels)