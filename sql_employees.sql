use HumanResources
GO

--Function Calc Age attribution
Create view calcAge as
select
	id, YEAR(GETDATE()) - YEAR(birthdate) as AgeOfEmployees, gender as Gender
from dbo.[Human Resources]

select * from calcAge
drop view calcAge

--What is the gender breakdown of employees in the company?
Create view BreakdownGender AS
select gender, count(*) as count 
from dbo.[Human Resources] as hr
group by gender
order by gender asc offset 0 rows

select * from BreakdownGender
drop view BreakdownGender

--What is the race/ethnicity breakdown of employees in the company?
create view AgeDistribution AS
select race as Race, count(*) as CountRace
from dbo.[Human Resources]
group by race 
order by race asc offset 0 rows

select * from AgeDistribution
drop view AgeDistribution

--What is the age distribution of employees in the company?
create view CalcOldYoung AS
select 
	min(AgeOfEmployees) as Young,
	max(AgeOfEmployees) as Old
 from calcAge 
 inner join dbo.[Human Resources]
 on dbo.[Human Resources].id = calcAge.id

select * from CalcOldYoung
drop view CalcOldYoung

create view SortAges AS
select distinct
	AvAge = case
	    when CalcAge.AgeOfEmployees >= 18 and CalcAge.AgeOfEmployees <=24 then '18-24'
		when CalcAge.AgeOfEmployees  >= 25 and CalcAge.AgeOfEmployees <= 34 then '25-34'
		when CalcAge.AgeOfEmployees  >= 35 and CalcAge.AgeOfEmployees <= 44 then '35-44'
		when CalcAge.AgeOfEmployees  >= 45 and CalcAge.AgeOfEmployees <= 54 then '45-54'
		when CalcAge.AgeOfEmployees  >= 55 and CalcAge.AgeOfEmployees <= 64 then '55-64'
		else '65+'
	end,
	count(*) as CountAge
	,CalcAge.gender as Gender
from CalcAge
group by 
	gender,
	case
	    when CalcAge.AgeOfEmployees >= 18 and CalcAge.AgeOfEmployees <=24 then '18-24'
		when CalcAge.AgeOfEmployees  >= 25 and CalcAge.AgeOfEmployees <= 34 then '25-34'
		when CalcAge.AgeOfEmployees  >= 35 and CalcAge.AgeOfEmployees <= 44 then '35-44'
		when CalcAge.AgeOfEmployees  >= 45 and CalcAge.AgeOfEmployees <= 54 then '45-54'
		when CalcAge.AgeOfEmployees  >= 55 and CalcAge.AgeOfEmployees <= 64 then '55-64'
		else '65+'
	end 
order by AvAge, gender asc offset 0 rows
 
select * from SortAges

--How many employees work at headquarters versus remote locations?
select location, count(*) as CountLocation
from dbo.[Human Resources] as hr
group by hr.location


--What is the average length of employment for employees who have been terminated?
create view AvgTimeWork as
select	
	AVG(DATEDIFF(day,CONVERT(date, hire_date),LEFT(termdate, 10)))/365 as AvgTimeWorkOfEmployees
from dbo.[Human Resources] as hr
where CONVERT(date, LEFT(termdate, 10)) <= CONVERT(date, GETDATE())

select * from AvgTimeWork

--How does the gender distribution vary across departments and job titles?
select HR.department, HR.gender, count(*) as Count
from dbo.[Human Resources] as HR
group by HR.department, HR.gender
order by HR.department offset 0 rows