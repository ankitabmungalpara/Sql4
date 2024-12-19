"""
  
Table: RequestAccepted
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| requester_id   | int     |
| accepter_id    | int     |
| accept_date    | date    |
+----------------+---------+
(requester_id, accepter_id) is the primary key (combination of columns with unique values) for this table.
This table contains the ID of the user who sent the request, the ID of the user who received the request, and the date when the request was accepted.
 
Write a solution to find the people who have the most friends and the most friends number.

The test cases are generated so that only one person has the most friends.

The result format is in the following example.

Input: 
RequestAccepted table:
+--------------+-------------+-------------+
| requester_id | accepter_id | accept_date |
+--------------+-------------+-------------+
| 1            | 2           | 2016/06/03  |
| 1            | 3           | 2016/06/08  |
| 2            | 3           | 2016/06/08  |
| 3            | 4           | 2016/06/09  |
+--------------+-------------+-------------+
Output: 
+----+-----+
| id | num |
+----+-----+
| 3  | 3   |
+----+-----+
  
"""

-- method 1: count and union all
with cte as(
    select 
        requester_id as id, 
        count(accepter_id) as cnt
    from 
        RequestAccepted
    group by 
        1
    union all
    select 
        accepter_id as id,  
        count(requester_id) as cnt
    from 
        RequestAccepted
    group by 
        1
)

select 
    id, 
    sum(cnt) as num
from 
    cte
group by 
    id
order by
    num desc
limit 
    1

-- method 2 
with cte as(
    select 
        requester_id as id
    from 
        RequestAccepted
    union all
    select 
        accepter_id as id
    from 
        RequestAccepted
)

select 
    id, 
    count(id) as num 
from 
    cte 
group by 
    id 
order by 
    num 
desc limit 
    1;
