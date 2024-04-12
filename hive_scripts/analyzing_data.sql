--Analyzing data 

/*criteria : If no record for the customer is found in loan.csv, assume that the customer has no loans
and extracting the results as a text file and renaming it as campaign_data.txt*/

INSERT OVERWRITE LOCAL DIRECTORY '/root/Desktop/Home_Loan_Promotion_Campaign/Dataset/Output/campaign'
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
SELECT cl.custid AS cl_custid,cl.age,cl.job,cl.martial,cl.education,cl.default,cl.balance,cl.contact,cl.day,cl.month,cl.duration,cl.campaign,cl.pdays,cl.previous_connects
FROM cleansed_contact_data cl
LEFT JOIN loan_data ld
ON cl.custid = ld.custid
WHERE ld.custid is NULL;

mv root/Desktop/Home_Loan_Promotion_Campaign/Dataset/Output/campaign/000000_0 root/Desktop/Home_Loan_Promotion_Campaign/Dataset/Output/campaign/campaign_data.txt

