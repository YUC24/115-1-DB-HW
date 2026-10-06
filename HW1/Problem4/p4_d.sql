SELECT
    P.Pnumber,
    P.Pname,
    COUNT(W.Essn) AS EmployeeCount,
    SUM(W.Hours) AS TotalHours
FROM PROJECT P
JOIN WORKS_ON W
    ON P.Pnumber = W.Pno
GROUP BY
    P.Pnumber,
    P.Pname
HAVING COUNT(W.Essn) >= 2;