# nba-clutch-performance-2024-25
A data-driven project to find the most clutch NBA players in the 2024–2025 season using SQL and Python for visualization.

## Project Overview
This project investigates which NBA players were most "clutch" during the 2024–2025 season using the NBA's definition: performance in the last 5 minutes of the 4th quarter or overtime, with a point differential of 5 or fewer. Instead of just analyzing "who scored the most in clutch time", I aim to look at the full picture of clutch performances and take into account different factors that play a role in a player's overall impact—such as efficiency, usage rate, minutes played, game context, and performance under pressure in close or high-stakes situations. 

## Tools Used
- SQL (data manipulation and filtering)
- Python (for visualization only)
- GitHub (documentation and sharing)

## Key Steps
1. Define clutch criteria (using NBA definition)
2. Collect and clean data from NBA API (play in games not available so imported into excel and cleaned dataset manually) 
4. Extract clutch plays using SQL
5. Calculate clutch performance metrics
6. Visualize and interpret results
7. Rank top clutch players

## Core Metrics 
Instead of just looking at points added in clutch minutes, I will take into account a few other metrics to combine key clutch-time stats, other than points, into one final rating for each player:
1. Points per 36 (normalize per 36) - How many points the player scores in clutch time	
2. FG% - Are they efficient?	
3. FT% - How do they perform under pressure ("free" points) 
4. Turnovers per 36 (normalize per 36) - (subtract)
5. plus minus per 36 (normalize per 36) - the point difference when a player is on the court

## Weight of metrics for "clutch rating" formula 
1. 35%
2. 25%
3. 10%
4. -15%
5. 15%
   
## Accounting for Fair Comparisons
Not all players have the same number of clutch minutes or opportunities, so to make comparisons meaningful we need to scale data to the same level. If we don’t adjust for time, we're basically rewarding opportunity, not efficiency. Solution: normalize on 36 minute basis (NBA common baseline) 

**Normalization**: Clutch stats (like points, FG%, and turnovers) will be normalized by minutes played (e.g., points per 36 clutch minutes).
SUM(points) → total clutch points scored
SUM(clutch_minutes) → total clutch minutes played
(SUM(points) / SUM(clutch_minutes)) * 36 AS points_per_36
WHAT: Points per 36 minutes to make it easier to read and compare (36 minutes is standard because it’s close to a full NBA game)
      - Multiplying by 36 = scaling that rate to a common time frame to be able to compare someone who played 6 clutch minutes vs someone who played 30
WHY: It puts everyone on a level playing field as if they each played the same amount of time (36 minutes).
**Efficiency vs. Volume**: Both volume (e.g., total clutch points) and efficiency (e.g., FG%) will be considered to capture players who are consistently reliable — not just those who take a lot of shots.
This approach ensures that the final clutch rankings reflect meaningful performance rather than raw totals or cherry-picked stats

## Folder Structure
- `/data`: raw and cleaned CSVs
- `/sql`: SQL queries
- `/notebooks`: Python visualizations
- `/visuals`: final plots and graphics
- `README.md`: documentation
