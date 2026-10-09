SELECT
    EMPLOYEE.Ssn,
    EMPLOYEE.Bdate,
    COUNT(WORKS_ON.Pno) AS ProjectCount
FROM
    EMPLOYEE
    LEFT JOIN WORKS_ON ON EMPLOYEE.Ssn = WORKS_ON.Essn
WHERE
    Dno IN (
        SELECT
            Dnumber
        FROM
            DEPT_LOCATIONS
        GROUP BY
            Dnumber
        HAVING
            COUNT(Dlocation) >= 2
    )
GROUP BY
    EMPLOYEE.Ssn,
    EMPLOYEE.Bdate;