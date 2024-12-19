"""
  
Table: Teams
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| team_id        | int     |
| team_name      | varchar |
+----------------+---------+
team_id is the column with unique values for this table.
Each row contains information about one team in the league.

Table: Matches
+-----------------+---------+
| Column Name     | Type    |
+-----------------+---------+
| home_team_id    | int     |
| away_team_id    | int     |
| home_team_goals | int     |
| away_team_goals | int     |
+-----------------+---------+
(home_team_id, away_team_id) is the primary key (combination of columns with unique values) for this table.
Each row contains information about one match.
home_team_goals is the number of goals scored by the home team.
away_team_goals is the number of goals scored by the away team.
The winner of the match is the team with the higher number of goals.
 

Write a solution to report the statistics of the league. 
The statistics should be built using the played matches where the winning team gets three points and the losing team gets no points. If a match ends with a draw, both teams get one point.

Each row of the result table should contain:

team_name - The name of the team in the Teams table.
matches_played - The number of matches played as either a home or away team.
points - The total points the team has so far.
goal_for - The total number of goals scored by the team across all matches.
goal_against - The total number of goals scored by opponent teams against this team across all matches.
goal_diff - The result of goal_for - goal_against.
Return the result table ordered by points in descending order. 
If two or more teams have the same points, order them by goal_diff in descending order. If there is still a tie, order them by team_name in lexicographical order.

The result format is in the following example.

Input: 
Teams table:
+---------+-----------+
| team_id | team_name |
+---------+-----------+
| 1       | Ajax      |
| 4       | Dortmund  |
| 6       | Arsenal   |
+---------+-----------+
Matches table:
+--------------+--------------+-----------------+-----------------+
| home_team_id | away_team_id | home_team_goals | away_team_goals |
+--------------+--------------+-----------------+-----------------+
| 1            | 4            | 0               | 1               |
| 1            | 6            | 3               | 3               |
| 4            | 1            | 5               | 2               |
| 6            | 1            | 0               | 0               |
+--------------+--------------+-----------------+-----------------+
Output: 
+-----------+----------------+--------+----------+--------------+-----------+
| team_name | matches_played | points | goal_for | goal_against | goal_diff |
+-----------+----------------+--------+----------+--------------+-----------+
| Dortmund  | 2              | 6      | 6        | 2            | 4         |
| Arsenal   | 2              | 2      | 3        | 3            | 0         |
| Ajax      | 4              | 2      | 5        | 9            | -4        |
+-----------+----------------+--------+----------+--------------+-----------+
  
"""

with cte as(
    select home_team_id as id, home_team_goals as g1, away_team_goals as g2
    from matches
    union 
    select away_team_id as id, away_team_goals as g1, home_team_goals as g2
    from matches
)

select 
    t.team_name, 
    count(id) as matches_played,
    sum(
        case
            when c.g1 > c.g2 then 3
            when c.g1 = c.g2 then 1
            else 0
        end 
    ) as points,
    sum(c.g1) as goal_for,
    sum(c.g2) as goal_against,
    sum(c.g1) - sum(c.g2) as goal_diff
from 
    teams t join cte as c
on 
    t.team_id = c.id
group by 
    c.id
order by 
    points desc, goal_diff desc
