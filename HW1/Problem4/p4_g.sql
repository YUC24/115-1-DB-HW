SELECT
    D.Dnumber,
    D.Dname,
    COUNT(E.Ssn) AS EmployeeCount,
    AVG(E.Salary) AS AverageSalary
FROM DEPARTMENT D
JOIN EMPLOYEE E
    ON D.Dnumber = E.Dno
GROUP BY
    D.Dnumber,
    D.Dname
HAVING COUNT(E.Ssn) >= 3
ORDER BY
    AverageSalary DESC;