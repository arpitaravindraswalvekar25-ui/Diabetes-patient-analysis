Create database diabets_project;
use diabets_project;
DESCRIBE diabetes_patientdata;
show tables;
SELECT *
FROM diabetes_patientdata;

-------total patients
select count(*) as total_patients
from diabetes_patientdata;

--age distirbution
select 
CASE
	when age between 18 and 30 then 'youngest (18-30)'
	when age between 31 and 45 then 'young (31-45)'
	when age between 46 and 60 then 'midage (46-60)'
	when age between 61 and 75 then 'older (61-75)'
	ELSE 'oldest(76+)'
end as age_group,
count(*) as patient_count
from diabetes_patientdata
GROUP BY AGE_GROUP
ORDER BY MIN(AGE);


------gender distribution
select Gender, count(*) as patient_count
from diabetes_patientdata 
group by gender
order by patient_count DESC;

----- Wt is distribution of medications among patients?
select medication,
count(*) as pt_medication_count
from diabetes_patientdata
group by medication
order by pt_medication_count DESC;

-------average HBA1C BEFORE TREATEMENT
SELECT
    ROUND(AVG(HbA1c_Pre), 2) AS Average_Pre_HbA1c,
    MIN(HbA1c_Pre) AS Minimum_Pre_HbA1c,
    MAX(HbA1c_Pre) AS Maximum_Pre_HbA1c
FROM diabetes_patientdata;

-----average HBA1C AFTER TREATMENT
SELECT
    ROUND(AVG(HbA1c_Post), 2) AS Average_Post_HbA1c,
    MIN(HbA1c_Post) AS Minimum_Post_HbA1c,
    MAX(HbA1c_Post) AS Maximum_Post_HbA1c
FROM diabetes_patientdata;

-------Over all reduction in Hba1c 
SELECT
    ROUND(AVG(HbA1c_Pre), 2) AS Average_Pre_HbA1c,
    ROUND(AVG(HbA1c_Post), 2) AS Average_Post_HbA1c,
    ROUND(AVG(HbA1c_Reduction), 2) AS Average_HbA1c_Reduction
FROM diabetes_patientdata

-------which medication showed average reduction in HbA1c
SELECT
    Medication,
    COUNT(*) AS Patient_Count,
    ROUND(AVG(HbA1c_Pre), 2) AS Average_Pre_HbA1c,
    ROUND(AVG(HbA1c_Post), 2) AS Average_Post_HbA1c,
    ROUND(AVG(HbA1c_Reduction), 2) AS Average_HbA1c_Reduction
FROM diabetes_patientdata
GROUP BY Medication
ORDER BY Average_HbA1c_Reduction DESC;

-------how many patients have adherednce good adherence
moderate and pooor
select Medication_Adherence,
count(*) as patient_adherence
from diabetes_patientdata
GROUP BY Medication_Adherence
ORDER BY patient_adherence DESC;

---------family history
select
family_history,
count(*) as patient_count
from diabetes_patientdata
group by family_history;

-------- What are the most common recorded complications among patients?
SELECT
    Complications,
    COUNT(*) AS Patient_Count
FROM diabetes_patientdata
GROUP BY Complications
ORDER BY Patient_Count DESC;

-------- which medications are most commonly used by patients?
select medication,
Count(*) as patient_med_count
from diabetes_patientdata
GROUP BY Medication
ORDER BY Patient_med_COUNT DESC;

----- WT % OF PATIENTS HAS HIGH HBA1C
select count(*) as high_hba1c_,
round(Count(*)*100/(select count(*) from diabetes_patientdata),2) 
as percentage from diabetes_patientdata
where HBA1C >=8;

----- WT % OF PATIENTS HAS Controlled HBA1C
select count(*) as controlled_hba1c_,
round(Count(*)*100/(select count(*) from diabetes_patientdata),2) 
as percentage from diabetes_patientdata
where HBA1C < 7;

-----WT PATIENT OUTCOME
select outcome,
count(*) as patient_status
from diabetes_patientdata
GROUP BY Outcome
ORDER BY PATIENT_STATUS DESC;

------which medication has the most improved patients?
select medication,
COUNT(*) AS improved_patients
from diabetes_patientdata
where outcome = 'IMPROVED'
GROUP BY Medication
ORDER BY Improved_patients DESC;


-----MEDICATION ADHERENCE VS PATIENT OUTCOME
select 
Medication_Adherence,
Outcome,
COUNT(*) as patient_count
from diabetes_patientdata
GROUP BY Medication_adherence,Outcome
ORDER BY Medication_adherence,Patient_count DESC;


SELECT
    Medication_Adherence,
    Outcome,
    COUNT(*) AS Patient_Count,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (PARTITION BY Medication_Adherence),
        2
    ) AS Percentage
FROM diabetes_patientdata
GROUP BY Medication_Adherence, Outcome
ORDER BY Medication_Adherence, Percentage DESC;


----WHICH MEDICATION AND ADHERENCE HAS GREATEST HBA1C REDUCTION
Select
Medication,
medication_adherence,
count(*)as patient_Count,
ROUND(AVG(HbA1c_Pre),2) as average_pre_HBA1C,
ROUND(AVG(HBA1C_POST),2) as average_post_hba1c,
ROUND(AVG(HBA1C_REDUCTION),2) as average_hba1c_reduction
from diabetes_patientdata
group by 
medication,
medication_adherence
HAVING COUNT(*) >=20
ORDER BY AVERAGE_HBA1C_REDUCTION DESC;

which medication is effective by using post and pre treatment hba1c
SELECT
    Medication,
    COUNT(*) AS Patient_Count,
    ROUND(AVG(HbA1c_Pre), 2) AS Average_Pre,
    ROUND(AVG(HbA1c_Post), 2) AS Average_Post,
    ROUND(AVG(HbA1c_Reduction), 2) AS Average_Reduction
FROM diabetes_patientdata
GROUP BY Medication
ORDER BY Average_Reduction DESC;

---which state has highest diabetes
select state,
count(*) as patient_count
from diabetes_patientdata
GROUP BY STATE
ORDER BY PATIENT_COUNT DESC;


----Which medication controlled hba1c most
SELECT
    Medication,
    COUNT(*) AS Patient_Count,
    SUM(CASE
        WHEN HbA1c < 7 THEN 1
        ELSE 0
    END) AS Controlled_Patients
FROM diabetes_patientdata
GROUP BY Medication
ORDER BY Controlled_Patients DESC;