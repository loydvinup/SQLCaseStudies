create database casestudy2
use  casestudy2


CREATE TABLE location (
    Location_ID INT PRIMARY KEY,
    City VARCHAR(255)
);


CREATE TABLE department (
    Department_Id INT PRIMARY KEY,
    Name VARCHAR(255),
    Location_Id INT,
    FOREIGN KEY (Location_Id) REFERENCES location(Location_ID)
);


CREATE TABLE job (
    Job_ID INT PRIMARY KEY,
    Designation VARCHAR(255)
);


CREATE TABLE employee (
    Employee_Id INT PRIMARY KEY,
    Last_Name VARCHAR(255),
    First_Name VARCHAR(255),
    Middle_Name VARCHAR(255),
    Job_Id INT,
    Hire_Date DATE,
    Salary DECIMAL(10, 2),
    Commission DECIMAL(10, 2),
    Department_Id INT,
    FOREIGN KEY (Job_Id) REFERENCES job(Job_ID),
    FOREIGN KEY (Department_Id) REFERENCES department(Department_Id)
);



INSERT INTO location (Location_ID, City) VALUES (122, 'New York');
INSERT INTO location (Location_ID, City) VALUES (123, 'Dallas');
INSERT INTO location (Location_ID, City) VALUES (124, 'Chicago');
INSERT INTO location (Location_ID, City) VALUES (167, 'Boston');


INSERT INTO department (Department_Id, Name, Location_Id) VALUES (10, 'Accounting', 122);
INSERT INTO department (Department_Id, Name, Location_Id) VALUES (20, 'Sales', 124);
INSERT INTO department (Department_Id, Name, Location_Id) VALUES (30, 'Research', 123);
INSERT INTO department (Department_Id, Name, Location_Id) VALUES (40, 'Operations', 167);


INSERT INTO job (Job_ID, Designation) VALUES (667, 'Clerk');
INSERT INTO job (Job_ID, Designation) VALUES (668, 'Staff');
INSERT INTO job (Job_ID, Designation) VALUES (669, 'Analyst');
INSERT INTO job (Job_ID, Designation) VALUES (670, 'Sales Person');
INSERT INTO job (Job_ID, Designation) VALUES (671, 'Manager');
INSERT INTO job (Job_ID, Designation) VALUES (672, 'President');


INSERT INTO employee (Employee_Id, Last_Name, First_Name, Middle_Name, Job_Id, Hire_Date, Salary, Commission, Department_Id)
VALUES 
(7369, 'Smith', 'John', 'Q', 667, '1984-12-17', 800, NULL, 20 ),
(7999, 'Allen', 'Kevin', 'J', 670, '1985-02-20', 1600, 300, 30 ),
(30030, 'Doyle', 'Jean', 'K', 671, '1985-04-04', 2850, NULL, 30 ),
(30031, 'Dennis', 'Lynn', 'S', 671, '1985-05-15', 2750, NULL, 30 ),
(30032, 'Baker', 'Leslie', 'D', 671, '1985-06-10', 2200, NULL, 40 ),
(40752, 'Wark', 'Cynthia', 'D', 670, '1985-02-22', 1250, 50, 30);



--Simple Queries:
--1. List all the employee details. 
SELECT * FROM employee;




--2. List all the department details.

SELECT * FROM department;

--3. List all job details. 
SELECT * FROM job;



--4. List all the locations. 
SELECT * FROM location;


--5. List out the First Name, Last Name, Salary, Commission for allEmployees.
SELECT First_Name, Last_Name, Salary, Commission FROM employee;




--6. List out the Employee ID, Last Name, Department ID for all employeesandalias
--Employee ID as "ID of the Employee", Last Name as "Name of theEmployee", Department ID as "Dep_id".
SELECT Employee_Id AS "ID of the Employee", Last_Name AS "Name of the Employee", Department_Id AS "Dep_id" FROM employee;



--7. List out the annual salary of the employees with their names only.
SELECT First_Name, Last_Name, Salary*12 AS "Annual Salary" FROM employee;




--WHERE Condition:
--1. List the details about "Smith". 

SELECT * FROM employee
WHERE Last_Name = 'Smith';

