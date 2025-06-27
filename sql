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



