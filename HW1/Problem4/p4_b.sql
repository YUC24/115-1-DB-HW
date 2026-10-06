SELECT
    Fname,
    Lname,
    Bdate,
    Address
FROM EMPLOYEE
WHERE Bdate < DATE '1965-01-01'
    AND Lname LIKE '%e';