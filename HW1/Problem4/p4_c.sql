SELECT
    P.Pnumber,
    P.Pname,
    P.Plocation,
    D.Dname,
    D.Mgr_ssn
FROM PROJECT P
JOIN DEPARTMENT D
    ON P.Dnum = D.Dnumber
WHERE D.Mgr_start_date >= DATE '1980-01-01';