SELECT
    p.Pnumber,
    p.Pname,
    COUNT(DISTINCT e.Dno) AS DepartmentCount
FROM PROJECT AS p
LEFT JOIN WORKS_ON AS w
    ON p.Pnumber = w.Pno
LEFT JOIN EMPLOYEE AS e
    ON w.Essn = e.Ssn
GROUP BY
    p.Pnumber,
    p.Pname;