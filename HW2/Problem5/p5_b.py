from pathlib import Path
import pandas as pd
import duckdb
import matplotlib.pyplot as plt

BASE_DIR = Path(__file__).resolve().parent
DATA_DIR = BASE_DIR / "ONLINE_LEARNING_CSV"

answers_df = pd.read_csv(DATA_DIR / "answers.csv")
answers_df["CreatedAt"] = pd.to_datetime(answers_df["CreatedAt"])

con = duckdb.connect()
con.register("Answers", answers_df)

leaderboard_score = con.sql("""
    WITH difficult_questions AS (
        SELECT
            QuestionID

        FROM Answers

        GROUP BY QuestionID

        HAVING COUNT(*) >= 800
           AND SUM(
                CASE
                    WHEN IsCorrect = 1 THEN 1
                    ELSE 0
                END
           ) <= 400
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

    leaderboard AS (
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
    ),

    top_five AS (
        SELECT
            QuestionID,
            UserID,
            leaderboard_rank,

            CASE
                WHEN leaderboard_rank = 1 THEN 4
                WHEN leaderboard_rank = 2 THEN 2
                WHEN leaderboard_rank = 3 THEN 1
                ELSE 0
            END AS Score

        FROM leaderboard

        WHERE leaderboard_rank <= 5
    ),

    score_summary AS (
        SELECT
            UserID,
            SUM(Score) AS LeaderboardScore

        FROM top_five

        GROUP BY UserID
    )

    SELECT
        UserID,
        LeaderboardScore

    FROM score_summary

    ORDER BY
        LeaderboardScore DESC,
        UserID ASC
""").df()


print("=== Leaderboard Scores of All Users ===")
print(leaderboard_score)



qualified_users = leaderboard_score[
    leaderboard_score["LeaderboardScore"] >= 5
].copy()


qualified_users = qualified_users.sort_values(
    by=["LeaderboardScore", "UserID"],
    ascending=[False, True]
)


print("\n=== Users With Leaderboard Score >= 5 ===")
print(qualified_users)



plot_data = (
    qualified_users
    .sort_values(by="UserID", ascending=True)
    .head(10)
)


print("\n=== Data Used in the Bar Chart ===")
print(plot_data)

plt.figure(figsize=(12, 7))

plt.bar(
    plot_data["UserID"],
    plot_data["LeaderboardScore"]
)

plt.xlabel("User ID")
plt.ylabel("Leaderboard Score")
plt.title("Leaderboard Scores of Selected Users")

plt.xticks(rotation=45)

plt.tight_layout()
plt.show()

con.close()