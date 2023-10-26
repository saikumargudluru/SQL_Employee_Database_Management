--create database
create database capstone_1;
use capstone_1;

--create table
create table employee(employeeid int,employeename varchar(10),gender char(1),deptno int,managerid int,salary int);
create table department(deptno int,deptname varchar(15),city varchar(10));

drop table employee;
drop table department;


alter table employee
add email varchar(50);


exec sp_rename 'department.city','location';


alter table employee
alter column employeeid int not null;

alter table employee
add constraint pk_id primary key(employeeid);


alter table department
alter column deptno int not null;

alter table department
add constraint pk_depart_deptno primary key(deptno);


alter table employee
add constraint fk_employee_deptno foreign key(deptno)
references department(deptno);

alter table employee
drop constraint fk_employee_deptno;

alter table employee
add constraint fk_employee_managerid foreign key(managerid)
references employee(employeeid);


alter table employee
drop constraint fk_employee_managerid;

alter table employee
add constraint default_employee_email default 'na'  for email;


alter table department
add constraint check_department_city check(location in ('noida','delhi','lucknow'));


alter table employee
add constraint check_employee_salary check(salary >=0);


insert into department
values(10,'SALES','noida'),(20,'IT','noida'),(30,'FINANCE','lucknow'),(40,'MARKETING','delhi');

insert into employee(employeeid,employeename,gender,deptno,managerid,salary)
values(1,'LINDA','F',10,null,75000),(2,'MARY','F',10,1,40000),(3,'ANJELA','F',10,2,32000),
(4,'JASON','M',20,1,50000),(5,'AHMED','M',20,4,30000),(6,'MARIA','F',20,4,40000),(7,'JOHN','M',30,1,60000),
(8,'JACK','M',30,7,55000),(9,'JUNE','F',30,7,40000),(10,'OLA','M',30,8,35000);


select * from employee
where left(employeename,1)=right(employeename,1);


select * from employee
where len(employeename) >(select len(employeename) from employee where employeeid=5);


select string_agg(employeename,',')as name from employee;


select CONCAT(left(employeename,1),right(employeename,1))as nickname from employee;


select  count(e.employeeid) as number_of_employees  from employee e
inner join
department d
on e.deptno=d.deptno and location='lucknow';


select  sum(salary) as total_salaried from employee
group by deptno;


select min(salary) as least_salaried ,max(salary) as maximum_salaried from employee
group by deptno;


select gender,sum(salary) as total_salary from employee
group by gender;


select count(employeeid)as number_of_employees from employee 
where salary > 
(select avg(salary) from employee
where deptno in (select deptno from department
where deptname ='marketing'))

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







--F

--getdate()-returns the current date and time.
--datepart()-returns a specific part such as year,month,day,hour,minute and so on from  a date or time.
--datename()-returns the name of a specific date part from date or time.
--dateadd()-we can add or subtract specified interval such as year,month,day,hour,minute and so on from a date or time.
--datediff()-calcualtes the difference between two dates in a specified filed such as year,month,day.
--eomonth()-returns last day of month for the specified date.
--day()-returns the day from date.
--month()-returns the month from date.
--year()-returns the year from date.
--isdate()-it is used to validate a date value.


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



select * from 
(select d.deptname, employeename,e.salary ,DENSE_RANK() over(order by salary desc)rnk from employee e
inner join
department d
on e.deptno=d.deptno and d.deptname='IT')t1
where rnk<=2;


select * from
(select d.deptname,e.employeename,e.salary,d.deptno,dense_rank() over (partition by d.deptno order by e.salary desc)rnk   from employee e
inner join
department d
on e.deptno=d.deptno
)t1
where rnk<=2;


select d.deptname,sum(s.sales) total_sales  from  Sales s
inner join
employee e
on e.employeeid=s.eid
inner join
department d
on e.deptno=d.deptno 
group by d.deptname;



select e.employeename,s.sales from employee e
inner join
Sales s
on e.employeeid=s.eid and DATENAME(month,sdate)='october';


select  e.employeename as employee_name,coalesce(m.employeename,'TOP level')as manager_name  from employee e
left join
employee m
on e.managerid=m.employeeid;



select e.employeeid, e.employeename from employee e
left join 
sales s
on e.employeeid=s.eid
where s.eid is null;




select eid  from
(select eid, sum(sales)as sales ,dense_rank() over( order by sum(sales) desc)rnk 
from Sales group by eid )t1
 where rnk=1;







create view vname_details
with schemabinding,encryption
as
select e.employeename,d.deptname,e.salary,d.location from dbo.employee e
inner join
dbo.department d
on
e.deptno=d.deptno;
select * from vname_details;

alter view vname_details
as
select e.employeename,d.deptname,e.salary,d.location from dbo.employee e
inner join
dbo.department d
on
e.deptno=d.deptno;
