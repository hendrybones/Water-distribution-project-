# Water-distribution-project-SQL Analysis
This project explores **Maji Ndogo’s water services database**. Using SQL, we clean data, update employee records, and analyze water sources and citizen access. The goal is to uncover insights that can guide **data-driven infrastructure improvements**.

---

## Database Setup  
```sql
USE md_water_services;
SHOW TABLES;.


** Data cleaning **
## Employee Data Cleaning  

### 1. Generate Employee Emails  
We create a new column and populate emails in the format: `firstname.lastname@ndogowater.gov`.  

```sql
ALTER TABLE employee ADD COLUMN email VARCHAR(255);

UPDATE employee
SET email = CONCAT(
    LOWER(REPLACE(employee_name, ' ', '.')),
    '@ndogowater.gov'
)
WHERE assigned_employee_id >= 0;

SELECT * FROM employee;


`---

🔑 Key to keeping sections **separated** in README:  
- Always **close the first SQL block** with triple backticks before starting a new section.  
- Use `---` (horizontal rule) or at least a blank line before the next `##` heading.  

👉 Want me to rewrite your entire README with **each section separated like this** (Database Setup → Employee → Location → Water Sources → Queues)? That way you can paste once and it’s all formatted perfectly.
