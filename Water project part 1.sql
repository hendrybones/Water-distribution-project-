/* Select the database to use */
USE md_water_services;

-- Lets list all the tables in the database 
SHOW tables ;
-- Updating the database with email address
SELECT  * From  employee;

-- WE first remove space between First and last nameb and ,and make it lower case
SELECT LOWER(REPLACE(employee_name, ' ','.'))
FROM employee;

-- I want to create a separate column called email from emaployee name
-- Step 1 add a new column employee 
ALTER TABLE employee
Add column email varchar(255);

-- Populate the email column 
UPDATE employee
set email = CONCAT(LOWER(REPLACE(employee_name, ' ', '.')), '@ndogowater.gov')
WHERE assigned_employee_id >=0;

-- Check if the changes have been updated
SELECT  * From  employee;

-- The phone number should be 12 characters. First we check the length of the character
SELECT length(phone_number)
FROM employee;

-- This is giving us 13 chacters. This is because of the space at the end and it will hinder us from sending automatic messages
-- However we trim the phone number we us RTRIM function as it remove any trailling space at the end
SELECT phone_number,rtrim(phone_number)
from employee;

-- The we update the coloumn permanately
UPDATE  employee
SET phone_number=rtrim(phone_number)
WHERE assigned_employee_id >=0;

-- Use the employee table to count how many of our employees live in each town.
SELECT town_name, COUNT( assigned_employee_id) as Number_of_Employee
FROM employee
group by town_name
order by Number_of_Employee desc;

-- Lets get Top 3 field survior with the most visist

SELECT * FROM location;
SELECT * FROM visits;
-- this applies in the visits table
SELECT assigned_employee_id, COUNT(assigned_employee_id) AS Number_of_visists
FROM visits
group by assigned_employee_id
order by Number_of_visists desc
LIMIT 3;

-- Create a query that counts the number of records per town 

SELECT 
    town_name,
    COUNT(*) AS number_of_locations
FROM location
GROUP BY town_name
ORDER BY number_of_locations DESC;

-- Count the records per province
SELECT province_name, COUNT(*) AS number_of_locations
FROM location
GROUP BY province_name 
ORDER BY number_of_locations;

/* From this table, it's pretty clear that most of the water sources in the survey are situated in small rural communities, scattered across Maji Ndogo.
If we count the records for each province, most of them have a similar number of sources, so every province is well-represented in the survey. */

SELECT province_name,town_name,
	COUNT(town_name) as records_per_town
FROM location
GROUP BY province_name, town_name
order by province_name,records_per_town desc;

-- Finally, look at the number of records for each location type
SELECT location_type, COUNT(*) AS Number_of_Records
FROM location
GROUP BY location_type;

-- Lets have  a look at water source table 
Select * from water_source;
-- . How many people did we survey in total?
SELECT SUM(number_of_people_served) As people_surveyed
FROM water_source;

-- How many wells, taps and rivers are there? We count location type
SELECT type_of_water_source,
	COUNT(*) AS number_of_sources
FROM water_source
GROUP BY type_of_water_source;

-- What is the average number of people that are served by each water source?
SELECT type_of_water_source, round(AVG(number_of_people_served),0) as Average_people_Served
FROM water_source
GROUP BY type_of_water_source;

-- Now let’s calculate the total number of people served by each type of water source in total.
SELECT type_of_water_source,SUM(number_of_people_served) AS Total_Number_of_People_Served
FROM water_source
GROUP BY type_of_water_source
order by Total_Number_of_People_Served desc;

-- Lets get the percentage of people served 
SELECT type_of_water_source,SUM(number_of_people_served) AS Total_Number_of_People_Served,
	round((SUM(number_of_people_served) / (SELECT SUM(number_of_people_served) FROM water_source) * 100),2 )AS Percentage_Served
FROM water_source
GROUP BY type_of_water_source
order by Total_Number_of_People_Served desc;

/* By adding tap_in_home and tap_in_home_broken together, we see that 31% of people have water infrastructure installed in their homes, but 45%
(14/31) of these taps are not working! This isn't the tap itself that is broken, but rather the infrastructure like treatment plants, reservoirs, pipes, and
pumps that serve these homes that are broken.
18% of people are using wells. But only 4916 out of 17383 are clean = 28% (from last week) */

-- let's write a query that ranks each type of source based on how many people in total use it
SELECT 
    type_of_water_source,
    SUM(number_of_people_served) AS total_people_served,
    RANK() OVER (ORDER BY SUM(number_of_people_served) DESC) AS source_rank
FROM water_source
GROUP BY type_of_water_source;
-- Order final output by rank or total served → so you see the most urgent sources at the top.

--  How long did the survey take?
SELECT * FROM visits;
-- We first take the last  record time - first time
SELECT 
	max(time_of_record) as survey_end,
	min(time_of_record) As survey_start,
    TIMESTAMPDIFF(Day, MIN(time_of_record),MAX(time_of_record))AS survey_duration_days
FROM visits;

-- What is the average total queue time for water?
SELECT ROUND(AVG(time_in_queue),2) as average_queue_time
FROM visits;

-- What is the average queue time on different days?
SELECT dayname(time_of_record) as day_of_week, AVG(time_in_queue) as average_queue_time
FROM visits
GROUP BY day_of_week

--  