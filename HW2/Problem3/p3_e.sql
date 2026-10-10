WITH dates AS (
    SELECT DISTINCT DATE(date_time) AS sale_date
    FROM sales
),
daily_sales AS (
    SELECT
        DATE(s.date_time) AS sale_date,
        sd.product_id,
        SUM(sd.unit_price * sd.qty) AS total_sales_amount
    FROM sales s
    JOIN sales_detail sd
        ON s.receipt_no = sd.receipt_no
    GROUP BY
        DATE(s.date_time),
        sd.product_id
),
all_product_dates AS (
    SELECT
        d.sale_date,
        p.id AS product_id,
        COALESCE(ds.total_sales_amount, 0) AS total_sales_amount
    FROM dates d
    CROSS JOIN product p
    LEFT JOIN daily_sales ds
        ON d.sale_date = ds.sale_date
       AND p.id = ds.product_id
)
SELECT
    sale_date,
    product_id,
    total_sales_amount,
    RANK() OVER (
        PARTITION BY sale_date
        ORDER BY total_sales_amount DESC
    ) AS daily_rank
FROM all_product_dates
ORDER BY
    sale_date,
    daily_rank,
    product_id;