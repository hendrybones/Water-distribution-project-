# Water-distribution-project-SQL Analysis
This project explores **Maji Ndogo’s water services database**. Using SQL, we clean data, update employee records, and analyze water sources and citizen access. The goal is to uncover insights that can guide **data-driven infrastructure improvements**.

---

## Database Setup  
```sql
USE md_water_services;
SHOW TABLES;.

```
## Employee Data Cleaning
1. Generate employee emails
We create a new column and populate emails in the format: firstname.lastname@ndogowater.gov.
```sql
ALTER TABLE employee ADD COLUMN email VARCHAR(255);

UPDATE employee
SET email = CONCAT(
    LOWER(REPLACE(employee_name, ' ', '.')),
    '@ndogowater.gov'
)
WHERE assigned_employee_id >= 0;

SELECT * FROM employee;
```
2. Fix phone numbers

Some phone numbers had trailing spaces, causing length issues.
```sql
UPDATE employee
SET phone_number = RTRIM(phone_number)
WHERE assigned_employee_id >= 0;

SELECT phone_number, LENGTH(phone_number) 
FROM employee;

```
## Employee Distribution
Employees by town:
```sql
SELECT town_name, COUNT(assigned_employee_id) AS Number_of_Employee
FROM employee
GROUP BY town_name
ORDER BY Number_of_Employee DESC;

```
## Top 3 most active field surveyors (from visits table):
```sql
SELECT assigned_employee_id, COUNT(*) AS Number_of_visits
FROM visits
GROUP BY assigned_employee_id
ORDER BY Number_of_visits DESC
LIMIT 3;

```
## Location Analysis
```sql
SELECT town_name, COUNT(*) AS number_of_locations
FROM location
GROUP BY town_name
ORDER BY number_of_locations DESC;
```
## Records per province
```sql
SELECT province_name, COUNT(*) AS number_of_locations
FROM location
GROUP BY province_name
ORDER BY number_of_locations;
```
Insight: Water sources are widely distributed across rural communities, with each province fairly well represented.

```
```
## Records by Location Type
```sql
SELECT location_type, COUNT(*) AS Number_of_Records
FROM location
GROUP BY location_type;

```
# Water Sources Analysis
### Total People Surveyed
```sql
SELECT SUM(number_of_people_served) AS people_surveyed
FROM water_source;

```
## Count Sources by Type
```sql
SELECT type_of_water_source, COUNT(*) AS number_of_sources
FROM water_source
GROUP BY type_of_water_source;

```
## Average People per Source Type
```sql
SELECT type_of_water_source, ROUND(AVG(number_of_people_served),0) AS avg_people_served
FROM water_source
GROUP BY type_of_water_source;
```
## Total People Served by Source Type
```sql
SELECT type_of_water_source, SUM(number_of_people_served) AS total_people_served
FROM water_source
GROUP BY type_of_water_source
ORDER BY total_people_served DESC;

```
## Percentage of Population Served by Source
```sql
SELECT type_of_water_source,
       SUM(number_of_people_served) AS total_people_served,
       ROUND(
         SUM(number_of_people_served) / 
         (SELECT SUM(number_of_people_served) FROM water_source) * 100, 2
       ) AS percentage_served
FROM water_source
GROUP BY type_of_water_source
ORDER BY total_people_served DESC;
```
Insight: Around 31% of households have taps at home, but 45% of these are broken due to infrastructure issues. Wells serve ~18% of the population, but only 28% are clean.
```
```
## Ranking Sources by Usage
```sql
SELECT type_of_water_source,
       SUM(number_of_people_served) AS total_people_served,
       RANK() OVER (ORDER BY SUM(number_of_people_served) DESC) AS source_rank
FROM water_source
GROUP BY type_of_water_source;
```
Shared taps and wells should be prioritized first, as they serve the largest number of people.
```
```
# Queue Analysis
## Survey Duration
```sql
SELECT 
    MIN(time_of_record) AS survey_start,
    MAX(time_of_record) AS survey_end,
    TIMESTAMPDIFF(DAY, MIN(time_of_record), MAX(time_of_record)) AS survey_duration_days
FROM visits;

```
## Average Queue Time (Overall)
```sql
SELECT ROUND(AVG(time_in_queue), 2) AS average_queue_time
FROM visits;
```
##Average Queue Time by Day of the Week
```sql
SELECT DAYNAME(time_of_record) AS day_of_week,
       AVG(time_in_queue) AS average_queue_time
FROM visits
GROUP BY day_of_week;
```
Insight: Queue times vary significantly by day, with weekends showing the longest waiting times.
```
Key Insights

Employees’ data was cleaned and standardized for communication.
Water sources are widespread, but infrastructure reliability is a major issue.
Taps serve the most people but are often broken, making them a high-priority fix.
Queue analysis shows demand peaks on certain days, guiding targeted interventions.




