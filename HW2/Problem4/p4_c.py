import pandas as pd
import psycopg2
import time
import gc

# --------------------------------------------------
# Problem 4(c)
# --------------------------------------------------

# 1. Connect to PostgreSQL
pg_conn = psycopg2.connect(dbname="online_learning")

# 2. Read Answers and Subscriptions into pandas DataFrames
answers = pd.read_sql(
    "SELECT * FROM answers",
    pg_conn
)

subscriptions = pd.read_sql(
    "SELECT * FROM subscriptions",
    pg_conn
)

pg_conn.close()

cutoff_date = pd.Timestamp("2021-05-01")


# ==================================================
# Program i
# 1. Merge Answers and Subscriptions
# 2. Filter
# 3. Select required columns
# 4. Display first five rows
# ==================================================

start_i = time.perf_counter()

# Step 1: Merge the complete Answers and Subscriptions tables
merged_i = answers.merge(
    subscriptions,
    left_on="userid",
    right_on="subscriberid",
    suffixes=("_answer", "_subscription")
)

# Step 2: Filter after merging
filtered_i = merged_i[
    (merged_i["createdat_answer"] > merged_i["endedat"])
    & (merged_i["createdat_answer"] >= cutoff_date)
]

# Step 3: Select the required columns
result_i = filtered_i[
    [
        "answerid",
        "userid",
        "questionid",
        "missionid",
        "iscorrect",
        "costtime",
        "createdat_answer",
        "endedat"
    ]
].rename(
    columns={"createdat_answer": "createdat"}
)

end_i = time.perf_counter()
time_i = end_i - start_i

# Step 4: Display first five rows
print("========== Program i ==========")
print(result_i.head(5))
print("Number of rows:", len(result_i))
print(f"Execution time: {time_i:.4f} seconds")


# Save only first five rows before clearing intermediate data
head_i = result_i.head(5).copy()

# Free large intermediate DataFrames
del merged_i
del filtered_i
del result_i
gc.collect()


# ==================================================
# Program ii
# 1. Filter Answers first
# 2. Merge with complete Subscriptions
# 3. Filter CreatedAt > EndedAt
# 4. Select required columns
# 5. Display first five rows
# ==================================================

start_ii = time.perf_counter()

# Step 1: Filter Answers first
filtered_answers = answers[
    answers["createdat"] >= cutoff_date
]

# Step 2: Merge the filtered Answers with complete Subscriptions
merged_ii = filtered_answers.merge(
    subscriptions,
    left_on="userid",
    right_on="subscriberid",
    suffixes=("_answer", "_subscription")
)

# Step 3: Filter answers created after subscription ended
filtered_ii = merged_ii[
    merged_ii["createdat_answer"] > merged_ii["endedat"]
]

# Step 4: Select the required columns
result_ii = filtered_ii[
    [
        "answerid",
        "userid",
        "questionid",
        "missionid",
        "iscorrect",
        "costtime",
        "createdat_answer",
        "endedat"
    ]
].rename(
    columns={"createdat_answer": "createdat"}
)

end_ii = time.perf_counter()
time_ii = end_ii - start_ii

# Step 5: Display first five rows
print("\n========== Program ii ==========")
print(result_ii.head(5))
print("Number of rows:", len(result_ii))
print(f"Execution time: {time_ii:.4f} seconds")


# ==================================================
# Comparison
# ==================================================

print("\n========== Comparison ==========")

print(f"Program i execution time : {time_i:.4f} seconds")
print(f"Program ii execution time: {time_ii:.4f} seconds")

if time_i < time_ii:
    print("Program i is faster.")
elif time_ii < time_i:
    print("Program ii is faster.")
else:
    print("The two programs have the same execution time.")