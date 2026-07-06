--- Finance Credit Risk Analytics Project ---

--- Part 2: Application & Underwriting Processes ---

--- Question 1 ---

SELECT IFNULL(Apps.Approval_Status, "Declined") AS Approval_Status, App.Credit_Score
FROM Applicants App
LEFT JOIN Applications Apps
ON App.Applicant_Id = Apps.Applicant_Id
GROUP BY IFNULL(Apps.Approval_Status, "Declined"), App.Credit_Score
ORDER BY App.Credit_Score DESC;

--- Question 2 ---

SELECT Card_Product, AVG(Assigned_Credit_Line) As Average_Assigned_Credit_Line
FROM Applications
GROUP BY Card_Product
HAVING Average_Assigned_Credit_Line
ORDER BY Average_Assigned_Credit_Line DESC;

--- Question 3 ---

WITH Declined_Applications AS
(SELECT Applicant_Id, Decline_Reason
FROM Applications
WHERE Approval_Status = "Declined") 
SELECT COUNT(*) As Declined_Applicants, Decline_Reason
FROM Declined_Applications
GROUP BY Decline_Reason;

--- Question 4 --- 

SELECT Applicant_Id, Requested_Credit_Line, Assigned_Credit_Line
FROM Applications
WHERE Requested_Credit_Line > Assigned_Credit_Line;

--- Question 5 ---

SELECT Applicant_Id, Assigned_Credit_Line, Assigned_Interest_Rate,
DENSE_RANK() OVER(ORDER BY Assigned_Credit_Line DESC) AS Credit_Line_Rank
FROM Applications;

--- Question 6 ---

SELECT AVG(Assigned_Interest_Rate) AS Average_Assigned_Interest_Rate
FROM Applications
WHERE Approval_Status = "Approved";

--- Question 7 ---

SELECT Applications.Applicant_Id, Credit_Score
FROM Applications
LEFT JOIN Applicants
ON Applications.Applicant_Id = Applicants.Applicant_Id
WHERE Credit_Score <
(SELECT AVG(Credit_Score) AS Average_Credit_Score
FROM Applications
LEFT JOIN Applicants
ON Applications.Applicant_Id = Applicants.Applicant_Id
WHERE Approval_Status = "Approved")
ORDER BY Credit_Score DESC;

--- Question 8 ---

SELECT COUNT(Applicants.Applicant_Id) AS Total_Applicants, Employment_Status, IFNULL(Approval_Status, "Declined") AS Approval_Status
FROM Applicants
LEFT JOIN Applications
ON Applications.Applicant_Id = Applicants.Applicant_Id
GROUP BY Employment_Status, IFNULL(Approval_Status, "Declined")
ORDER BY Total_Applicants DESC;

--- Question 9 ---

SELECT Applicants.Applicant_Id, Debt_To_Income
FROM Applicants
LEFT JOIN Applications
ON Applications.Applicant_Id = Applicants.Applicant_Id
WHERE Debt_To_Income > 0.30 AND Approval_Status = "Approved";

--- Question 10 ---

SELECT 
	CASE
		WHEN Requested_Credit_Line > Assigned_Credit_Line THEN "Over-Requested"
        WHEN Assigned_Credit_Line <= Requested_Credit_Line THEN "Within-Range"
	END AS Application_Credit_Status,
	COUNT(*) AS Total_Applications
    FROM Applications
    WHERE Approval_Status = "Approved"
    GROUP BY Application_Credit_Status