SELECT * FROM psyliq.diabetics_psyliq_1;

UPDATE psyliq.diabetics_psyliq_1
SET DOB = 
    CASE 
        WHEN DOB = '2/29/1995' THEN '3/29/1995'
        ELSE DOB
    END
WHERE DOB = '2/29/1995';

UPDATE psyliq.diabetics_psyliq_1
SET age = TIMESTAMPDIFF(YEAR, STR_TO_DATE(DOB, '%m/%d/%Y'), CURDATE());

#1. Retrieve the Patient_id and ages of all patients.

SELECT Patient_id, age FROM psyliq.diabetics_psyliq_1;

#2. Select all female patients who are older than 40.

SELECT Patient_id FROM psyliq.diabetics_psyliq_1
 WHERE gender = 'Female' AND age > 40; 
 
#3. Calculate the average BMI of patients.

SELECT AVG(bmi) FROM psyliq.diabetics_psyliq_1;

#4. List patients in descending order of blood glucose levels.

SELECT Patient_id, blood_glucose_level FROM psyliq.diabetics_psyliq_1
ORDER BY blood_glucose_level DESC;

#5. Find patients who have hypertension and diabetes.

SELECT Patient_id, hypertension, diabetes FROM psyliq.diabetics_psyliq_1 
WHERE hypertension = 1 AND diabetes = 1;

#6. Determine the number of patients with heart disease.

SELECT COUNT(*) AS heart_disease_count FROM psyliq.diabetics_psyliq_1
WHERE heart_disease= 1;

#7. Group patients by smoking history and count how many smokers and non-smokers there are.

SELECT COUNT(*), smoking_history FROM psyliq.diabetics_psyliq_1
GROUP BY smoking_history; 

#8. Retrieve the Patient_ids of patients who have a BMI greater than the average BMI.

SELECT Patient_id FROM psyliq.diabetics_psyliq_1
WHERE bmi > (SELECT AVG(bmi) FROM psyliq.diabetics_psyliq_1);

#9. Find the patient with the highest HbA1c level and the patient with the lowest HbA1clevel.

SELECT Patient_id FROM psyliq.diabetics_psyliq_1
WHERE HbA1c_level = (SELECT MAX(HbA1c_level) FROM psyliq.diabetics_psyliq_1) 
AND HbA1c_level = (SELECT MAX(HbA1c_level) FROM psyliq.diabetics_psyliq_1);

/*
10. Calculate the age of patients in years (assuming the current date as of now).
UPDATE psyliq.diabetics_psyliq_1
SET age = TIMESTAMPDIFF(YEAR, STR_TO_DATE(DOB, '%m/%d/%Y'), CURDATE());
*/

#11. Rank patients by blood glucose level within each gender group.

SELECT Patient_id, Gender, Blood_glucose_level,
RANK() OVER (PARTITION BY Gender ORDER BY Blood_glucose_level DESC) AS Glucose_Level_Rank
FROM psyliq.diabetics_psyliq_1;

#12. Update the smoking history of patients who are older than 50 to "Ex-smoker."

SET SQL_SAFE_UPDATES = 0;
UPDATE psyliq.diabetics_psyliq_1
SET smoking_history = 'Ex-smoker'
WHERE age>50;


#13. Insert a new patient into the database with sample data.

INSERT INTO psyliq.diabetics_psyliq_1 
VALUES('Rohinn Vaskiey','PT123999', 'Male', '3/8/1994',1,0,'never', 23.7,45.3, 84, 0, 35);

#14. Delete all patients with heart disease from the database.

DELETE FROM psyliq.diabetics_psyliq_1
WHERE heart_disease = 1;

#15. Find patients who have hypertension but not diabetes using the EXCEPT operator.

SELECT Patient_id FROM psyliq.diabetics_psyliq_1
WHERE hypertension = 1;
EXCEPT 
SELECT Patient_id FROM psyliq.diabetics_psyliq_1
WHERE diabetes = 1;


#16. Define a unique constraint on the "patient_id" column to ensure its values are unique.

ALTER TABLE psyliq.diabetics_psyliq_1
ADD CONSTRAINT Patient_id_unique UNIQUE (Patient_id(255));

#17. Create a view that displays the Patient_ids, ages, and BMI of patients.

CREATE VIEW psyliq.Patient_info AS
SELECT Patient_id, age, BMI
FROM psyliq.diabetics_psyliq_1;


SELECT * FROM psyliq.Patient_info;
