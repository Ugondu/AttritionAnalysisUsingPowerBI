# Analysing Employee Attrition Using SQL and PowerBI


![image](https://github.com/user-attachments/assets/a1873ce5-399a-4fea-8e5d-bb2257eec3e0)



# Table of Contents

- [Objective](#objective)
- [Data Source](#data-source)
- [Stages](#stages)
- [Design](#design)
  - [Dashboard Template](#dashboard-template)
  - [Tools](#tools)
- [Development](#development)
  - [Pseudocode](#pseudocode)
  - [Data Exploration](#data-exploration)
  - [Data Cleaning](#data-cleaning)
  - [Data Transformation](#data-transformation)
  - [Create SQL View](#create-sql-view)
- [Visualization](#visualization)
  - [Results](#results)
  - [DAX Measures](#dax-measures)
- [Analysis](#analysis)
  - [Findings](#findings)
  - [Insights](#insights)
- [Recommendations](#recommendations)
- [Conclusion](#conclusion)


# Objective

- What is the business problem?

The head of human resources at Emerald Technologies is keen to understand the factors that contribute to attrition rate in the organisation.

- To provide and end to end solution for the end user, We will look at the following factors;

1. How does length of service at organisation impact attrition?
2. What age demographic are most likely to leave?
3. What department is experiencing the highest staff turnover?
4. Does education level impact the rate of attrition?
5. How does income level facilitate employee attrition?
6. Does staff training and assessment impact the rate of employee attrition?


# Data Source

To achieve the aim of ideal solution, the dataset will include the 
- Attrition
- Job Satisfaction
- Monthly Income
- Performance Rating
- Department
- Education
- Gender
- Age
- Length of Service
- Average Training Score
The datasets can be accessed [employee performance](https://github.com/Ugondu/AttritionAnalysisUsingPowerBI/blob/main/Assets/Dataset/Employee_performance%20(1).csv) and [employee test](https://github.com/Ugondu/AttritionAnalysisUsingPowerBI/blob/main/Assets/Dataset/Employee_test%20(1).csv)



# Stages
- Design
- Development
- Visualization
- Analysis

# Design

## Dashboard Template
The dashboard is expected to provide insights for the end user, answering business questions like;

1. How does length of service at organisation impact attrition?
2. What age demographic are most likely to leave?
3. What department is experiencing the highest staff turnover?
4. Does education level impact the rate of attrition?
5. How does income level facilitate employee attrition?
6. Does staff training and assessment impact the rate of employee attrition?

The final dashboard is expected to appear in this format including visuals like;
1. Tree map
2. Score cards
3. Column chart
4. Bar chart
5. Doughnut charts
6. Interactive filter
![image](https://github.com/user-attachments/assets/1437fd98-fdd3-4ed2-8032-264e04ffba50)

## Tools

| Tool | Purpose |
| --- | --- |
| Excel | Exploring the data |
| SQL Server | Cleaning, testing, and analyzing the data |
| Power BI | Visualizing the data via interactive dashboards |
| GitHub | Hosting the project documentation and version control |
| Mokkup AI | Designing a mockup of the dashboard | 

# Development

- An end to end solution will involve the following steps;
1. Get the dataset
2. Explore the dataset using Excel
3. Load the dataset into SQL server
4. Clean and normalize the data with SQL
5. Visualize the cleaned data using Power BI
6. Generate findings based on the insights
7. Write documentation on GitHub
8. Publish and host findings on GitHub

## Data Exploration

The dataset is examined at this stage to check for data input errors, inconsistencies, data type error, bugs, corrupted characters, whitespaces, blanks, and null fields.

- Initial observations
1. Presence of null cells
2. Contains columns not relevant to our analysis
3. Some headers were not descriptive for easy understanding


## Data Cleaning
We aim to refine and normalise the datasets using SQL to ensure it is structured and ready for analysis.

- The steps required to clean our datasets include:

1. Remove irrelevant columns from each dataset
2. Create new columns for better description and classification
3. Drop null and blank fields.

## Data Transformation

```sql
/*
# 1. Create new columns in each table in the database
# 2. Update created columns using information from existing columns
*/

-- 1a. Alter "Attrition" column to "yes" or "No" in Employee Performance table

ALTER TABLE employee_performance
ALTER COLUMN Attrition VARCHAR(5);

-- 2a. Update the column

UPDATE dbo.[Employee_performance ]
SET Attrition = CASE
					        WHEN Attrition = '0' THEN 'No'
					        WHEN Attrition = '1' THEN 'Yes'
				        END;

--- Alter columnns "Age", "Avg_training_score", "length_of_service" to text data type for easier classification.

-- Alter "Age" column

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

-- Updating the training score into bins for better classification

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

```

## Create SQL View

```sql
/*
# 1. create a view to store the combined(joined) tables from the dataset
# 2. select the required columns from the emerald_employee SQL table
*/

-- 1.
CREATE VIEW emeraldemployeeviews AS

-- 2.
SELECT
    EP.employee_id,
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

-- 3.
FROM dbo.[Employee_performance ] AS EP
INNER JOIN dbo.[Employee_test ] AS ET
ON EP.employee_id = ET.employee_id;

```

# Visualization

## Results

The final dashboard details the relationship and how these factors impact attrition

![image](https://github.com/user-attachments/assets/811468ed-2f3e-4b24-8f77-92182f03236f)

## DAX Measures
### 1. Total Employees
```sql
Total Employee = 
VAR CountofEmployee = COUNT(emeraldemployeeviews[employee_id])

Return CountofEmployee

```

### 2. Total Attrition 
```sql
Total Attrition = 
VAR countofAttrition = CALCULATE(COUNTROWS(emeraldemployeeviews) , emeraldemployeeviews[Attrition] = "Yes")

Return countofAttrition
```

### 3. Average Job Satisfaction
```sql
Average Job Satisfaction (Filtered) = 
CALCULATE(
    AVERAGE(emeraldemployeeviews[JobSatisfaction]),
    ALLSELECTED(emeraldemployeeviews[gender])
)
```

# Analysis

## Findings

From the data available, we derived insights based on the following criteria;
1. How does length of service at organisation impact attrition?
2. What age demographic are most likely to leave?
3. What department is experiencing the highest staff turnover?
4. Does education level impact the rate of attrition?
5. How does income level facilitate employee attrition?
6. Does staff training and assessment impact the rate of employee attrition?


#### 1. How does length of service at organisation impact attrition?

| Rank | Length of stay (years) |Count of Attrition |
|------|------------------------|-------------------|
| 1    |    1-6                 | 167               | 
| 2    |    7-12                | 52                |
| 3    |    13-18               | 15                |
| 4    |    19-24               | 2                 |
| 5    |    25-30               | 1                 |

#### 2. What age group are mostly likely to leave?

| Rank | Age group(years)       | Count of Attrition |
|------|------------------------|--------------------|
| 1    | Young Adults 29-37y    | 111                | 
| 2    | Youth 20-28y           | 58                 |
| 3    | Adult 38-46y           | 44                 |
| 4    | Old Adult 47-56y       | 22                 |
| 5    | Senior >56y            | 2                  |

#### 3. What Department is experiencing the highest staff turnover

| Rank | Department             | Count of Attriton |
|------|------------------------|-------------------|
| 1    | Sales & Marketing      | 73                | 
| 2    | Operations             | 55                |
| 3    | Technology             | 37                |
| 4    | Analytics              | 21                |
| 5    | Procurement            | 18                |
| 6    | Finance                | 17                |
| 7    | Legal                  | 6                 | 
| 8    | HR                     | 5                 |
| 9    | R&D                    | 5                 |

#### 4. Does education level impact the rate of attrition?

| Rank | Education              |Percent of Attriton |
|------|------------------------|--------------------|
| 1    | Bachelors              | 71.3               | 
| 2    | Masters and above      | 27.4               |
| 3    | Secondary school       | 1.4                |


#### 5. How does income level facilitate employee attrition?

| Rank | Income Level           |Percent of Attriton |
|------|------------------------|--------------------|
| 1    | Low earners            | 81.2               | 
| 2    | Middle earners         | 15.7               |
| 3    | High earners           | 3.4                |

#### 6. Does staff training and assessment impact the rate of employee attrition?

| Rank | Training score         |Percent of Attriton |
|------|------------------------|--------------------|
| 1    | Average                | 56.5               | 
| 2    | Good                   | 26.0               |
| 3    | Excellent              | 17.5               |



## Insights

From the data available for analysis, it can be deduced that over 70% of staff who have spent between 1 and 7 years in the company have left over the period the data was collated. This can be associated to the high attrition rate uncovered in the sales and marketing. 

The increased staff turn over in Sales and Marketing department (40%) may be linked to the employees not meeting up to the set revenue targets and KPIs agreed with the managers.

Addtionally, there is very high rate of attrition (81%) amongst employees who earn between 1000 and 6000 monthly which is expected as these employees are in constant search for jobs that could offer more. 

Young adults between 29 and 37 years of age make up for over 40% of employees who left the organisation. This could be due to the desire for career progression, better compensation, or work-life balance.

Finally, attrition from low training and assessemnt scores is expected as employees who have performed poorly and has not met the organisation's criteria are often asked to resign or removed from their jobs.

# Recommendations

- To retain the top performing employees, the leadership of company will have to incorporate the following recommendation;

1. Provide clear career paths, competitive compensation, flexible work options, and a supportive work environment that aligns with the needs of the top performing employees.
 
