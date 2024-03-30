-- Creating seprate schema and import dataset csv/excel file
use FinanceLoan; 

-- Total Loan Application 
select distinct count(id) as Total_Loan_Application from finance_loan;

-- Issue Date Range In Given Dataset 
select min(issue_date) as Start_Issue_Date, max(issue_date) as End_Issue_Date from finance_loan;

-- current MTD Loan application
select count(id) as MTD_Loan_Appoliaction from finance_loan
where month(issue_date)= 12;

-- PMTD Loan application
select count(id) as PMTD_Loan_Appoliaction from finance_loan
where month(issue_date)= 11;

-- Number of loan applications Monthly i.e, MTD Loan Application 
select date_format(issue_date,"%M") as Months , count(*) as MTD_Loan_Application from finance_loan
group by Months
order by MTD_Loan_Application;


-- Month-over-Month change in Loan application 
-- Below query fetch increase or decraese in the number of loan appliaction from preceeding month
select date_format(issue_date,"%m") as Month_num, count(*) as MTD_Loan_Application, 
count(*) - lag(count(*),1) over(order by date_format(issue_date,"%m")) as MOM_Change_num_application
from finance_loan
where issue_date>="2021-01-01" and issue_date<= "2021-12-12"
group by Month_num
order by Month_num;


-- Total Amount Funded As Laon
select sum(loan_amount) as Total_Fund_Amount from finance_loan;

-- current MTD Amount Funded
select sum(loan_amount) as MTD_Total_Fund_Amount from finance_loan
where month(issue_date)= 12;

-- PMTD Amount Funded
select sum(loan_amount) as PMTD_Total_Fund_Amount from finance_loan
where month(issue_date)= 11;


-- Total amount funded in each month 
select date_format(issue_date,"%m") as month_num, sum(loan_amount) as MTD_Total_Funded_Amount 
from finance_loan
group by month_num 
order by month_num;


-- Month-over-Month change in Loan Amount funded
-- Below query fetch change in the amount of loan funded from preceeding month
select date_format(issue_date,"%m") as Month_num, sum(loan_amount) as Amount_Funded_Monthly, 
sum(loan_amount) - lag(sum(loan_amount),1) over(order by date_format(issue_date,"%m")) as MOM_Change_Amount_Funded
from finance_loan
where issue_date>="2021-01-01" and issue_date<= "2021-12-12"
group by Month_num
order by Month_num;



-- Total Payment recieved from borrower
select sum(total_payment) as Total_Payment_Recieved from finance_loan;

-- current MTD Payment recieved
select sum(total_payment) as MTD_Total_Payment_Recieved  from finance_loan
where month(issue_date)= 12;

-- PMTD Payment Recieved
select sum(total_payment) as PMTD_Total_Payment_Recieved  from finance_loan
where month(issue_date)= 11;

-- Total amount recieved in each month based on the date the loan application was issued  
select date_format(issue_date,"%m") as month_num, sum(total_payment) as MTD_Total_Payment_Recieved
from finance_loan
group by month_num 
order by month_num;


-- Month-over-Month change in Loan Amount recieved based on the date the loan application was issued
-- Below query fetch change in the amount of payment recived from preceeding month 
select date_format(issue_date,"%m") as Month_num, sum(total_payment) as Amount_Recieved_Monthly, 
sum(total_payment) - lag(sum(total_payment),1) over(order by date_format(issue_date,"%m")) as MOM_Change_Amount_recieved
from finance_loan
where issue_date>="2021-01-01" and issue_date<= "2021-12-12"
group by Month_num
order by Month_num;

-- Fetch min interest rate ,max interest rate,  Average interest rate % 
select round(min(int_rate)*100,2) Minimum_interest_rate, round(max(int_rate)*100,2) as Maximum_interest_rate,
round(avg(int_rate)*100,2) as Average_interest_rate from finance_loan;


-- current MTD Average Interest
select round(avg(int_rate)*100,2) as MTD_Average_interest_rate from finance_loan
where month(issue_date)= 12;

-- PMTD Average Interest
select round(avg(int_rate)*100,2) as PMTD_Average_interest_rate  from finance_loan
where month(issue_date)= 11;

-- Fetch min interest rate ,max interest rate,  Average interest rate % for each month 
select date_format(issue_date,"%m") as Month_num,
round(min(int_rate)*100,2) Minimum_interest_rate, 
round(max(int_rate)*100,2) as Maximum_interest_rate,
round(avg(int_rate)*100,2) as Average_interest_rate 
from finance_loan
group by month_num
order by month_num;


-- Fetch min dti ,max dti,  Average dti in given set
select round(min(dti),4) debt_income_ratio, round(max(dti),4) as debt_income_ratio,
round(avg(dti),4) as debt_income_ratio from finance_loan;

-- current MTD Average dti
select round(avg(dti),4) MTD_debt_income_ratio from finance_loan
where month(issue_date)= 12;

-- PMTD Average dti
select round(avg(dti),4) PMTD_debt_income_ratio from finance_loan
where month(issue_date)= 11;


-- Fetch min interest rate ,max interest rate,  Average interest rate % for each month 
select date_format(issue_date,"%m") as Month_num,
round(min(dti),4) debt_income_ratio, 
round(max(dti),4) as debt_income_ratio,
round(avg(dti),4) as debt_income_ratio 
from finance_loan
group by month_num
order by month_num;


