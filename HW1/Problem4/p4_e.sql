SELECT DISTINCT
    E.Ssn,
    E.Fname,
    E.Lname,
    D.Dname
FROM EMPLOYEE E
JOIN WORKS_ON W
    ON E.Ssn = W.Essn
JOIN PROJECT P
    ON W.Pno = P.Pnumber
JOIN DEPARTMENT D
    ON E.Dno = D.Dnumber
WHERE E.Dno <> P.Dnum;