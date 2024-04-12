/*Remove duplicate information
Where contact is not specified, replace it with unknown
Replace the month with month number
If duplicate records are there for a customer, take the latest contact information. To do, this use the day and month field*/

CREATE VIEW contact_data AS
SELECT * FROM(
SELECT DISTINCT custid,age,job,martial,education,default,balance,
CASE 
  WHEN contact NOT IN ('unknown','telephone','cellular')
  THEN 'unknown' ELSE contact
  END AS contact,
  day,
CASE 
  WHEN month = 'jan' THEN 01
  WHEN month = 'feb' THEN 02
  WHEN month = 'mar' THEN 03
  WHEN month = 'apr' THEN 04
  WHEN month = 'may' THEN 05
  WHEN month = 'jun' THEN 06
  WHEN month = 'jul' THEN 07
  WHEN month = 'aug' THEN 08
  WHEN month = 'sep' THEN 09
  WHEN month = 'oct' THEN 10
  WHEN month = 'nov' THEN 11
  WHEN month = 'dec' THEN 12
ELSE NULL
END AS month,
duration,
campaign,
pdays,
previous_connects,
ROW_NUMBER() OVER (PARTITION BY custid ORDER BY day DESC,month DESC) as row_num
FROM contact_source
) latest_contact
WHERE row_num =1;

--Filtering the data with “unknown contact” to a separate file  be sent to the team responsible for maintaining contact information

hive -e "select * from contact_source where contact = 'unknown'" > /root/Desktop/Home_Loan_Promotion_Campaign/Dataset/Output/unknown_contact.csv

--latest contact information 

hive -e "select * from contact_data where contact != 'unknown'" > /root/Desktop/Home_Loan_Promotion_Campaign/Dataset/Output/cleansed_contact_data.csv
       
--Create a table which consists data for cleansed contact data

CREATE EXTERNAL TABLE IF NOT EXISTS cleansed_contact_data (
custId int,
age int,
job string,
martial string,
education string,
default string,
balance int,
contact string,
day int,
month string,
duration int,
campaign int,
pdays int,
previous_connects int
)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION '/user/cleansed_data'
;

--Load data into cleansed_contact_data table

LOAD DATA LOCAL INPATH '/root/Desktop/Home_Loan_Promotion_Campaign/Dataset/Output/cleansed_contact_data.csv' INTO TABLE cleansed_contact_data;
