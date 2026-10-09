--------------------
Drop Table If Exists Subscriptions;

CREATE TABLE Subscriptions (
  SubscriptionID Varchar(50),
  PlanID Varchar(50),
  PayerID Varchar(50),
  SubscriberID Varchar(50),
  CreatedAt Timestamp, 
  EndedAt Timestamp
);
--------------------
Drop Table If Exists StateChanges;

CREATE TABLE StateChanges (
  SubscriptionID Varchar(50),
  FromState Varchar(15), 
  ToState Varchar(15),
  CreatedAt Timestamp
);
--------------------
Drop Table If Exists UserMissions;

CREATE TABLE UserMissions (
  UserMissionID Varchar(50),
  UserID Varchar(50),
  MissionID Varchar(50),
  Status Varchar(50), 
  CorrectCnt Numeric, 
  AnsweredCnt Numeric,
  AnswerDuration Numeric,
  StartedAt Timestamp, 
  FinishedAt Timestamp,
  CreatedAt Timestamp
);
--------------------
Drop Table If Exists Answers;

CREATE TABLE Answers (
  AnswerID Varchar(50),
  UserID Varchar(50),
  QuestionID Varchar(50),
  MissionID Varchar(50),
  IsCorrect Int,
  CostTime Int,
  CreatedAt Timestamp
);
--------------------




\copy Subscriptions FROM '/Users/chengyou/Documents/Patrick_OS/大學/資料庫管理/Code_程式碼/115-1-DB-HW/HW2/Problem5/ONLINE_LEARNING_CSV/subscriptions.csv' DELIMITER ',' CSV HEADER;
\copy StateChanges FROM '/Users/chengyou/Documents/Patrick_OS/大學/資料庫管理/Code_程式碼/115-1-DB-HW/HW2/Problem5/ONLINE_LEARNING_CSV/state_changes.csv' DELIMITER ',' CSV HEADER;
\copy UserMissions FROM '/Users/chengyou/Documents/Patrick_OS/大學/資料庫管理/Code_程式碼/115-1-DB-HW/HW2/Problem5/ONLINE_LEARNING_CSV/user_missions.csv' DELIMITER ',' CSV HEADER;
\copy Answers FROM '/Users/chengyou/Documents/Patrick_OS/大學/資料庫管理/Code_程式碼/115-1-DB-HW/HW2/Problem5/ONLINE_LEARNING_CSV/answers.csv' DELIMITER ',' CSV HEADER;






--------------------
Select * 
From Subscriptions;

Select * 
From StateChanges;

Select * 
From UserMissions;

Select * 
From Answers;
--------------------
Select Count(*) 
From Subscriptions;

Select Count(*) 
From StateChanges;

Select Count(*)
From UserMissions;

Select Count(*)
From Answers;
--------------------
Select 'Subscriptions' As TableName, Count(*) As RecordCnt 
From Subscriptions
Union
Select 'StateChanges' As TableName, Count(*) As RecordCnt 
From StateChanges
Union
Select 'UserMissions' As TableName, Count(*) As RecordCnt 
From UserMissions
Union
Select 'Answers' As TableName, Count(*) As RecordCnt 
From Answers
--------------------