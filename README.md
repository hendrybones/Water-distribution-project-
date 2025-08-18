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
