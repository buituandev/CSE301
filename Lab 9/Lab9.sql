use humanresources;

-- II
-- 1. Check constraint to value of gender in “Nam” or “Nu”.
alter table employees
add CONSTRAINT check_gender check(GENDER = 'Nam' or gender = 'Nu');

-- 2. Check constraint to value of salary > 0
alter table employees
add CONSTRAINT check_salary check(SALARY>0);

-- 3. Check constraint to value of relationship in Relative table in “Vo chong”, “Con trai”, “Con
-- gai”, “Me ruot”, “Cha ruot”.
alter table relative
add CONSTRAINT check_relationship check(RELATIONSHIP in ('Vo chong','Con trai','Con gai','Me ruot','Cha ruot'));

-- III
-- 1. Look for employees with salaries above 25,000 in room 4 or employees with salaries above
-- 30,000 in room 5.
select *
from employees
where (salary > 25000 and DEPARTMENTID = 4) or (salary > 30000 and DEPARTMENTID = 5);

-- 2. Provide full names of employees in HCM city
select concat(FIRSTNAME,' ',MIDDLENAME,' ',LASTNAME) as full_name
from employees
where address like '%HCM';

-- 3. Indicate the date of birth of Dinh Ba Tien staff.
select DATEOFBIRTH
from employees
where LASTNAME = 'Dinh' and MIDDLENAME='Ba' and FIRSTNAME='Tien';

-- 4. The names of the employees of Room 5 are involved in the "San pham X" project and this
-- employee is directly managed by "Nguyen Thanh Tung".
select e.firstname
from employees e
join assignment a on a.EMPLOYEEID = e.EMPLOYEEID
join projects p on p.PROJECTID = a.PROJECTID
join employees ee on ee.EMPLOYEEID = e.MANAGERID
where p.PROJECTNAME='San pham X' and e.DEPARTMENTID = 5 AND ee.LASTNAME = 'Nguyen' and ee.MIDDLENAME='Thanh'and ee.FIRSTNAME='Tung';

-- 5. Find the names of department heads of each department.
select firstname from employees e
join department on e.EMPLOYEEID = department.MANAGERID;

-- 6. Find projectID, projectName, projectAddress, departmentID, departmentName,
-- managerID, date0fEmployment.
select p.*, d.* from projects p
join department d on d.DEPARTMENTID = p.DEPARTMENTID;

-- 7. Find the names of female employees and their relatives.
select e.FIRSTNAME, r.RELATIONSHIP
from employees e
join relative r on r.EMPLOYEEID = e.EMPLOYEEID
where e.GENDER = 'Nu';

-- 8. For all projects in "Hanoi", list the project code (projectID), the code of the project lead
-- department (departmentID), the full name of the manager (lastName, middleName,
-- firstName) as well as the address (Address) and date of birth (date0fBirth) of the
-- Employees.
select p.PROJECTID, d.DEPARTMENTID, concat(e.FIRSTNAME,' ',e.MIDDLENAME,' ',e.LASTNAME) as full_name, e.DATEOFBIRTH
from projects p
join departmentaddress da on da.DEPARTMENTID = p.DEPARTMENTID
join assignment a on a.PROJECTID = p.PROJECTID
join department d on d.MANAGERID = a.EMPLOYEEID
join employees e on e.EMPLOYEEID = d.MANAGERID
where da.ADDRESS = 'HA NOI';

-- 10. For each employee, indicate the employee's full name and the full name of the head of the
-- department in which the employee works.
select concat(e.FIRSTNAME,' ',e.MIDDLENAME,' ',e.LASTNAME) as full_name, concat(ee.FIRSTNAME,' ',ee.MIDDLENAME,' ',ee.LASTNAME) as head_name
from employees e
join department d on d.DEPARTMENTID = e.DEPARTMENTID
join employees ee on d.MANAGERID = ee.EMPLOYEEID
where e.EMPLOYEEID <> ee.EMPLOYEEID;

-- 11. Provide the employee's full name (lastName, middleName, firstName) and the names of
-- the projects in which the employee participated, if any.
SELECT concat(e.FIRSTNAME,' ',e.MIDDLENAME,' ',e.LASTNAME) as full_name, p.PROJECTNAME
from employees e
join assignment a on a.EMPLOYEEID = e.EMPLOYEEID
join projects p on p.PROJECTID = a.PROJECTID;

-- 12. For each scheme, list the scheme name (projectName) and the total number of hours
-- worked per week of all employees attending that scheme.
select p.PROJECTNAME, sum(a.WORKINGHOUR) from assignment a
join projects p on p.PROJECTID = a.PROJECTID
GROUP BY a.PROJECTID;

-- 13. For each department, list the name of the department (departmentName) and the average
-- salary of the employees who work for that department.
select d.DEPARTMENTNAME, AVG(e.salary) from employees e
JOIN department d on d.DEPARTMENTID = e.DEPARTMENTID
GROUP BY e.DEPARTMENTID;

-- 14. For departments with an average salary above 30,000, list the name of the department and
-- the number of employees of that department.
select d.DEPARTMENTNAME, count(e.EMPLOYEEID) from employees e
JOIN department d on d.DEPARTMENTID = e.DEPARTMENTID
GROUP BY e.DEPARTMENTID
having AVG(e.salary) > 30000;

-- 15. Indicate the list of schemes (projectID) that has: workers with them (lastName) as 'Dinh'
-- or, whose head of department presides over the scheme with them (lastName) as 'Dinh'.
select a.PROJECTID from assignment a
join employees e on e.EMPLOYEEID = a.EMPLOYEEID
where e.LASTNAME = 'Dinh'
UNION
select a.PROJECTID FROM assignment a
join department d on a.EMPLOYEEID = d.MANAGERID
join employees e on a.EMPLOYEEID = e.EMPLOYEEID
WHERE e.LASTNAME = 'Dinh';

