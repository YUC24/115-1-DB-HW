import pandas as pd
import duckdb
import matplotlib.pyplot as plt

# --------------------------------------------------
# Problem 4(b)
# --------------------------------------------------

# 1. Read the answer records obtained in Problem 4(a)
result = pd.read_csv("p4_a_result.csv")

# 2. Create a DuckDB connection
con = duckdb.connect()

# 3. Register the DataFrame in DuckDB
con.register("post_subscription_answers", result)

# 4. Calculate each user's average time spent per question
#    and overall answer accuracy
query = """
SELECT
    userid,
    AVG(costtime) AS avg_time,
    AVG(CAST(iscorrect AS DOUBLE)) AS accuracy
FROM post_subscription_answers
GROUP BY userid
ORDER BY userid
"""

user_stats = con.execute(query).df()

# 5. Display the number of users and first five rows
print("Number of users:", len(user_stats))
print(user_stats.head(5))

# 6. Calculate the medians
median_time = user_stats["avg_time"].median()
median_accuracy = user_stats["accuracy"].median()

print("Median average time:", median_time)
print("Median accuracy:", median_accuracy)

# 7. Keep only observations with average time <= 50 seconds
#    for the scatter plot
plot_data = user_stats[user_stats["avg_time"] <= 50]

# 8. Create scatter plot
plt.figure(figsize=(8, 6))

plt.scatter(
    plot_data["avg_time"],
    plot_data["accuracy"],
    alpha=0.6
)

# Vertical line: median average time
plt.axvline(
    x=median_time,
    linestyle="--",
    label="Median Average Time"
)

# Horizontal line: median accuracy
plt.axhline(
    y=median_accuracy,
    linestyle="--",
    label="Median Accuracy"
)

plt.xlabel("Average Time Spent per Question (seconds)")
plt.ylabel("Overall Answer Accuracy")
plt.title("Average Answer Time vs. Overall Accuracy")

plt.legend()
plt.tight_layout()

# 9. Save the figure
plt.savefig("p4_b_scatter.png", dpi=300)

# 10. Display the figure
plt.show()

# Close DuckDB connection
con.close()