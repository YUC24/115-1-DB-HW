WITH product_sales AS (
    SELECT
        p.id AS product_id,
        p.name AS product_name,
        COALESCE(SUM(sd.qty), 0) AS total_quantity
    FROM product p
    LEFT JOIN sales_detail sd
        ON p.id = sd.product_id
    GROUP BY p.id, p.name
),
ranked_products AS (
    SELECT
        product_id,
        product_name,
        total_quantity,
        ROW_NUMBER() OVER (
            ORDER BY total_quantity DESC, product_id ASC
        ) AS ranking
    FROM product_sales
),
selected_products AS (
    SELECT
        product_id,
        product_name
    FROM ranked_products
    WHERE ranking IN (4, 5)
),
relevant_stores AS (
    SELECT DISTINCT
        s.store_id
    FROM sales s
    JOIN sales_detail sd
        ON s.receipt_no = sd.receipt_no
    JOIN selected_products sp
        ON sd.product_id = sp.product_id
),
sales_summary AS (
    SELECT
        sd.product_id,
        s.store_id,
        COUNT(DISTINCT sd.receipt_no) AS transaction_count,
        SUM(sd.qty) AS total_sales_quantity
    FROM sales_detail sd
    JOIN sales s
        ON sd.receipt_no = s.receipt_no
    JOIN selected_products sp
        ON sd.product_id = sp.product_id
    GROUP BY
        sd.product_id,
        s.store_id
)
SELECT
    sp.product_id,
    sp.product_name,
    rs.store_id,
    COALESCE(ss.transaction_count, 0) AS transaction_count,
    COALESCE(ss.total_sales_quantity, 0) AS total_sales_quantity
FROM selected_products sp
CROSS JOIN relevant_stores rs
LEFT JOIN sales_summary ss
    ON sp.product_id = ss.product_id
   AND rs.store_id = ss.store_id
ORDER BY
    sp.product_id,
    rs.store_id;