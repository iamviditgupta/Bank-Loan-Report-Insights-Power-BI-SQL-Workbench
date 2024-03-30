select * from finance_loan;

-- Altering issue  DATE column 
--------------------------------------------------------
alter table finance_loan                                     
add temp_issue_date date;

update finance_loan
set temp_issue_date= str_to_date(issue_date,"%d-%m-%Y");

select temp_issue_date from finance_loan;

alter table finance_loan
drop column issue_date;

alter table finance_loan
rename column temp_issue_date to issue_date;
--------------------------------------------------------