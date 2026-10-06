SELECT
    E.Ssn,
    E.Fname,
    E.Lname,
    COUNT(W.Pno) AS ProjectCount,
    SUM(W.Hours) AS TotalHours
FROM EMPLOYEE E
JOIN WORKS_ON W
    ON E.Ssn = W.Essn
GROUP BY
    E.Ssn,
    E.Fname,
    E.Lname
HAVING COUNT(W.Pno) >= 2
ORDER BY
    ProjectCount DESC,
    E.Ssn ASC;