


-- CALCULATING THE NUMBER OF USERS AND DAILY AVERAGE

--NUM OF UNIQUE ID'S IN EACH TABLE

SELECT COUNT( DISTINCT Id) NumOf_ID_dailyActivity FROM [google project].dbo.dailyActivity
SELECT COUNT( DISTINCT Id) NumOf_ID_heartrate FROM [google project].dbo.heartrate_seconds
SELECT COUNT( DISTINCT Id) NumOf_ID_hourly_activity FROM [google project].dbo.hourly_activity
SELECT COUNT( DISTINCT Id) NumOf_ID_sleepDay FROM [google project].dbo.sleepDay
SELECT COUNT( DISTINCT Id) NumOf_ID_weightLogInfo FROM [google project].dbo.weightLogInfo
SELECT COUNT( DISTINCT Id) NumOf_ID_minuteMETsNarrow FROM [google project].dbo.minuteMETsNarrow

--PHYSICAL ACTIVITIES

SELECT COUNT(DISTINCT Id) AS users_tracking_activity,
       AVG (TotalSteps) as AVG_steps,
	   avg (TotalDistance) as AVG_distance,
	   avg (Calories) AS AVG_calories

FROM [google project].dbo.dailyActivity

-- NUMBER OF USERS TRACKING
select  count(DISTINCT Id) as num_users
from [google project].dbo.dailyActivity

--TRACKING HEART RATE

SELECT COUNT(DISTINCT Id) AS num_users_heartrate,
       AVG(Value) as avg_heartrate,
	   MIN(Value) as min_heartrate,
	   max(Value) as max_heartrate
FROM [google project].dbo.heartrate_seconds

--TRACKIN SLEEP

SELECT COUNT(DISTINCT Id) AS num_users_sleep,
       avg(TotalMInutesAsleep)/60.0 as avg_hours_asleep,
	   avg(TotalTimeInBed)/60.0 as avg_hours_bed,
	   min(TotalMInutesAsleep)/60.0 as min_hours_asleep,
	   max(TotalMInutesAsleep)/60.0 as max_hours_asleep
FROM [google project].dbo.sleepDay

--TRACKING WEIGHT

SELECT COUNT(DISTINCT Id) AS num_users_weight,
       AVG(WeightKg) as avg_weight,
	   min(WeightKg) as min_weight,
	   max(weightKg) as max_weight
       
FROM [google project].dbo.weightLogInfo


