# Water-distribution-project-SQL Analysis
This project explores **Maji Ndogo’s water services database**. Using SQL, we clean data, update employee records, and analyze water sources and citizen access. The goal is to uncover insights that can guide **data-driven infrastructure improvements**.

---

## Database Setup  
```sql
USE md_water_services;
SHOW TABLES;.

---
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

