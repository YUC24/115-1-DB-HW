SELECT
    id AS employee_id,
    CASE
        WHEN birthday < DATE '2000-01-01'
             AND monthly_salary <= 50000 THEN 1
        WHEN birthday < DATE '2000-01-01'
             AND monthly_salary > 50000 THEN 2
        WHEN birthday >= DATE '2000-01-01'
             AND monthly_salary <= 50000 THEN 3
        ELSE 4
    END AS group_number
FROM employee
ORDER BY id;