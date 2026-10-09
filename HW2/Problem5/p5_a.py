from pathlib import Path
import pandas as pd
import duckdb
import matplotlib.pyplot as plt

BASE_DIR = Path(__file__).resolve().parent
DATA_DIR = BASE_DIR / "ONLINE_LEARNING_CSV"

subscriptions_df = pd.read_csv(DATA_DIR / "subscriptions.csv")
state_changes_df = pd.read_csv(DATA_DIR / "state_changes.csv")
user_missions_df = pd.read_csv(DATA_DIR / "user_missions.csv")
answers_df = pd.read_csv(DATA_DIR / "answers.csv")

answers_df["CreatedAt"] = pd.to_datetime(answers_df["CreatedAt"])

con = duckdb.connect()

con.register("Subscriptions", subscriptions_df)
con.register("StateChanges", state_changes_df)
con.register("UserMissions", user_missions_df)
con.register("Answers", answers_df)

leaderboard = con.sql("""
    WITH difficult_questions AS (
        SELECT QuestionID
        FROM Answers
        GROUP BY QuestionID
        HAVING COUNT(*) >= 800
           AND SUM(CASE WHEN IsCorrect = 1 THEN 1 ELSE 0 END) <= 400
    ),

    first_correct AS (
        SELECT
            AnswerID,
            UserID,
            QuestionID,
            MissionID,
            IsCorrect,
            CostTime,
            CreatedAt,
            ROW_NUMBER() OVER (
                PARTITION BY QuestionID, UserID
                ORDER BY CreatedAt ASC
            ) AS first_correct_rank
        FROM Answers
        WHERE IsCorrect = 1
          AND QuestionID IN (
              SELECT QuestionID
              FROM difficult_questions
          )
    ),

    ranked AS (
        SELECT
            QuestionID,
            UserID,
            CostTime,
            CreatedAt,
            ROW_NUMBER() OVER (
                PARTITION BY QuestionID
                ORDER BY CostTime ASC, CreatedAt ASC
            ) AS leaderboard_rank
        FROM first_correct
        WHERE first_correct_rank = 1
    )

    SELECT
        QuestionID,
        UserID,
        CostTime,
        CreatedAt,
        leaderboard_rank
    FROM ranked
    WHERE leaderboard_rank <= 5
    ORDER BY QuestionID, leaderboard_rank
""").df()

print("=== Difficult Question Speed-Solving Leaderboard ===")
print(leaderboard.head(10))

con.register("Leaderboard", leaderboard)

leaderboard_summary = con.sql("""
    SELECT
        UserID,
        COUNT(*) AS QuestionCount
    FROM Leaderboard
    GROUP BY UserID
    HAVING COUNT(*) >= 2
    ORDER BY UserID ASC
""").df()

print("\n=== Users Appearing on At Least Two Leaderboards ===")
print(leaderboard_summary)

plot_data = leaderboard_summary.sort_values(by="UserID", ascending=True).head(10)

print("\n=== Data Used in the Bar Chart ===")
print(plot_data)

plt.figure(figsize=(12, 7))
plt.bar(plot_data["UserID"], plot_data["QuestionCount"])
plt.xlabel("User ID")
plt.ylabel("Number of Leaderboard Appearances")
plt.title("Difficult Question Speed-Solving Leaderboard")
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()

con.close()