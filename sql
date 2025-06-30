CREATE TABLE clutch_regular (
  PLAYER_NAME TEXT,
  PLAYER_ID TEXT,
  TEAM_ABBREVIATION TEXT,
  MIN REAL,
  PTS REAL,
  FG_PCT REAL,
  FT_PCT REAL,
  TOV REAL,
  PLUS_MINUS REAL
);

CREATE TABLE clutch_playin (
  PLAYER_NAME TEXT,
  PLAYER_ID TEXT,
  TEAM_ABBREVIATION TEXT,
  MIN REAL,
  PTS REAL,
  FG_PCT REAL,
  FT_PCT REAL,
  TOV REAL,
  PLUS_MINUS REAL
);

CREATE TABLE clutch_playoff (
  PLAYER_NAME TEXT,
  PLAYER_ID TEXT,
  TEAM_ABBREVIATION TEXT,
  MIN REAL,
  PTS REAL,
  FG_PCT REAL,
  FT_PCT REAL,
  TOV REAL,
  PLUS_MINUS REAL
);

## Combining 3 seperate data sets into one aggregate 2024-2025 season table (regular season + play in + play offs)
CREATE TABLE clutch_2024_25 AS 
SELECT player_name, team_abbreviation, min, pts, fg_pct, ft_pct, tov, plus_minus, 'Regular' AS season_type
FROM clutch_regular 
UNION ALL 
SELECT player_name, team_abbreviation, min, pts, fg_pct, ft_pct, tov, plus_minus, 'Playoff' AS season_type
FROM clutch_playoff
UNION ALL 
SELECT player_name, team_abbreviation, min, pts, fg_pct, ft_pct, tov, plus_minus, 'Play In' AS season_type
FROM clutch_playin;

## Create new table that aggregates player data across the three sections of the season  
CREATE TABLE player_info AS
SELECT PLAYER_NAME, TEAM_ABBREVIATION, SUM(MIN) AS Total_minutes
, SUM(PTS) AS Total_points
, SUM(TOV) AS Total_turnover
, SUM(PLUS_MINUS) AS Total_PlusMinus 
, SUM(FGM) AS Total_FGM
, SUM(FGA) AS Total_FGA
, SUM(FG3M) AS Total_FG3M
, SUM(FG3A) AS Total_FG3A
, SUM(FTM) AS Total_FTM
, SUM(FTA) AS Total_FTA
, SUM(AST) AS Total_assists
, (SUM(PTS)/SUM(MIN))*36 AS Points_Per_36
, (SUM(AST)/SUM(MIN))*36 AS Assists_Per_36
, (SUM(TOV)/SUM(MIN))*36 AS Turnovers_Per_36
, (SUM(PLUS_MINUS)/SUM(MIN))*36 AS PlusMinus_Per_36
, (SUM(FGM)/SUM(FGA)) AS FGM_PCT
, (SUM(FG3M)/SUM(FG3A)) AS FG3M_PCT
, (SUM(FTM)/SUM(FTA)) AS FT_PCT
FROM clutch_2024_25
GROUP BY PLAYER_NAME 
HAVING SUM(MIN) >= 20
ORDER BY Points_per_36 DESC;

## Find max and min for per 36 minute metrics in order to min-max normalize 
CREATE TABLE stat_bounds AS
SELECT MIN(Points_Per_36) AS min_pts, MAX(Points_Per_36) AS max_pts
, MIN(Assists_Per_36) AS min_assists, MAX(Assists_Per_36) AS max_assists
, MIN(Turnovers_Per_36) AS min_turnovers, MAX(Turnovers_Per_36) AS max_turnovers
, MIN(PlusMinus_Per_36) AS min_pm, MAX(PlusMinus_Per_36) AS max_pm
FROM stats_per36;

## Creates new table with player_info joined with the max/min values for all per 36 minute stats and calculates max-min normalization for per 36 minute stats
CREATE TABLE scaled AS 
SELECT * , (points_per_36 - min_pts)/(max_pts - min_pts) AS pts_scaled
,(assists_per_36 - min_assists)/(max_assists - min_assists) AS assists_scaled 
,(turnovers_per_36 - min_turnovers)/(max_turnovers - min_turnovers) AS turnovers_scaled 
,(PlusMinus_Per_36 - min_pm)/(max_pm - min_pm) AS plusminus_scaled 
FROM player_info CROSS JOIN stat_bounds;

## Calculate each players clutch value using personalized "clutch formula"
SELECT PLAYER_NAME, ((0.35*pts_scaled) + (0.20*FGM_PCT) + (0.10*FT_PCT) - (0.10*turnovers_scaled) + (0.15*plusminus_scaled)+(0.10*assists_scaled)) AS clutch_rating
FROM scaled
ORDER BY clutch_rating DESC;