--2. List out the employees who are working in department 20. 
SELECT * FROM employee
WHERE Department_Id = 20;

--3. List out the employees who are earning salaries between 3000and4500. 
SELECT * FROM employee
WHERE Salary BETWEEN 3000 AND 4500;

--4. List out the employees who are working in department 10 or 20. 
SELECT * FROM employee
WHERE Department_Id IN (10, 20);

--5. Find out the employees who are not working in department 10 or 30.
SELECT * FROM employee
WHERE Department_Id NOT IN (10, 30);

--6. List out the employees whose name starts with 'S'.
SELECT * FROM employee
WHERE First_Name LIKE 'S%';

--7. List out the employees whose name starts with 'S' and ends with'H'.
SELECT * FROM employee
WHERE First_Name LIKE 'S%H';

--8. List out the employees whose name length is 4 and start with 'S'.
SELECT * FROM employee
WHERE First_Name LIKE 'S___'; -- Four underscores represent four characters

--9. List out employees who are working in department 10 and drawsalariesmorethan 3500. 
SELECT * FROM employee
WHERE Department_Id = 10 AND Salary > 3500;

--10. List out the employees who are not receiving commission.

SELECT * FROM employee
WHERE Commission IS NULL;



--ORDER BY Clause:
--1. List out the Employee ID and Last Name in ascending order basedontheEmployee ID.
SELECT Employee_Id, Last_Name 
FROM employee
ORDER BY Employee_Id ASC;


--2. List out the Employee ID and Name in descending order based onsalary. 
SELECT Employee_Id, CONCAT(First_Name, ' ', Last_Name) AS Name
FROM employee
ORDER BY Salary DESC;

--3. List out the employee details according to their Last Name in ascending-order.
SELECT *
FROM employee
ORDER BY Last_Name ASC;

--4. List out the employee details according to their Last Name in ascendingorder and then Department ID in descending order
SELECT *
FROM employee
ORDER BY Last_Name ASC, Department_Id DESC;


--GROUP BY and HAVING Clause:
--1. How many employees are in different departments in theorganization?
SELECT Employee_Id, Last_Name
FROM employee
ORDER BY Employee_Id ASC;


--2. List out the department wise maximum salary, minimumsalary andaverage salary of the employees. 
SELECT Department_Id, 
       MAX(Salary) AS Max_Salary,
       MIN(Salary) AS Min_Salary,
       AVG(Salary) AS Avg_Salary
FROM employee
GROUP BY Department_Id;


--3. List out the job wise maximum salary, minimum salary and averagesalary of the employees.
SELECT Job_Id, 
       MAX(Salary) AS Max_Salary,
       MIN(Salary) AS Min_Salary,
       AVG(Salary) AS Avg_Salary
FROM employee
GROUP BY Job_Id;


--4. List out the number of employees who joined each month in ascendingorder.
SELECT 
    FORMAT(Hire_Date, 'yyyy-MM') AS Join_Month, 
    COUNT(*) AS Num_Employees
FROM employee
GROUP BY FORMAT(Hire_Date, 'yyyy-MM')
ORDER BY Join_Month ASC;

--5. List out the number of employees for each month and year in
--ascending order based on the year and month. 
SELECT 
    FORMAT(Hire_Date, 'yyyy-MM') AS Join_Month, 
    COUNT(*) AS Num_Employees
FROM employee
GROUP BY FORMAT(Hire_Date, 'yyyy-MM')
ORDER BY Join_Month ASC;



--6. List out the Department ID having at least four employees.
SELECT Department_Id, COUNT(*) AS Num_Employees
FROM employee
GROUP BY Department_Id
HAVING COUNT(*) >= 4;



--7. How many employees joined in the month of January?
SELECT COUNT(*) AS Num_Joined_In_January
FROM employee
WHERE MONTH(Hire_Date) = 1;


--8. How many employees joined in the month of January orSeptember?
SELECT COUNT(*) AS Num_Joined_In_January_Or_September
FROM employee
WHERE MONTH(Hire_Date) IN (1, 9);


--9. How many employees joined in 1985?
SELECT COUNT(*) AS Num_Joined_In_1985
FROM employee
WHERE YEAR(Hire_Date) = 1985;


