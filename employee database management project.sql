--created database
create database employee_database;
use employee_database;

--created  employee table
create table employee(employeeid int,employeename varchar(10),gender char(1),deptno int,managerid int,salary int);

--created  department table
create table department(deptno int,deptname varchar(15),city varchar(10));

--added email column to employee table
alter table employee
add email varchar(50);

--changed name city to location in department table
exec sp_rename 'department.city','location';

--changed  not null of column employeeid 
alter table employee
alter column employeeid int not null;

--added primary key to  employeeid in employee table
alter table employee
add constraint pk_id primary key(employeeid);

--applied  not null constraint  to column deptno
alter table department
alter column deptno int not null;

--added primary key to  deptno in department table
alter table department
add constraint pk_depart_deptno primary key(deptno);

--added foreign key to deptno in employee table
alter table employee
add constraint fk_employee_deptno foreign key(deptno)
references department(deptno);

--added foreign key to managerid in employee table
alter table employee
add constraint fk_employee_managerid foreign key(managerid)
references employee(employeeid);

--applied default constraint  to column email
alter table employee
add constraint default_employee_email default 'na'  for email;

--applied  check constraint  to column location
alter table department
add constraint check_department_city check(location in ('noida','delhi','lucknow'));

--applied  check constraint  to column salary
alter table employee
add constraint check_employee_salary check(salary >=0);

-- insert data into department
insert into department
values(10,'SALES','noida'),(20,'IT','noida'),(30,'FINANCE','lucknow'),(40,'MARKETING','delhi');

-- insert data into employee
insert into employee(employeeid,employeename,gender,deptno,managerid,salary)
values(1,'LINDA','F',10,null,75000),(2,'MARY','F',10,1,40000),(3,'ANJELA','F',10,2,32000),
(4,'JASON','M',20,1,50000),(5,'AHMED','M',20,4,30000),(6,'MARIA','F',20,4,40000),(7,'JOHN','M',30,1,60000),
(8,'JACK','M',30,7,55000),(9,'JUNE','F',30,7,40000),(10,'OLA','M',30,8,35000);

 --find number_of_employees who belong to lucknow location
select  count(e.employeeid) as number_of_employees  from employee e
inner join
department d
on e.deptno=d.deptno and location='lucknow';

--find deptno wise total salaries
select  sum(salary) as total_salaried from employee
group by deptno;

--find deptno wise find min and max salaries
select min(salary) as least_salaried ,max(salary) as maximum_salaried from employee
group by deptno;

--find gender wise salaries
select gender,sum(salary) as total_salary from employee
group by gender;

--find number_of_employees who are belong to marketing and who having highest salary in the  departement
select count(employeeid)as number_of_employees from employee 
where salary > 
(select avg(salary) from employee
where deptno in (select deptno from department
where deptname ='marketing'))

 --find  employee details such  deptno,employeeid who are belong to finance  departement 
select d.deptno,e.employeeid from employee e
inner join
department d
on e.deptno=d.deptno
and  deptno  > (select deptno from department where deptname='finance';



select count(e.employeeid) as number_of_employees from employee e
inner join
department d
on e.deptno=d.deptno 
select count(e.employeeid) as number_of_employees from employee e
 (select employeeid from employee where deptno in (select deptno from department ) > (select employeeid from employee where deptno in (select deptno from department where deptname='finance'))

--created sale table
create table Sales(sid int not null,sales money,sdate date,eid int);
alter table Sales 
add constraint pk_Sales_sid primary key(sid);
alter table Sales
add constraint fk_Sales_eid foreign key(eid) references employee(employeeid);
insert into Sales
values(101,4000,'2005-10-10',1),(102,2300,'2006-01-12',1),(103,9000,'2005-06-20',2),(104,4500,'2007-02-10',2),
(105,3200,'2007-02-27',3),(106,2100,'2008-05-25',3),(107,6200,'2008-04-14',4),(108,1900,'2009-10-24',4),
(109,9100,'2009-03-20',5),(110,7600,'2010-12-12',5),(111,8300,'2010-09-15',6),(112,4800,'2010-06-23',6),
(113,3900,'2010-08-10',7),(114,8100,'2010-11-14',7),(115,4900,'2011-10-19',8),(116,5000,'2011-04-20',8),
(117,8400,'2011-05-24',8),(118,2700,'2011-10-12',9),(119,7100,'2012-08-20',9),(120,4100,'2012-03-15',9),
(121,2100,'2012-03-15',10),(122,9300,'2012-09-15',10),(123,9200,'2013-07-15',10),(124,8300,'2013-03-15',10);


-- using dense rank i find top two salaries  and also get complete  employee details using subquery
select * from 
(select d.deptname, employeename,e.salary ,DENSE_RANK() over(order by salary desc)rnk from employee e
inner join
department d
on e.deptno=d.deptno and d.deptname='IT')t1
where rnk<=2;

-- using dense rank i find top two salaries over departement wise  and also get complete  employee details using subquery
select * from
(select d.deptname,e.employeename,e.salary,d.deptno,dense_rank() over (partition by d.deptno order by e.salary desc)rnk   from employee e
inner join
department d
on e.deptno=d.deptno
)t1
where rnk<=2;

-- department wise total sales
select d.deptname,sum(s.sales) total_sales  from  Sales s
inner join
employee e
on e.employeeid=s.eid
inner join
department d
on e.deptno=d.deptno 
group by d.deptname;


--on october month who much sales happened  and their names
select e.employeename,s.sales from employee e
inner join
Sales s
on e.employeeid=s.eid and DATENAME(month,sdate)='october';

--in table  not specific employee name then become top level as  manager name using coalese
select  e.employeename as employee_name,coalesce(m.employeename,'TOP level')as manager_name  from employee e
left join
employee m
on e.managerid=m.employeeid;


--find null in eid in employee table
select e.employeeid, e.employeename from employee e
left join 
sales s
on e.employeeid=s.eid
where s.eid is null;



 --find top 1 sales using dense rank and also get information eid and sales using subquery 
select eid  from
(select eid, sum(sales)as sales ,dense_rank() over( order by sum(sales) desc)rnk 
from Sales group by eid )t1
 where rnk=1;


--storted  both tables in view with encryption security
create view vname_details
with schemabinding,encryption
as
select e.employeename,d.deptname,e.salary,d.location from dbo.employee e
inner join
dbo.department d
on
e.deptno=d.deptno;
select * from vname_details;

