select *
from `Rides.aerosmith`
where SPOSTMIN < 0 


-- Eliminate null values
DELETE FROM `Rides.aerosmith` WHERE SPOSTMIN IS NULL;
DELETE FROM `Rides.buzz` WHERE SPOSTMIN IS NULL;
DELETE FROM `Rides.everest` WHERE SPOSTMIN IS NULL;
DELETE FROM `Rides.kilimanjaro` WHERE SPOSTMIN IS NULL;
DELETE FROM `Rides.soarin` WHERE SPOSTMIN IS NULL;
DELETE FROM `Rides.space` WHERE SPOSTMIN IS NULL;
DELETE FROM `Rides.spaceship` WHERE SPOSTMIN IS NULL;
DELETE FROM `Rides.toystory` WHERE SPOSTMIN IS NULL;

-- delete rows with negative minutes
DELETE FROM `Rides.aerosmith` WHERE SPOSTMIN < 0;
DELETE FROM `Rides.buzz` WHERE SPOSTMIN < 0;
DELETE FROM `Rides.everest` WHERE SPOSTMIN < 0;
DELETE FROM `Rides.kilimanjaro` WHERE SPOSTMIN < 0;
DELETE FROM `Rides.soarin` WHERE SPOSTMIN < 0;
DELETE FROM `Rides.space` WHERE SPOSTMIN < 0;
DELETE FROM `Rides.spaceship` WHERE SPOSTMIN < 0;
DELETE FROM `Rides.toystory` WHERE SPOSTMIN < 0;
-- trim whitespace
select trim(time) from `Rides.aerosmith`;
select trim(time) from `Rides.buzz`;
select trim(time) from `Rides.everest`;
select trim(time) from `Rides.kilimanjaro`;
select trim(time) from `Rides.soarin`;
select trim(time) from `Rides.space`;
select trim(time) from `Rides.spaceship`;
select trim(time) from `Rides.toystory`;

-- Step 2: Exploratory Data analysis
-- select time for analysis, we are looking for highest in average during the day
SELECT EXTRACT(hour FROM PARSE_TIME('%I:%M:%S %p', time)) AS hour,
       AVG(spostmin) AS average_waiting
FROM `Rides.aerosmith`
GROUP BY hour
ORDER BY average_waiting;

-- 
SELECT EXTRACT(hour FROM PARSE_TIME('%I:%M:%S %p', time)) AS hour,
       AVG(spostmin) AS average_waiting
FROM `Rides.buzz`
GROUP BY hour
ORDER BY average_waiting;
--
SELECT EXTRACT(hour FROM PARSE_TIME('%I:%M:%S %p', time)) AS hour,
       AVG(spostmin) AS average_waiting
FROM `Rides.everest`
GROUP BY hour
ORDER BY average_waiting;

-- after these tests 14:00 (2PM) seems to be in average one of the most concurred times of the day
----------------------------
-- look average at 14 pm grouped by date and group them in a single table
SELECT 
  'Everest' AS ride,
  date,
  AVG(spostmin) AS avg_wait_time
FROM `Rides.everest`
WHERE EXTRACT(hour FROM PARSE_TIME('%I:%M:%S %p', time)) = 14
GROUP BY ride, date

UNION ALL

SELECT 
  'Buzz' AS ride,
  date,
  AVG(spostmin) AS avg_wait_time
FROM `Rides.buzz`
WHERE EXTRACT(hour FROM PARSE_TIME('%I:%M:%S %p', time)) = 14
GROUP BY ride, date

UNION ALL

SELECT 
  'Aerosmith' AS ride,
  date,
  AVG(spostmin) AS avg_wait_time
FROM `Rides.aerosmith`
WHERE EXTRACT(hour FROM PARSE_TIME('%I:%M:%S %p', time)) = 14
GROUP BY ride, date

UNION ALL

SELECT 
  'Kilimanjaro' AS ride,
  date,
  AVG(spostmin) AS avg_wait_time
FROM `Rides.kilimanjaro`
WHERE EXTRACT(hour FROM PARSE_TIME('%I:%M:%S %p', time)) = 14
GROUP BY ride, date

UNION ALL

SELECT 
  'Soarin' AS ride,
  date,
  AVG(spostmin) AS avg_wait_time
