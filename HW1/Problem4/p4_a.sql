SELECT
    Ssn,
    Fname,
    Lname,
    Salary
FROM EMPLOYEE
WHERE Sex = 'F'
    AND Salary >= 25000
ORDER BY
    Salary DESC,
    Lname ASC;