


-- how to use round in SQL
SELECT
  ROUND(watch_duration_in_minutes,0) as duration,
  COUNT(*) as count
FROM watch_history
GROUP BY duration
ORDER BY duration ASC;

-- how to use having
SELECT
user_id,
SUM(watch_duration_in_minutes) as total_watch
FROM watch_history
GROUP BY user_id
HAVING total_watch > 400;

--rounding a sum
SELECT
ROUND(SUM(watch_duration_in_minutes),0)
FROM watch_history;

-- average
SELECT
AVG(amount) as payment
FROM payments
WHERE status = 'paid';

-- case statement
SELECT
COUNT(url),
CASE
	WHEN url LIKE '%github.com%' THEN 'Github'
	WHEN url LIKE '%medium.com%' THEN 'Medium'
	WHEN url LIKE '%nytimes.com%' THEN 'NYT'
	ELSE 'Other'
END AS 'Source'
FROM hacker_news
GROUP BY 2;

-- how to use strftime
SELECT
strftime('%H', timestamp) AS hour,
	ROUND(AVG(score), 2) AS average,
	COUNT(*) AS title
FROM hacker_news
WHERE timestamp IS NOT NULL
GROUP BY 1;

-- LEFT JOIN matches everything from the left over to the right, includes nulls

SELECT *
FROM
trips LEFT JOIN riders
ON trips.rider_id = riders.id;

-- UNION merges 2 tables
SELECT *
FROM
riders
UNION
SELECT * 
FROM
riders2;
-- union with where clause
SELECT * 
FROM riders
WHERE total_trips < 500
UNION
SELECT *
FROM riders2
WHERE total_trips < 500;

-- find top 2 from a table
SELECT
*
FROM cars
ORDER BY trips_completed DESC
LIMIT 2;

-- update a column use SET
UPDATE patients 
SET Status = "active" 
WHERE ID = 7;

-- CREATE TABLE from subset of data
CREATE TABLE inactive_patients 
AS (SELECT *
FROM patients
WHERE Status = 'inactive');

--DELETE records from table
DELETE FROM patients 
WHERE status = "inactive";

-- RENAME a table
ALTER TABLE patients 
RENAME TO active_patients;

-- find % of active / inactive from data set
WITH total_active AS (
   SELECT COUNT(ID) AS 'active'
   FROM active_patients
),
total_inactive AS (
   SELECT COUNT(ID) AS 'inactive'
   FROM inactive_patients
),
total_patients AS (
   SELECT total_active.active + total_inactive.inactive AS 'total'
   FROM total_active, total_inactive
)
SELECT 
    (total_active.active*100 / total_patients.total) AS 'percent_active', 
    (total_inactive.inactive*100 / total_patients.total) AS 'percent_inactive'
FROM total_active, total_inactive, total_patients;
_____________________________________________________________________________
--case statement to count total and count filtered
SELECT origin, 
sum(distance) as total_flight_distance, 
sum(CASE WHEN carrier = 'DL' THEN distance ELSE 0 END) as total_delta_flight_distance 
FROM flights 
GROUP BY origin;
_____________________________________________________________________________
-- case statement to get percent
SELECT     origin, 
    100.0*(sum(CASE WHEN carrier = 'DL' THEN distance ELSE 0 END)/sum(distance)) as percentage_flight_distance_from_delta FROM flights 
GROUP BY origin;
_____________________________________________________________________________
-- date and time functions. converts h:mm:ss to just a date yyyy:mm:dd or time h:mm:ss

SELECT
DATE(delivery_time), count(*) as count_baked_goods
FROM baked_goods
GROUP BY 1;

SELECT
TIME(delivery_time), count(*) as count_baked_goods
FROM baked_goods
GROUP BY 1;
_____________________________________________________________________________
-- add time to a timestamp
SELECT DATETIME(delivery_time, '+5 hours', '20 minutes', '2 day') as package_time
FROM baked_goods;
_____________________________________________________________________________
-- concatenate
SELECT
first_name || ' ' || last_name as full_name
FROM
bakeries;
_____________________________________________________________________________
-- replace function   REPLACE(string,from_string,to_string)
SELECT
REPLACE(ingredients,'enriched_',' ') as item_ingredients
FROM baked_goods;
_____________________________________________________________________________
-- subquery to get %
select name, round(sum(amount_paid) /
  (select sum(amount_paid) from order_items) * 100.0, 2) as pct
from order_items
group by 1
order by 2 desc;
_____________________________________________________________________________
-- sub query
  with {subquery_name} as (
    {subquery_body}
  )
  select ...
  from {subquery_name}
  where ...

  with daily_revenue as (
  select
    date(created_at) as dt,
    round(sum(price), 2) as rev
  from purchases
  where refunded_at is null
  group by 1
)
select * from daily_revenue order by dt;
_____________________________________________________________________________