FROM `Rides.soarin`
WHERE EXTRACT(hour FROM PARSE_TIME('%I:%M:%S %p', time)) = 14
GROUP BY ride, date

UNION ALL

SELECT 
  'Space' AS ride,
  date,
  AVG(spostmin) AS avg_wait_time
FROM `Rides.space`
WHERE EXTRACT(hour FROM PARSE_TIME('%I:%M:%S %p', time)) = 14
GROUP BY ride, date

UNION ALL

SELECT 
  'Spaceship' AS ride,
  date,
  AVG(spostmin) AS avg_wait_time
FROM `Rides.spaceship`
WHERE EXTRACT(hour FROM PARSE_TIME('%I:%M:%S %p', time)) = 14
GROUP BY ride, date

UNION ALL

SELECT 
  'Toystory' AS ride,
  date,
  AVG(spostmin) AS avg_wait_time
FROM `Rides.toystory`
WHERE EXTRACT(hour FROM PARSE_TIME('%I:%M:%S %p', time)) = 14
GROUP BY ride, date

ORDER BY date, ride

-- Convert rides to column and select only first of each month
SELECT 
  date,
  everest.avg_wait_time AS everest_wait_time,
  buzz.avg_wait_time AS buzz_wait_time,
  aerosmith.avg_wait_time AS aerosmith_wait_time,
  kilimanjaro.avg_wait_time AS kilimanjaro_wait_time,
  soarin.avg_wait_time AS soarin_wait_time,
  space.avg_wait_time AS space_wait_time,
  spaceship.avg_wait_time AS spaceship_wait_time,
  toystory.avg_wait_time AS toystory_wait_time
FROM 
  (SELECT 
    date, AVG(spostmin) AS avg_wait_time
   FROM `Rides.everest`
   WHERE EXTRACT(hour FROM PARSE_TIME('%I:%M:%S %p', time)) = 14
   AND EXTRACT(day FROM date) = 1
   GROUP BY date) AS everest
JOIN 
  (SELECT 
    date, AVG(spostmin) AS avg_wait_time
   FROM `Rides.buzz`
   WHERE EXTRACT(hour FROM PARSE_TIME('%I:%M:%S %p', time)) = 14
   AND EXTRACT(day FROM date) = 1
   GROUP BY date) AS buzz
USING (date)
JOIN 
  (SELECT 
    date, AVG(spostmin) AS avg_wait_time
   FROM `Rides.aerosmith`
   WHERE EXTRACT(hour FROM PARSE_TIME('%I:%M:%S %p', time)) = 14
   AND EXTRACT(day FROM date) = 1
   GROUP BY date) AS aerosmith
USING (date)
JOIN 
  (SELECT 
    date, AVG(spostmin) AS avg_wait_time
   FROM `Rides.kilimanjaro`
   WHERE EXTRACT(hour FROM PARSE_TIME('%I:%M:%S %p', time)) = 14
   AND EXTRACT(day FROM date) = 1
   GROUP BY date) AS kilimanjaro
USING (date)
JOIN 
  (SELECT 
    date, AVG(spostmin) AS avg_wait_time
   FROM `Rides.soarin`
   WHERE EXTRACT(hour FROM PARSE_TIME('%I:%M:%S %p', time)) = 14
   AND EXTRACT(day FROM date) = 1
   GROUP BY date) AS soarin
USING (date)
JOIN 
  (SELECT 
    date, AVG(spostmin) AS avg_wait_time
   FROM `Rides.space`
   WHERE EXTRACT(hour FROM PARSE_TIME('%I:%M:%S %p', time)) = 14
   AND EXTRACT(day FROM date) = 1
   GROUP BY date) AS space
USING (date)
JOIN 
  (SELECT 
    date, AVG(spostmin) AS avg_wait_time
   FROM `Rides.spaceship`
   WHERE EXTRACT(hour FROM PARSE_TIME('%I:%M:%S %p', time)) = 14
   AND EXTRACT(day FROM date) = 1
   GROUP BY date) AS spaceship
USING (date)
JOIN 
  (SELECT 
    date, AVG(spostmin) AS avg_wait_time
   FROM `Rides.toystory`
   WHERE EXTRACT(hour FROM PARSE_TIME('%I:%M:%S %p', time)) = 14
   AND EXTRACT(day FROM date) = 1
   GROUP BY date) AS toystory
USING (date)
ORDER BY date;
