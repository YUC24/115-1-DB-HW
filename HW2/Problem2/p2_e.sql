SELECT
    e.Ssn,
    COUNT(d.Dependent_name) AS DependentCount
FROM EMPLOYEE AS e
LEFT JOIN DEPENDENT AS d
    ON e.Ssn = d.Essn
WHERE NOT EXISTS (
    SELECT *
    FROM EMPLOYEE AS sub
    WHERE sub.Super_ssn = e.Ssn
)
GROUP BY e.Ssn;