-- 16. List of employees (lastName, middleName, firstName) with more than 2 relatives
select e.lastname, e.middlename, e.firstname
from employees e
join relative r on e.EMPLOYEEID = r.EMPLOYEEID
GROUP BY e.EMPLOYEEID
having count(r.RELATIONSHIP) > 2;

-- 17. List of employees (lastName, middleName, firstName) without any relatives.
select e.lastname, e.middlename, e.firstname
from employees e
left join relative r on e.EMPLOYEEID = r.EMPLOYEEID
GROUP BY e.EMPLOYEEID
having count(r.RELATIONSHIP) = 0;

-- 18. List of department heads (lastName, middleName, firstName) with at least one relative.
select e.lastname, e.middlename, e.firstname
from employees e
join department d on d.MANAGERID = e.EMPLOYEEID
join relative r on r.EMPLOYEEID = d.MANAGERID
GROUP BY e.EMPLOYEEID
having e.EMPLOYEEID >= 1;

-- 19. Find the surname (lastName) of unmarried department heads.
select e.lastname, e.middlename, e.firstname
from employees e
join department d on d.MANAGERID = e.EMPLOYEEID
join relative r on r.EMPLOYEEID = d.MANAGERID
where not r.RELATIONSHIP in ('Vo chong','Con trai','Con gai');

-- 20. Indicate the full name of the employee (lastName, middleName, firstName) whose salary
-- is above the average salary of the "Research" department
SELECT 
    CONCAT(e.FIRSTNAME,
            ' ',
            e.MIDDLENAME,
            ' ',
            e.LASTNAME) AS full_name
FROM
    employees e
WHERE
    e.SALARY > (SELECT 
            AVG(e.salary)
        FROM
            employees e
                JOIN
            department d ON d.DEPARTMENTID = e.DEPARTMENTID
        WHERE
            d.DEPARTMENTNAME = 'Nghien cuu');

-- 21. . Indicate the name of the department and the full name of the head of the department with
-- the largest number of employees
select d.DEPARTMENTNAME, concat(e.FIRSTNAME,' ',e.MIDDLENAME,' ',e.LASTNAME) as full_name
from department d
join employees e on d.MANAGERID = e.EMPLOYEEID
join employees ee on d.DEPARTMENTID = ee.DEPARTMENTID
GROUP BY ee.DEPARTMENTID
order by count(ee.EMPLOYEEID) desc
limit 1;

-- 22. Find the full names (lastName, middleName, firstName) and addresses (Address) of
-- employees who work on a project in 'HCMC' but the department they belong to is not
-- located in 'HCMC'.
select DISTINCT concat(e.FIRSTNAME,' ',e.MIDDLENAME,' ',e.LASTNAME) as full_name, e.ADDRESS, e.DEPARTMENTID, p.PROJECTID
from employees e
join assignment a on a.EMPLOYEEID = e.EMPLOYEEID
join projects p on p.PROJECTID = a.PROJECTID
join departmentaddress da on da.DEPARTMENTID = e.DEPARTMENTID
where p.PROJECTADDRESS = 'TP HCM' and da.ADDRESS <> 'TP HCM';

-- 23. Find the names and addresses of employees who work on a scheme in a city but the
-- department to which they belong is not located in that city.
-- 23. Find the names and addresses of employees who work on a scheme in a city but the
-- department to which they belong is not located in that city.
select e.FIRSTNAME, e.MIDDLENAME, e.LASTNAME, e.ADDRESS
    from employees e
join assignment a on e.EMPLOYEEID = a.EMPLOYEEID
join projects p on a.PROJECTID = p.PROJECTID
join departmentaddress d on e.DEPARTMENTID = d.DEPARTMENTID
where p.PROJECTADDRESS != d.ADDRESS;

-- 24. Create procedure List employee information by department with input data
-- departmentName.
delimiter $$
create procedure ListEmployeesByDepartment(dName varchar(255))
begin 
    select e.* from employees e
    join department d on e.DEPARTMENTID = d.DEPARTMENTID
    where d.DEPARTMENTNAME = dName;
end $$
call ListEmployeesByDepartment('Nghien cuu');

-- 25. Create a procedure to Search for projects that an employee participates in based on the
-- employee's last name (lastName).
delimiter $$
create procedure searchProject(lName varchar(255))
begin 
    select p.* from projects p
    join assignment a on p.PROJECTID = a.PROJECTID
    join employees e on a.EMPLOYEEID = e.EMPLOYEEID
    where e.LASTNAME = lName;
end $$

call searchProject('Nguyen');

-- 26. Create a function to calculate the average salary of a department with input data
-- departmentID.
delimiter $$
create function getAverageSalaryByDepartmentID(dID int) 
    returns decimal(10,2)
    deterministic
begin 
    declare avgSalary decimal(10,2);
    
    select avg(e.salary) into avgSalary
        from employees e
    join department d on e.DEPARTMENTID = d.DEPARTMENTID
    where d.DEPARTMENTID = dID;
    return avgSalary;
end $$

select getAverageSalaryByDepartmentID(5);

-- 27. Create a function to Check if an employee is involved in a particular project input data is
-- employeeID, projectID.
delimiter $$
create function checkEmployeeInProject(eID int, pID int)
returns boolean
deterministic 
begin
    declare result boolean;
    
    if exists(select 1
              from assignment a
              where a.EMPLOYEEID = eID and a.PROJECTID = pID) then
        set result = true;
        else
        set result = false;
        end if;
    return result; 
end; 
$$

select checkEmployeeInProject(123,1);
