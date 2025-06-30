# nba-clutch-performance-2024-25
A data-driven project to find the most clutch NBA players in the 2024–2025 season using SQL and Python for visualization.

## Project Overview
This project investigates which NBA players were most "clutch" during the 2024–2025 season using the NBA's definition: performance in the last 5 minutes of the 4th quarter or overtime, with a point differential of 5 or fewer. Instead of just analyzing "who scored the most in clutch time", I aim to look at the full picture of clutch performances and take into account different factors that play a role in a player's overall impact—such as efficiency, usage rate, minutes played, game context, and performance under pressure in close or high-stakes situations. While points per 36 minutes in clutch moments gives a basic snapshot of scoring output, it doesn’t tell the full story of a player’s impact in high-pressure situations. Clutch performance is about more than just how many points a player scores — it’s about how efficiently they score, how they contribute to winning, and how well they handle pressure.

That’s why I’m building a weighted equation that takes into account a broader set of metrics, such as:
- Field Goal % and Free Throw % – Are they efficient and reliable under pressure?
- Turnovers per 36 – Do they make costly mistakes when the game is on the line?
- Plus/Minus per 36 – What’s the team’s net performance with them on the floor during clutch time?
- Assists per 36 – Are they creating opportunities for others, not just themselves?
This equation creates a more complete, fair, and context-rich picture of clutch performance — rewarding players who not only score but also make smart decisions, elevate their teammates, and avoid critical errors in the game’s biggest moments.

## Tools Used
- SQL (data manipulation and filtering)
- Python (for visualization only)
- GitHub (documentation and sharing)

## Key Steps
1. Define clutch criteria (using NBA definition) and what the 2024-25 season is composed of (regular season, play in, and playoffs) 
2. Data Collection
- Pulled regular season and playoff clutch data using nba_api in Python (Per Mode set to Totals)
- Manually collected Play-In clutch stats from nba.com/stats into Excel
- Exported each data set to separate .csv files (Regular, Playoffs, Play-In)
3. Data Cleaning
- Cleaned and formatted each CSV  
- Ensured consistency in column naming and structure across all three datasets
- Manually verified that Play-In data was not included in the NBA API or playoff sets
4. SQL Database Setup
- Used DBeaver and SQLite to manage data
- Created custom SQL tables for each of the three datasets: clutch_regular, clutch_playin, and clutch_playoffs
- Added a Season_Type column to each dataset ('Regular', 'Play-In', 'Playoffs') before combining
5. Combined 3 Tables into One Unified Dataset
- Merged the three tables into "clutch_2024_25" combined dataset to get the full 2024-25 season picture
6. Statistical Normalization
- Normalized key performance stats per 36 minutes to control for differing minutes played
- Calculated FG% and FT% across the entire season
7. Min-Max Normalization
- Normalized per 36 minutes stats to be on a 0 to 1 scale using min max normlization so each metric has equal opportunity to influence the final score 
- Formula for Min-Max Normalization: x(normalized) = (x - min(x))/(max(x)-min(x))
8. Weighted Clutch Score Calculation
- Developed a Weighted Clutch Score formula:
  (0.30*points_per_36)+(0.20*fgm_pct)+(0.10*ftm_pct)-(0.15*turnovers_per_36)+(0.15*pm_per_36)+(0.10*assists_per_36)
- Prioritized efficiency and total clutch minutes
9. Visualize and interpret results
10. Rank top clutch players

## Core Metrics 
Instead of just looking at points added in clutch minutes, I will take into account a few other metrics to combine key clutch-time stats, other than points, into one final rating for each player:
1. Points per 36 (normalize per 36) - How many points the player scores in clutch time	
2. FG% - Are they efficient?	
3. FT% - How do they perform under pressure ("free" points) 
4. Turnovers per 36 (normalize per 36) - (subtract)
5. Plus minus per 36 (normalize per 36) - the point difference when a player is on the court
6. Assists per 36 (normalize per 36)

## Weight of metrics for "clutch rating" formula 
1. Points per 36: 30%
2. FG%: 20%
3. FT%: 10%
4. Turnovers per 36: -15%
5. Plus minus per 36: 15%
6. Assists per 36: 10%
   
## Accounting for Fair Comparisons
Not all players have the same number of clutch minutes or opportunities, so to make comparisons meaningful we need to scale data to the same level. If we don’t adjust for time, we're basically rewarding opportunity, not efficiency. Solution: normalize on 36 minute basis (NBA common baseline) 

## Normalization: Clutch volume stats will be normalized by minutes played (e.g., points per 36 clutch minutes)
What normalization does: It puts everyone on a level playing field as if they each played the same amount of time (36 minutes). 36 minutes is standard because it’s close to a full NBA game.
EX: SUM(points) → total clutch points scored
    SUM(clutch_minutes) → total clutch minutes played
    (SUM(points) / SUM(clutch_minutes)) * 36 AS points_per_36 
    Multiplying by 36 = scaling that rate to a common time frame to be able to compare someone who played 6 clutch minutes vs someone who played 30. This shows what that player would produce if they played 36 minutes
    
## Efficiency vs. Volume: Both volume (e.g., total clutch points) and efficiency (e.g., FG%) will be considered to capture players who are consistently reliable — not just those who take a lot of shots.
This approach ensures that the final clutch rankings reflect meaningful performance rather than raw totals or cherry-picked stats

## MinMax Normalization
Putting everything on a 0-1 scale to be able to compare percentages to Per 36 metric

## Folder Structure
- `/data`: raw and cleaned CSVs
- `/sql`: SQL queries
- `/notebooks`: Python visualizations
- `/visuals`: final plots and graphics
- `README.md`: documentation
