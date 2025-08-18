# Water-distribution-project-SQL Analysis
This project explores **Maji Ndogo’s water services database**. Using SQL, we clean data, update employee records, and analyze water sources and citizen access. The goal is to uncover insights that can guide **data-driven infrastructure improvements**.

---

## Database Setup  
```sql
USE md_water_services;
SHOW TABLES;
--- 
## Employee Data Cleaning
``` Generate employee emails
We create a new column and populate emails in the format: firstname.lastname@ndogowater.gov.
