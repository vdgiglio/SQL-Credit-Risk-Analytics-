--- Finance Credit Risk Analysis Project --- 

--- Part 1: Applicant Credit/Risk Segmentation ---

--- Question 1 ---

SELECT 
	CASE
		WHEN Credit_Score BETWEEN 550 AND 600 THEN "550-600"
		WHEN Credit_Score BETWEEN 600 AND 650 THEN "600-650"
		WHEN Credit_Score BETWEEN 650 AND 700 THEN "650-700"
		WHEN Credit_Score BETWEEN 700 AND 750 THEN "700-750"
		WHEN Credit_Score BETWEEN 750 AND 800 THEN "750-800"
		WHEN Credit_Score BETWEEN 800 AND 850 THEN "800-850"
			END AS Credit_Score_Range,
	AVG(Annual_Income) AS Average_Income,
    COUNT(*) AS Total_Applicants
		FROM Applicants
		GROUP BY Credit_Score_Range
		ORDER BY Credit_Score_Range DESC;

--- Question 2 ---

SELECT Employment_Status, COUNT(*) AS Total_Applicants
FROM Applicants
GROUP BY Employment_Status;

--- Question 3 ---

SELECT Applicant_Id, Debt_To_Income
FROM Applicants
WHERE Debt_To_Income > 
(SELECT AVG(Debt_To_Income) AS Average_Debt_To_Income
FROM Applicants)
ORDER BY Debt_To_Income DESC;

--- Question 4 ---

SELECT Applicant_Id, Credit_Score,
ROW_NUMBER() OVER(ORDER BY Credit_Score DESC) As Credit_Ranking
FROM Applicants;

--- Question 5 ---

SELECT Housing_Status, AVG(Credit_Score) AS Average_Credit_Score
FROM Applicants
GROUP BY Housing_Status
ORDER BY Average_Credit_Score DESC;

--- Question 6 ---

WITH Young_Applicants AS
(SELECT Applicant_Id, Age, Debt_To_Income
FROM Applicants
WHERE Age < 30)
SELECT AVG(Debt_To_Income) AS Average_Debt_To_Income
FROM Young_Applicants;
    
--- Question 7 ---

SELECT Applicant_Id, Delinquencies_Past_2y
FROM Applicants
WHERE Delinquencies_Past_2y > 1
ORDER BY Delinquencies_Past_2y DESC;

--- Question 8 ---

SELECT Applicant_Id, Annual_Income, Credit_Score
FROM Applicants
ORDER BY Annual_Income DESC
LIMIT 10;

--- Question 9 ---

SELECT COUNT(Applicant_Id) AS Total_Bankruptcy_Applicants
FROM Applicants
WHERE Bankruptcy_History = 1;

--- Question 10 ---

SELECT
	CASE
		WHEN Debt_To_Income < 0.20 THEN "Low Risk"
        WHEN Debt_To_Income BETWEEN 0.20 AND 0.30 THEN "Medium Risk"
        WHEN Debt_To_Income BETWEEN 0.30 AND 0.40 THEN "High Risk"
        WHEN Debt_To_Income > 0.40 THEN "Extremely High Risk"
        END AS Debt_To_Income_Class,
        COUNT(*) AS Total_Applicants
        FROM Applicants
        GROUP BY Debt_To_Income_Class
        ORDER BY Total_Applicants DESC

