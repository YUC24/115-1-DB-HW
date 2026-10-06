SELECT
    S.Ssn,
    S.Fname,
    S.Lname,
    COUNT(E.Ssn) AS DirectReportCount,
    AVG(E.Salary) AS AverageSalary
FROM EMPLOYEE S
JOIN EMPLOYEE E
    ON S.Ssn = E.Super_ssn
GROUP BY
    S.Ssn,
    S.Fname,
    S.Lname
ORDER BY
    DirectReportCount DESC,
    S.Ssn ASC;