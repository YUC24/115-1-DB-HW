import pandas as pd
import duckdb
import psycopg2

# --------------------------------------------------
# Problem 4(a)
# --------------------------------------------------

# 1. Connect to PostgreSQL
pg_conn = psycopg2.connect(dbname="online_learning")

# 2. Read the four tables from PostgreSQL into pandas DataFrames
subscriptions = pd.read_sql(
    "SELECT * FROM subscriptions",
    pg_conn
)

statechanges = pd.read_sql(
    "SELECT * FROM statechanges",
    pg_conn
)

usermissions = pd.read_sql(
    "SELECT * FROM usermissions",
    pg_conn
)

answers = pd.read_sql(
    "SELECT * FROM answers",
    pg_conn
)

# Close PostgreSQL connection
pg_conn.close()

# 3. Create a DuckDB connection
con = duckdb.connect()

# 4. Register the pandas DataFrames in DuckDB
con.register("subscriptions", subscriptions)
con.register("statechanges", statechanges)
con.register("usermissions", usermissions)
con.register("answers", answers)

# 5. Find answer records created during no-subscription periods
query = """
SELECT
    a.answerid,
    a.userid,
    a.questionid,
    a.missionid,
    a.iscorrect,
    a.costtime,
    a.createdat,
    MAX(s.endedat) AS endedat
FROM answers a
JOIN subscriptions s
    ON a.userid = s.subscriberid
   AND a.createdat > s.endedat
WHERE a.createdat >= TIMESTAMP '2021-05-01'
  AND NOT EXISTS (
      SELECT 1
      FROM subscriptions active_s
      WHERE active_s.subscriberid = a.userid
        AND active_s.createdat <= a.createdat
        AND (
            active_s.endedat IS NULL
            OR active_s.endedat >= a.createdat
        )
  )
GROUP BY
    a.answerid,
    a.userid,
    a.questionid,
    a.missionid,
    a.iscorrect,
    a.costtime,
    a.createdat
ORDER BY a.answerid
"""

# 6. Execute the query
result = con.execute(query).df()

# 7. Display the number of records and first five rows
print("Number of answer records:", len(result))
print(result.head(5))

# 8. Save the result for Problem 4(b)
result.to_csv("p4_a_result.csv", index=False)

# Close DuckDB connection
con.close()