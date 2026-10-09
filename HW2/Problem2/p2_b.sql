WITH ranked_employee AS (
    SELECT
        e.Dno,
        d.Dname,
        e.Salary,
        ROW_NUMBER() OVER (
            PARTITION BY e.Dno
            ORDER BY e.Salary DESC
        ) AS salary_rank,
        COUNT(*) OVER (
            PARTITION BY e.Dno
        ) AS employee_count
    FROM EMPLOYEE AS e
    JOIN DEPARTMENT AS d
        ON e.Dno = d.Dnumber
)
SELECT
    Dno AS Dnumber,
    Dname,
    Salary
FROM ranked_employee
WHERE employee_count > 1 AND salary_rank = 2;

