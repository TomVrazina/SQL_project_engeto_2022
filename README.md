# SQL_project_engeto_2022

#### By _Tomas Vrazina_

#### _SQL project focused on thorough analysis of data from opendata server_

## Tools Used

* _SQL_
* _Github_
* _Excel_

## Description

Main tasks in a project were generate two tables which are presented in the
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

* _After actjvation code SQL_project_ukol2 first two columns you get are columns num of milks and numof breads_ 
* _These columns represent how many litres of milk and kilograms of bread you can afford in afformentioned period of time_ 
* _The question can be extended for example if i buy 500 hundred kilograms of breads how many litres i can buy with remaining payroll
* _for that reason analytic can use this equation:_
* _$\N=(Payroll-M*Bread)/Milk$ 
*  