-- Fetch Loan status classification of applicants in given set
select distinct loan_status from finance_loan;
-- "Current" Status does not inherently classify the loan as good or bad, it simply signifies that the loan is in good standing at the present time.



-- NOTE:- A good loan is a loan where the borrower consistently meet the payment obligations, 
--        whereas the bad loan is a loan where borrowers struggle to make payment one time.



-- Count of good loan application and Percentage of good loan application
SELECT (COUNT(CASE WHEN loan_status = "Fully Paid" OR loan_status = "Current" THEN id END) * 100) / COUNT(id)
 AS good_loan_percentage FROM finance_loan;
select count(id) as count_good_loan_application from finance_loan
where loan_status="fully paid" or loan_status="current";

-- Total Good loan amount funded by lender
select sum(loan_amount) as Good_Loan_Amount_Funded from finance_loan
where loan_status="fully paid" or loan_status="current";

-- Total Good loan payment recieved from borrower  
select sum(total_payment) as Good_Loan_Payment_Recieved from finance_loan
where loan_status="fully paid" or loan_status="current";




-- Count of bad loan application and Percentage of bad loan application
SELECT (COUNT(CASE WHEN loan_status = "charged off" THEN id END) * 100) / COUNT(id)
 AS bad_loan_percentage FROM finance_loan;
select count(id) as count_bad_loan_application from finance_loan
where loan_status  in ("charged off");

-- Total Bad loan amount funded by lender
select sum(loan_amount) as Bad_Loan_Amount_Funded from finance_loan
where loan_status="charged off";

-- Total Bad loan payment recieved from borrower  
select sum(total_payment) as Bad_Loan_Payment_Recieved from finance_loan
where loan_status="charged off";



-- Fetch Loan count of application, Amount lended, Payment Recieved based on Loan status 
-- with Avg interest rate % and Avg dti %
select loan_status,count(id) as Loan_Application, round(Avg(int_rate)*100,4) as Avg_Interest_Rate,
round(Avg(dti)*100,4) as Avg_dti_rate, Sum(loan_amount) as Amount_Funded,
sum(total_payment) as Payment_Recieved from finance_loan
group by loan_status;


-- Fetch Monthly Loan count of application, Amount lended, Payment Recieved based on Loan status 
select month(issue_date) as Months,count(id) as Loan_Application,loan_status,sum(loan_amount) as Amount_Funded,
sum(total_payment) as Payment_Recieved from finance_loan
group by loan_status,Months
order by months;


-- Bank loan report monthly overview 
select month(issue_date) as Month_Num, monthname(issue_date) as Month_Name,
count(id) as Num_Loan_application, Sum(loan_amount) as Amount_Funded,
sum(total_payment) as Payment_Recieved from finance_loan
group by month_num,month_name
order by month_num; 


-- Bank Loan report overview based on purpose 
select purpose, round(avg(int_rate)*100,2) as Avg_Interest_Rate, 
round(avg(dti)*100,2) as Avg_Dti_Rate, count(id) as Loan_Application,
sum(loan_amount) as Amount_Funded, sum(total_payment)as payment_Recieved 
from finance_loan
-- add where condition; grade="A1" etc
group by purpose;



-- Bank Loan report overview based on term
select term as Term_Period, round(avg(int_rate)*100,2) as Avg_Interest_Rate, 
sum(loan_amount) as Amount_Funded, sum(total_payment)as payment_Recieved 
from finance_loan
group by term;



-- Bank Loan report overview based on home ownership 
select home_ownership, round(avg(int_rate)*100,2) as Avg_Interest_Rate, 
round(avg(dti)*100,2) as Avg_Dti_Rate, count(id) as Loan_Application,
sum(loan_amount) as Amount_Funded, sum(total_payment)as payment_Recieved 
from finance_loan
group by home_ownership;


-- Fetch number of application on verification status
select distinct verification_status,count(id) as Loan_application from finance_loan
group by verification_status; 


-- Bank Loan report overview based on grade 
select grade Grade, count(id) as Loan_Application,
sum(loan_amount) as Amount_Funded, sum(total_payment)as payment_Recieved 
from finance_loan
group by grade
order by grade;



-- Bank Loan report overview based on Employee Job lenght 
select emp_length,
count(id) as Loan_Application,
sum(loan_amount) as Amount_Funded, sum(total_payment)as payment_Recieved 
from finance_loan
group by emp_length
order by emp_length;



-- Bank Loan report overview based statewise 
select distinct home_ownership from finance_loan;
select address_state,
round(avg(dti)*100,2) as Avg_Dti_Rate, count(id) as Loan_Application,
sum(loan_amount) as Amount_Funded, sum(total_payment)as payment_Recieved 
from finance_loan
-- can also add where condition like; where home_ownership="Rent"
group by address_state;


-- Loan status metric for given term 
-- we can switch to other values of loan_status in same query
-- we can add where condition also to filter result based on purpose etc.
select count(id) as Total_Loan_Application, 
count(case when loan_status= 'charged off' then id end)  as Total_Chargedoff_Application,
(count(case when loan_status= 'charged off' then id end) *100) /count(id) as Total_Chargedoff_Application_Percent
from finance_loan; 