--- Finance Credit Risk Analytics Project ---

--- Part 3: Applicant Spending Behavior & Product Cards ---

--- Question 1 ---

SELECT Applicant_Id, SUM(Amount) AS Total_Spending
FROM Transactions
GROUP BY Applicant_Id
ORDER BY Total_Spending DESC;

--- Question 2 ---

SELECT Category, SUM(Amount) AS Total_Spending
FROM Transactions
GROUP BY Category
ORDER BY Total_Spending DESC;

--- Question 3 ---

WITH Retail_Transactions AS
(
SELECT Applicant_Id, Category, SUM(Amount) AS Total_Spending
FROM Transactions
WHERE Category = "Retail" 
GROUP BY Applicant_Id)
SELECT AVG(IFNULL(T.Total_Spending, 0)) AS Average_Total_Spending
FROM Applicants A
LEFT JOIN Retail_Transactions T
ON T.Applicant_Id = A.Applicant_Id;


--- Question 4 ---

SELECT Transaction_Id, Amount,
ROW_NUMBER() OVER(ORDER BY Amount DESC) AS Transaction_Amount_Rank
FROM Transactions;

--- Question 5 ---

SELECT A.Card_Product, AVG(Amount) AS Average_Transaction_Amount
FROM Applications A
LEFT JOIN Transactions T
ON T.Applicant_Id = A.Applicant_Id
GROUP BY Card_Product
ORDER BY Average_Transaction_Amount DESC;

--- Question 6 ---
 
SELECT Applicant_Id, SUM(Amount) AS Total_Spending
FROM Transactions
GROUP BY Applicant_Id
HAVING Total_Spending >
(SELECT SUM(Amount)/ COUNT(DISTINCT Applicant_Id) AS Average_Total_Spending
FROM Transactions)
ORDER BY Total_Spending DESC;

--- Question 7 ---

SELECT SUM(Amount) AS Total_Spedning
FROM Transactions
GROUP BY Applicant_Id
HAVING MONTH(1,2,3,4,5,6,7,8.9,10,11,12);

--- Question 8 ---

SELECT A.Applicant_Id, Annual_Income, SUM(Amount) AS Total_Spending
FROM Transactions T
JOIN Applicants A
ON A.Applicant_Id = T.Applicant_Id
GROUP BY Applicant_Id
ORDER BY (Annual_Income/ Total_Spending) DESC;

--- Question 9 ---

WITH Applicant_Total_Spending AS (
SELECT Applicant_Id, SUM(Amount) AS Total_Spending
FROM Transactions
GROUP BY Applicant_Id)
SELECT
	CASE
		WHEN Total_Spending < 200 THEN "Low Total Spend"
        WHEN Total_Spending BETWEEN 200 AND 400 THEN "Moderate Total Spend"
        WHEN Total_Spending BETWEEN 400 AND 600 THEN "High Total Spend"
        ELSE "Extremely High Total Spend"
        END AS Spending_Category,
        COUNT(*) AS Total_Applicants
        FROM Applicant_Total_Spending
        GROUP BY Spending_Category
        ORDER BY Total_Applicants DESC;

    --- Question 10 ---
    
SELECT SUM(Amount) AS Total_Grocery_Spending
FROM Transactions T
INNER JOIN Applicants A
ON A.Applicant_Id = T.Applicant_Id
WHERE A.Credit_Score < 650
AND T.Category = "Groceries";