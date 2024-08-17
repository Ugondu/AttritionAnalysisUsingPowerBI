CREATE DATABASE emerald_technologies_db;

USE emerald_technologies_db;

/*
# 1. Data cleaning
# 2. Data Transformation
*/


-- 1. DATA CLEANING FOR EMPLOYEE PERFORMANCE TABLE

SELECT TOP (100) *
FROM dbo.[Employee_performance ];

-- a. To check for null values
SELECT *
FROM dbo.[Employee_performance ]
WHERE Attrition IS NULL;

-- b. Check for duplicates

SELECT *
FROM dbo.[Employee_performance ]
WHERE employee_id IN (
    SELECT employee_id
    FROM dbo.[Employee_performance ]
    GROUP BY employee_id
    HAVING COUNT(*) > 1
);

-- C. Query the data types in the employee performance table

SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    NUMERIC_PRECISION,
    NUMERIC_SCALE
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'employee_performance';

-- 2. Dataset Transformation

-- a. Alter attrition column to " 1 = Yes" and "0 = No"

ALTER TABLE employee_performance
ALTER COLUMN Attrition VARCHAR(5);

-- Update the column

UPDATE dbo.[Employee_performance ]
SET Attrition = CASE
					WHEN Attrition = '0' THEN 'No'
					WHEN Attrition = '1' THEN 'Yes'
				END;

SELECT TOP (100) *
FROM dbo.[Employee_performance ];


/*
EXPLORATORY ANALYSIS FOR EMPLOYEE TEST TABLE
*/

-- 1. Data Cleaning

SELECT TOP (100) *
FROM dbo.[Employee_test ];

-- a. To check for null values
SELECT *
FROM dbo.[Employee_test ]
WHERE region IS NULL;

-- b. Check for duplicates

SELECT *
FROM dbo.[Employee_test ]
WHERE employee_id IN (
    SELECT employee_id
    FROM dbo.[Employee_test ]
    GROUP BY employee_id
    HAVING COUNT(*) > 1
);

-- 2. Dataset Transformation

-- Update the columns "Age" and "Average training score"

SELECT MAX(AGE) AS MAX_AGE, MIN(AGE) AS MIN_AGE
FROM dbo.[Employee_test ];

SELECT MAX(avg_training_score) AS MAX_SCORE, MIN(avg_training_score) AS MIN_SCORE
FROM dbo.[Employee_test ];

-- Updating the Age column to agegroup for better classification 
ALTER TABLE employee_test
ALTER COLUMN age VARCHAR(20);

UPDATE dbo.[Employee_test ]
SET age = CASE
			WHEN age BETWEEN 20 AND 28 THEN 'Youth(20-28y)'
			WHEN age BETWEEN 29 AND 37 THEN 'Young Adult(29-37y)'
			WHEN age BETWEEN 38 AND 46 THEN 'Adult(38-46y)'
			WHEN age BETWEEN 47 AND 56 THEN 'Old Adult(47-56y)'
			ELSE 'Senior(>56y)'
		  END;
--- Updating the training score into bins for better classification
ALTER TABLE employee_test
ALTER COLUMN avg_training_score VARCHAR(30);

UPDATE dbo.[Employee_test ]
SET avg_training_score = CASE
							WHEN avg_training_score BETWEEN 43 AND 61 THEN 'Average(43-61)'
							WHEN avg_training_score BETWEEN 62 AND 80 THEN 'Good(62-80)'
							ELSE 'Excellent(>80)'
						 END;

-- Classify the length of stay into bins
ALTER TABLE employee_test
ALTER COLUMN length_of_service VARCHAR(30);

 UPDATE dbo.[Employee_test ]
SET length_of_service = CASE 
							WHEN length_of_service BETWEEN 1 AND 6 THEN '1-6 years'
							WHEN length_of_service BETWEEN 7 AND 12 THEN '7-12 years'
							WHEN length_of_service BETWEEN 13 AND 18 THEN '13-18 years'
							WHEN length_of_service BETWEEN 19 AND 24 THEN '19-24 years'
							WHEN length_of_service BETWEEN 25 AND 30 THEN '25-30 years'
							ELSE '31+ years'
						END;

-- Query the data types in the employee performance table

SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    NUMERIC_PRECISION,
    NUMERIC_SCALE
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'employee_test';

SELECT top(100) * 
FROM dbo.[Employee_test ];

-- CREATE VIEWS FOR POERBI VISUALIZATION

CREATE VIEW emeraldemployeeviews AS

SELECT EP.employee_id,
    EP.Attrition,
    EP.JobSatisfaction,
    EP.MonthlyIncome,
    EP.PerformanceRating,
    ET.department,
    ET.region,
    ET.education,
    ET.gender,
    ET.recruitment_channel,
    ET.no_of_trainings,
    ET.age,
    ET.length_of_service,
    ET.awards_won,
    ET.avg_training_score
FROM dbo.[Employee_performance ] AS EP
INNER JOIN dbo.[Employee_test ] AS ET
ON EP.employee_id = ET.employee_id;


-- Verify views table

SELECT TOP (100) *
FROM DBO.emeraldemployeeviews;

SELECT Min(monthlyincome)
from emeraldemployeeviews;

-- Update views to include classification of monthly income

ALTER VIEW emeraldemployeeviews AS

SELECT EP.employee_id,
    EP.Attrition,
    EP.JobSatisfaction,
    CASE 
        WHEN EP.MonthlyIncome BETWEEN 1009 AND 7339 THEN 'Low'
        WHEN EP.MonthlyIncome BETWEEN 7340 AND 13670 THEN 'Middle'
        ELSE 'Very High'
    END AS MonthlyIncome,
    EP.PerformanceRating,
    ET.department,
    ET.region,
    ET.education,
    ET.gender,
    ET.recruitment_channel,
    ET.no_of_trainings,
    ET.age,
    ET.length_of_service,
    ET.awards_won,
    ET.avg_training_score
FROM dbo.[Employee_performance ] AS EP
INNER JOIN dbo.[Employee_test ] AS ET
ON EP.employee_id = ET.employee_id;

	