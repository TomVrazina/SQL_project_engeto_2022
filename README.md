# SQL_project_engeto_2022

#### By _Tomas Vrazina_

#### _SQL project focused on thorough analysis of data from opendata server_

## Tools Used

* _SQL_
* _Github_
* _Excel_

## Description

Main tasks in a project were generating of two tables which are presented in the
  form of code:
  * _SQL_project_tables.sql_
  
  form of tables:
  * _t_tomas_vrazina_project_sql_primary_final.csv_
  * _t_tomas_vrazina_project_sql_secondary_final.csv_

Creation of datascript presented in the form of 5 sql script, And with these scripts to answer all research questions

## Questions and Answers

### Question 1
Do payrolls increase over the years in all branches or in some of them they decrease ? 
  
* _They decrease in some of them, can be seen after activation of SQL_project_ukol1_ 

Note: it was calculated for calcuation code 100 and for calculation code 200 the table is in "others"

### Question 2
How many litres of milk and kilograms of bread is possible to buy for first and last comparable period of time in available date of price and payrolls?

* _After actjvation code SQL_project_ukol2 first two columns you get are columns "num of milks" and "num of breads"_ 
* _These columns represent how many litres of milk and kilograms of bread you can afford in afformentioned period of time_
* _first and last comparable period of time is quarter because if we do mean from year it is not "first" comparable period of time_ 
* _The question can be extended for example if i buy 500 hundred kilograms of breads how many litres i can buy with remaining payroll_
* _for that reason analytic team can use this equation:_
* $N=(Payroll-M*Bread)/Milk$ 
* _for number of kilograms of bread_:
* $M=(Payroll-N*Milk)/Bread$ 
* _Note: M, N kilograms and literes of bread and milk_

### Question 3
Which category of food has slowest growth rate (Lowest percentual annual growth rate)?
* _category of food which is "rostlinný roztíratelný tuk" - code: 115201, has slowest increase in price_
* _in script SQL_project_ukol3_

### Question 4 
Is There a year, in which was annual growth rate of food price significantly higher than growth rate of payrolls (higher than 10%) ?

* _From the column differ from SQL_project_ukol3 is possible to find out that there is no such year in which food price would be higher than 10% and would be about 10% higher than payrolls_
* _Answer to this question: there is no such year_

### Question 5
