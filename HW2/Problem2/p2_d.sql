SELECT DISTINCT
    e.Ssn,
    e.Lname,
    CASE
        WHEN e.Salary >= 40000 THEN 'yes'
        ELSE 'no'
    END AS SalaryAtLeast40000,
    d.Mgr_ssn,
    m.Lname AS Mgr_Lname
FROM EMPLOYEE AS e
JOIN DEPARTMENT AS d
    ON e.Dno = d.Dnumber
JOIN EMPLOYEE AS m
    ON d.Mgr_ssn = m.Ssn
JOIN WORKS_ON AS w
    ON e.Ssn = w.Essn
WHERE w.Pno IN
(
    SELECT Pno
    FROM WORKS_ON
    GROUP BY Pno
    HAVING COUNT(*) > 1
);
