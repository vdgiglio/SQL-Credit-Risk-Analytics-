--- Finance Credit Risk Analytics Project ---

--- Part 4: Payments & Deliquency Frequency ---

--- Question 1 ---

SELECT DISTINCT Applicant_Id, SUM(Days_Late) AS Total_Days_Late
FROM Payments
WHERE Was_Late = "Yes"
GROUP BY Applicant_Id
ORDER BY Total_Days_Late DESC;

--- Question 2 ---

WITH Total_Statement_Balance AS (
SELECT Card_Product, SUM(Statement_Balance) AS Total_Statement_Balance
FROM Payments
GROUP BY Applicant_Id, Card_Product)
SELECT Card_Product, AVG(Total_Statement_Balance) AS Average_Statement_Balance
FROM Total_Statement_Balance
GROUP BY Card_Product
ORDER BY Average_Statement_Balance DESC;

--- Question 3 --- 

WITH Late_Payments AS (
SELECT Was_Late, Days_Late
FROM Payments
WHERE Was_Late = "Yes"
GROUP BY Applicant_Id, Was_Late, Days_Late)
SELECT AVG(Days_Late) AS Average_Days_Late
FROM Late_Payments;

--- Question 4 ---

SELECT *
FROM (
SELECT Applicant_Id, Payment_Date, Payment_Amount,
LAG(Payment_Amount, 1) 
OVER(PARTITION BY Applicant_Id 
ORDER BY Payment_Date) AS Previous_Payment_Amount
FROM Payments ) AS Payment_History
WHERE Previous_Payment_Amount IS NOT NULL;

--- Question 5 ---

SELECT "Extemely High DTI" AS DTI_Segment, Was_Late,
COUNT(DISTINCT A.Applicant_Id) AS Total_Applicants
FROM Applicants A
JOIN Payments P
ON A.Applicant_Id = P.Applicant_Id
WHERE Was_Late = "Yes" 
AND Debt_To_Income > 0.4
GROUP BY Was_Late;

