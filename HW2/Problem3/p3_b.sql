WITH store_sales AS (
    SELECT
        s.store_id,
        COUNT(DISTINCT s.receipt_no) AS transaction_count,
        SUM(sd.unit_price * sd.qty) AS total_sales_amount
    FROM sales s
    JOIN sales_detail sd
        ON s.receipt_no = sd.receipt_no
    WHERE s.date_time >= DATE '2025-01-08'
      AND s.date_time < DATE '2025-01-12'
    GROUP BY s.store_id
)
SELECT
    e.id AS employee_id,
    e.store_id,
    COALESCE(ss.transaction_count, 0) AS transaction_count,
    COALESCE(ss.total_sales_amount, 0) AS total_sales_amount
FROM employee e
LEFT JOIN store_sales ss
    ON e.store_id = ss.store_id
ORDER BY e.id;