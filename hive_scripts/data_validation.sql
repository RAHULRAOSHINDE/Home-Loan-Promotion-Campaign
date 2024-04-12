--Validating data

--To check that no of record in contact.csv is equal to sum of records in “Unknown Contact” file in Unix and “Known contact” in Hive”

--no of records in contact.csv-->4524

--check no of record in unknown_contact.csv

wc -l unknown_contact.csv 

--no of records in unknown_contact.csv  --> 1329 


--check no of known_contacts uploaded in hive

SELECT COUNT(*) FROM cleansed_contact_data;

--no of known_contacts uploaded in hive --> 1919

--no of records in loan_data in hive -1687

SELECT COUNT(*) FROM loan_data ;

--no of records in loan_data in unix --> 1688

--Performing data quality check txt file

--The custids are unique

--702- custids