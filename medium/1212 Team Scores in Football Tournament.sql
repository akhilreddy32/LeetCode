-- Table: Teams
-- +---------------+----------+
-- | Column Name   | Type     |
-- +---------------+----------+
-- | team_id       | int      |
-- | team_name     | varchar  |
-- +---------------+----------+
-- team_id is the column with unique values of this table.
-- Each row of this table represents a single football team.

-- Table: Matches
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | match_id      | int     |
-- | host_team     | int     |
-- | guest_team    | int     | 
-- | host_goals    | int     |
-- | guest_goals   | int     |
-- +---------------+---------+
-- match_id is the column of unique values of this table.
-- Each row is a record of a finished match between two different teams. 
-- Teams host_team and guest_team are represented by their IDs in the Teams table (team_id), and they scored host_goals and guest_goals goals, respectively.

-- You would like to compute the scores of all teams after all matches. Points are awarded as follows:
-- A team receives three points if they win a match (i.e., Scored more goals than the opponent team).
-- A team receives one point if they draw a match (i.e., Scored the same number of goals as the opponent team).
-- A team receives no points if they lose a match (i.e., Scored fewer goals than the opponent team).
-- Write a solution that selects the team_id, team_name and num_points of each team in the tournament after all described matches.
-- Return the result table ordered by num_points in decreasing order. In case of a tie, order the records by team_id in increasing order.

-- Example 1:

-- Input: 
-- Teams table:
-- +-----------+--------------+
-- | team_id   | team_name    |
-- +-----------+--------------+
-- | 10        | Leetcode FC  |
-- | 20        | NewYork FC   |
-- | 30        | Atlanta FC   |
-- | 40        | Chicago FC   |
-- | 50        | Toronto FC   |
-- +-----------+--------------+
-- Matches table:
-- +------------+--------------+---------------+-------------+--------------+
-- | match_id   | host_team    | guest_team    | host_goals  | guest_goals  |
-- +------------+--------------+---------------+-------------+--------------+
-- | 1          | 10           | 20            | 3           | 0            |
-- | 2          | 30           | 10            | 2           | 2            |
-- | 3          | 10           | 50            | 5           | 1            |
-- | 4          | 20           | 30            | 1           | 0            |
-- | 5          | 50           | 30            | 1           | 0            |
-- +------------+--------------+---------------+-------------+--------------+
-- Output: 
-- +------------+--------------+---------------+
-- | team_id    | team_name    | num_points    |
-- +------------+--------------+---------------+
-- | 10         | Leetcode FC  | 7             |
-- | 20         | NewYork FC   | 3             |
-- | 50         | Toronto FC   | 3             |
-- | 30         | Atlanta FC   | 1             |
-- | 40         | Chicago FC   | 0             |
-- +------------+--------------+---------------+

-- Solution

with cte as
(
    select *,
    case 
      when host_goals>guest_goals then 3
      when host_goals<guest_goals then 0
      else 1
      end as host_points,
    case 
      when guest_goals>host_goals then 3
      when guest_goals<host_goals then 0
      else 1
      end as guest_points
    from matches
),
cte1 as
(
    select host_team as team_id,
    host_points as num_points
    from cte
  
    union all
  
    select guest_team as team_id,
    guest_points as num_points
    from cte
)
select coalesce(c1.team_id,t.team_id) as team_id,
  team_name,
  isnull(sum(num_points),0) as num_points
from cte1 c1
full outer join teams t
  on c1.team_id=t.team_id
group by coalesce(c1.team_id,t.team_id), team_name
order by num_points desc, team_id



