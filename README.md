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

Note: it was calculated for calcuation code 100 and for calculation code 200 the table is in folder "others"

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
* Price of Milk at 2006 was 14,2 kč  and at 2018 was 19,5 kč, Average payroll was 19253
* Price of Bread at 2018 was 14,7 kč  and at 2018 was 23,9 kč,  Average payroll was 33902
* At 2006 it was possible to buy 1352 liters of milk or 1305 kg of bread
* At 2018 it was possible to buy 1741 liters of milk or 1420 kg of bread

### Question 3
Which category of food has slowest growth rate (Lowest percentual annual growth rate)?
* _category of food which is "rostlinný roztíratelný tuk" - code: 115201, has slowest increase in price_
* _in script SQL_project_ukol3_

Missing values of: "Víno Jakostní bílé" only availabe from year 2015

### Question 4 
Is There a year, in which was annual growth rate of food price significantly higher than growth rate of payrolls (higher than 10%) ?

* _From the column differ from SQL_project_ukol4 is possible to find out that there is no such year in which food price would be higher than 10% and would be about 10% higher than payrolls_
* _Answer to this question: there is no such year_

### Question 5
Does high value of GDP influence payrolls and price of food? More precisely, if GDP increase significantly in one year, will the values of payrolls and prices significantly grow in same or next year  

* _This is not exactly hypothesis but it is research question. And that is why i create hypothesis (for the sake of assignment)_
* _Zero hypothesis: significant increase in GDP should not result in significant grow of payrolls and prices in same or next year_ 
* _hypothesis One: significant increase in GDP should result in significant grow of payrolls and prices in same or next year_ 
* _Data for analysis are provided in SQL_project_ukol5_
* _but my modest analysis is present in folder - other -> in excel file_
* _Because only one idea on hypothesis test struck me that is pearson correlation i used it_
* _Result of this test telling if GDP with payrolls and prices are correlating positively or negatively_
* _it is shown that in only for a case: grow in payrolls in next year we can consider H0 rejection because r value with level of significance 0,1 is on the level that it can be rejected: page: https://www.statisticssolutions.com/free-resources/directory-of-statistical-analyses/pearsons-correlation-coefficient/table-of-critical-values-pearson-correlation/_
* _significant increase in GDP should result in significant grow of payrolls --- H0 in case of next year payrolls is reject in other we cannot reject it_
* _But we need to consider that GDP alone is not only one relevant factor. For example in 2015 growth rate of food price was decreasing due to decrease of prices in energy sector and also because of the China food prices development_
* _If this year wouldn´t be included in analysis Pearson coefficient would be higher and would lead to rejection of other part of H0 hypothesis_ 
* _Note: Analysis was done only from part of data where GDP growth rate was increasing_



Commentary to revision

* _All changes were in way shared in evaluation
* _Partition by is only suitable for multiple lag tags
