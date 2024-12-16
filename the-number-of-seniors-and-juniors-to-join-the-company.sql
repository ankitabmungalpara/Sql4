"""
  
Table: Candidates
+-------------+------+
| Column Name | Type |
+-------------+------+
| employee_id | int  |
| experience  | enum |
| salary      | int  |
+-------------+------+
employee_id is the column with unique values for this table.
experience is an ENUM (category) type of values ('Senior', 'Junior').
Each row of this table indicates the id of a candidate, their monthly salary, and their experience.

A company wants to hire new employees. The budget of the company for the salaries is $70000. The company's criteria for hiring are:

Hiring the largest number of seniors.
After hiring the maximum number of seniors, use the remaining budget to hire the largest number of juniors.
Write a solution to find the number of seniors and juniors hired under the mentioned criteria.

Return the result table in any order.

The result format is in the following example.

Input: 
Candidates table:
+-------------+------------+--------+
| employee_id | experience | salary |
+-------------+------------+--------+
| 1           | Junior     | 10000  |
| 9           | Junior     | 10000  |
| 2           | Senior     | 20000  |
| 11          | Senior     | 20000  |
| 13          | Senior     | 50000  |
| 4           | Junior     | 40000  |
+-------------+------------+--------+
Output: 
+------------+---------------------+
| experience | accepted_candidates |
+------------+---------------------+
| Senior     | 2                   |
| Junior     | 2                   |
+------------+---------------------+

"""

-- method: Tiered Cumulative Salary Allocation 

with senior as(
    (
        select 
            *, sum(salary) over(order by salary) as cum_salary 
        from 
            Candidates 
        where 
            experience = "Senior") 
    ),

junior as(
    (
        select 
            *, sum(salary) over(order by salary) as cum_salary 
        from 
            Candidates 
        where 
            experience = "Junior") 
    ), 

hires_s as (
            select 
                count(*) as total_s 
            from 
                senior 
            where 
                cum_salary <= 70000
            ),
remain_budget as (
    select 70000 - coalesce((
                                select 
                                    cum_salary 
                                from 
                                    senior 
                                where 
                                    cum_salary <= 70000
                                order by 
                                    cum_salary desc
                                limit 
                                    1), 
                                0
                            ) as budget
),
hires_j as (
            select 
                count(*) as total_j 
            from 
                junior, remain_budget
            where 
                junior.cum_salary <= remain_budget.budget
        )

select 
    'Senior' as experience,
    total_s as accepted_candidates 
from
    hires_s
union 
select 
    'Junior' as experience,
    total_j as accepted_candidates 
from 
    hires_j;