--10. How many employees joined each month in 1985?
SELECT MONTH(Hire_Date) AS Join_Month, COUNT(*) AS Num_Employees
FROM employee
WHERE YEAR(Hire_Date) = 1985
GROUP BY MONTH(Hire_Date)
ORDER BY Join_Month;


--11. How many employees joined in March 1985?
 SELECT COUNT(*) AS Num_Joined_In_March_1985
FROM employee
WHERE MONTH(Hire_Date) = 3
  AND YEAR(Hire_Date) = 1985;


--12. Which is the Department ID having greater than or equal to 3 employeesjoining in April 1985?
SELECT Department_Id
FROM employee
WHERE MONTH(Hire_Date) = 4
  AND YEAR(Hire_Date) = 1985
GROUP BY Department_Id
HAVING COUNT(*) >= 3;

--Joins:
--1. List out employees with their department names.
SELECT e.*, d.Name as Department_Name
FROM employee e
JOIN department d ON e.Department_Id = d.Department_Id;

--2. Display employees with their designations. 
SELECT e.*, j.Designation
FROM employee e
JOIN job j ON e.Job_Id = j.Job_Id;

--3. Display the employees with their department names and regional groups.
SELECT e.*, d.Name as Department_Name, l.City as Regional_Group
FROM employee e
JOIN department d ON e.Department_Id = d.Department_Id
JOIN location l ON d.Location_Id = l.Location_ID;

--4. How many employees are working in different departments? Displaywithdepartment names. 
SELECT d.Name as Department_Name, COUNT(e.Employee_Id) as Num_Employees
FROM department d
JOIN employee e ON d.Department_Id = e.Department_Id
GROUP BY d.Name;

--5. How many employees are working in the sales department?
SELECT COUNT(e.Employee_Id) as Num_Sales_Employees
FROM department d
JOIN employee e ON d.Department_Id = e.Department_Id
WHERE d.Name = 'Sales';

--6. Which is the department having greater than or equal to 5
--employees? Display the department names in ascending
--order. 
SELECT d.Name as Department_Name, COUNT(e.Employee_Id) as Num_Employees
FROM department d
JOIN employee e ON d.Department_Id = e.Department_Id
GROUP BY d.Name
HAVING COUNT(e.Employee_Id) >= 5
ORDER BY d.Name ASC;

--7. How many jobs are there in the organization? Display with designations.
SELECT *
FROM job;

--8. How many employees are working in "New York"?
SELECT COUNT(e.Employee_Id) as Num_Employees_In_New_York
FROM employee e
JOIN department d ON e.Department_Id = d.Department_Id
JOIN location l ON d.Location_Id = l.Location_ID
WHERE l.City = 'New York';

--9. Display the employee details with salary grades. Use conditional statementtocreate a grade column.
SELECT 
    e.*, 
    CASE 
        WHEN Salary >= 5000 THEN 'A'
        WHEN Salary >= 3000 THEN 'B'
        ELSE 'C'
    END as Salary_Grade
FROM employee e;


--10. List out the number of employees grade wise. Use conditional statementtocreate a grade column. 

SELECT 
    CASE 
        WHEN Salary >= 5000 THEN 'A'
        WHEN Salary >= 3000 THEN 'B'
        ELSE 'C'
    END as Salary_Grade,
    COUNT(*) as Num_Employees
FROM employee
GROUP BY 
    CASE 
        WHEN Salary >= 5000 THEN 'A'
        WHEN Salary >= 3000 THEN 'B'
        ELSE 'C'
    END;

--11.Display the employee salary grades and the number of employees
--between 2000 to 5000 range of salary. 

SELECT 
    CASE 
        WHEN Salary >= 5000 THEN 'A'
        WHEN Salary >= 3000 THEN 'B'
        ELSE 'C'
    END as Salary_Grade,
    COUNT(*) as Num_Employees
FROM employee
WHERE Salary BETWEEN 2000 AND 5000
GROUP BY 
    CASE 
        WHEN Salary >= 5000 THEN 'A'
        WHEN Salary >= 3000 THEN 'B'
        ELSE 'C'
    END;


--12. Display all employees in sales or operation departments.
SELECT e.*, d.Name as Department_Name
FROM employee e
JOIN department d ON e.Department_Id = d.Department_Id
WHERE d.Name IN ('Sales', 'Operations');




--SET Operators:
--1. List out the distinct jobs in sales and accounting departments.
SELECT j.Designation
FROM job j
JOIN employee e ON j.Job_ID = e.Job_ID
JOIN department d ON e.Department_Id = d.Department_Id
WHERE d.Name IN ('Sales', 'Accounting')
GROUP BY j.Designation;


--2. List out all the jobs in sales and accounting departments.
SELECT DISTINCT j.Designation
FROM job j
JOIN employee e ON j.Job_ID = e.Job_ID
JOIN department d ON e.Department_Id = d.Department_Id
WHERE d.Name IN ('Sales', 'Accounting');

--3. List out the common jobs in research and accounting
--departments in ascending order
SELECT j.Designation
FROM job j
JOIN employee e ON j.Job_ID = e.Job_ID
JOIN department d ON e.Department_Id = d.Department_Id
WHERE d.Name = 'Research'
INTERSECT
SELECT j.Designation
FROM job j
JOIN employee e ON j.Job_ID = e.Job_ID
JOIN department d ON e.Department_Id = d.Department_Id
WHERE d.Name = 'Accounting'
ORDER BY j.Designation ASC;


--Subqueries:
--1. Display the employees list who got the maximum salary.
SELECT *
FROM employee
WHERE Salary = (SELECT MAX(Salary) FROM employee);



--2. Display the employees who are working in the sales department.
SELECT *
FROM employee
WHERE Department_Id = (SELECT Department_Id FROM department WHERE Name = 'Sales');


--3. Display the employees who are working as 'Clerk'.

SELECT *
FROM employee
WHERE Job_Id = (SELECT Job_Id FROM job WHERE Designation = 'Clerk');

--4. Display the list of employees who are living in "New York".


SELECT *
FROM employee
WHERE Department_Id IN (SELECT Department_Id FROM department WHERE Location_Id = (SELECT Location_Id FROM location WHERE City = 'New York'));

--5. Find out the number of employees working in the sales department.

SELECT COUNT(*)
FROM employee
WHERE Department_Id = (SELECT Department_Id FROM department WHERE Name = 'Sales');

--6. Update the salaries of employees who are working as clerks on thebasisof
--10%. 
UPDATE employee
SET Salary = Salary * 1.10
WHERE Job_Id = (SELECT Job_Id FROM job WHERE Designation = 'Clerk');

--7. Delete the employees who are working in the accounting department. 

DELETE FROM employee
WHERE Department_Id = (SELECT Department_Id FROM department WHERE Name = 'Accounting');

--8. Display the second highest salary drawing employee details.
SELECT TOP 1 *
FROM employee
WHERE Salary < (SELECT MAX(Salary) FROM employee)
ORDER BY Salary DESC;

--9. Display the nth highest salary drawing employee details.
DECLARE @N INT = 3; -- Replace with the desired N value

SELECT TOP 1 *
FROM (
    SELECT TOP (@N) *
    FROM employee
    ORDER BY Salary DESC
) AS NthHighestSalary
ORDER BY Salary ASC;

--10. List out the employees who earn more than every employee in department 30.
SELECT *
FROM employee
WHERE Salary > ALL (SELECT Salary FROM employee WHERE Department_Id = 30);

--11. List out the employees who earn more than the lowest salary in
--department.Find out whose department has no employees.

SELECT *
FROM employee e
WHERE Salary > (SELECT MIN(Salary) FROM employee WHERE Department_Id = e.Department_Id);

SELECT *
FROM department d
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE Department_Id = d.Department_Id);

--12. Find out which department has no employees.
SELECT *
FROM department d
WHERE NOT EXISTS (SELECT 1 FROM employee WHERE Department_Id = d.Department_Id);

--13. Find out the employees who earn greater than the average salary for
--their  department
SELECT *
FROM employee e
WHERE Salary > (SELECT AVG(Salary) FROM employee WHERE Department_Id = e.Department_Id);
