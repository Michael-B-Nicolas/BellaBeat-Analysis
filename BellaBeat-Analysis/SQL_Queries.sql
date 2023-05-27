
-- CALCULATIONS

--NUM OF UNIQUE ID'S IN EACH TABLE

SELECT COUNT( DISTINCT Id) NumOf_Id_dailyActivity FROM [google project].dbo.dailyActivity
SELECT COUNT( DISTINCT Id) NumOf_Id_heartrate FROM [google project].dbo.heartrate_seconds
SELECT COUNT( DISTINCT Id) NumOf_Id_hourly_activity FROM [google project].dbo.hourly_activity
SELECT COUNT( DISTINCT Id) NumOf_Id_sleepDay FROM [google project].dbo.sleepDay
SELECT COUNT( DISTINCT Id) NumOf_Id_weightLogInfo FROM [google project].dbo.weightLogInfo
SELECT COUNT( DISTINCT Id) NumOf_Id_minuteMETsNarrow FROM [google project].dbo.minuteMETsNarrow
SELECT COUNT( DISTINCT Id) NumOf_Id_minuteSleep FROM [google project].dbo.minuteSleep

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



--Querying And Selecting Data:

--DETERMINE TIME WHEN USERS WERE MOSTLY ACTIVE


SELECT DISTINCT FORMAT(CAST(ActivityHour AS DATETIME), 'hh:mm tt') AS activity_time,
       AVG(TotalIntensity) OVER (PARTITION BY DATEPART(HOUR, ActivityHour)) AS average_intensity,
       AVG(METs/10.0) OVER (PARTITION BY DATEPART(HOUR, ActivityHour)) AS average_mets, 
	   AVG(StepTotal) OVER (PARTITION BY DATEPART(HOUR, ActivityHour)) as average_totalsteps,
	   AVG(Calories) OVER (PARTITION BY DATEPART(HOUR, ActivityHour)) as average_calories
FROM [google project].dbo.hourly_activity AS hourly_activity
JOIN [google project].dbo.minuteMETsNarrow AS METs
    ON hourly_activity.Id = METs.Id AND hourly_activity.ActivityHour = METs.ActivityMinute
ORDER BY average_totalsteps DESC


-- minutes spent in bed or sleeping 

  SELECT 
    Id,
    CONVERT(DATE, sleepDay) AS SleepDate,
    DATENAME(WEEKDAY, SleepDay) AS SleepDayOfWeek,
    TotalSleepRecords,
    TotalMinutesAsleep,
    TotalTimeInBed
FROM 
    [google project].dbo.sleepDay

	-- CALCULATING THE AVERAGE
	SELECT
    DATENAME(WEEKDAY, SleepDay) AS SleepDayOfWeek,
    AVG(TotalSleepRecords) AS AvgTotalSleepRecords,
    AVG(TotalMinutesAsleep) AS AvgTotalMinutesAsleep,
    AVG(TotalTimeInBed) AS AvgTotalTimeInBed
FROM
    [google project].dbo.sleepDay
GROUP BY
    DATENAME(WEEKDAY, SleepDay)
	order by AvgTotalTimeInBed desc



	--For finding relationship between activity level and sleep time
SELECT activity.Id, ActivityDate,Calories, TotalSleepRecords, 
TotalMinutesAsleep, TotalTimeInBed, TotalSteps, TotalDistance, 
TrackerDistance, LoggedActivitiesDistance, (VeryActiveDistance + ModeratelyActiveDistance) AS ActiveDistance,
(LightActiveDistance+SedentaryActiveDistance) AS non_ActiveDistance, (VeryActiveMinutes+FairlyActiveMinutes) AS ActiveMinutes, 
(LightlyActiveMinutes+SedentaryMinutes) AS non_ActiveMinutes

FROM [google project].dbo.dailyActivity AS activity
INNER JOIN [google project].dbo.sleepDay AS sleep
ON activity.Id = sleep.Id AND activity.ActivityDate = sleep.SleepDay

order by TotalMinutesAsleep desc

--THE( AVG ACTIVITY LEVEL AND SLEEP) FOR EACH PERSON
SELECT 
    Id, 
    sum(days_num) as numofdays, 
    AVG(Calories) AS avg_Calories, 
    AVG(TotalSleepRecords) AS avg_TotalSleepRecords, 
    AVG(TotalMinutesAsleep) AS avg_TotalMinutesAsleep, 
    AVG(TotalTimeInBed) AS avg_TotalTimeInBed, 
    AVG(TotalSteps) AS avg_TotalSteps, 
    AVG(TotalDistance) AS avg_TotalDistance, 
    AVG(TrackerDistance) AS avg_TrackerDistance, 
    AVG(LoggedActivitiesDistance) AS avg_LoggedActivitiesDistance, 
    AVG(ActiveDistance) AS avg_ActiveDistance, 
    AVG(non_ActiveDistance) AS avg_non_ActiveDistance, 
    AVG(ActiveMinutes) AS avg_ActiveMinutes, 
    AVG(non_ActiveMinutes) AS avg_non_ActiveMinutes
FROM 
    (
        SELECT 
            activity.Id, 
            COUNT(ActivityDate) AS days_num, 
            Calories, 
            TotalSleepRecords, 
            TotalMinutesAsleep, 
            TotalTimeInBed, 
            TotalSteps, 
            TotalDistance, 
            TrackerDistance, 
            LoggedActivitiesDistance, 
            (VeryActiveDistance + ModeratelyActiveDistance) AS ActiveDistance, 
            (LightActiveDistance + SedentaryActiveDistance) AS non_ActiveDistance, 
            (VeryActiveMinutes + FairlyActiveMinutes) AS ActiveMinutes, 
            (LightlyActiveMinutes + SedentaryMinutes) AS non_ActiveMinutes
        FROM 
            [google project].dbo.dailyActivity AS activity
        INNER JOIN 
            [google project].dbo.sleepDay AS sleep
        ON 
            activity.Id = sleep.Id AND activity.ActivityDate = sleep.SleepDay
			group by
			 activity.Id, 
			   Calories, 
            TotalSleepRecords, 
            TotalMinutesAsleep, 
            TotalTimeInBed, 
            TotalSteps, 
            TotalDistance, 
            TrackerDistance, 
            LoggedActivitiesDistance,
			(VeryActiveDistance + ModeratelyActiveDistance),
			(LightActiveDistance + SedentaryActiveDistance),
			(VeryActiveMinutes + FairlyActiveMinutes),
			 (LightlyActiveMinutes + SedentaryMinutes)
			
    ) AS subquery
GROUP BY 
    Id, 
    days_num
	HAVING 
	 sum(days_num) >= 1  /* to filter users that have been tracked for less than required*/
ORDER BY 
    avg_TotalMinutesAsleep DESC;







--For finding relationship between activiy and weight/BMI
SELECT activity.Id, convert(Date, ActivityDate) as date_column,
Calories, BMI, TotalSteps, TotalDistance, TrackerDistance,
LoggedActivitiesDistance, VeryActiveDistance, ModeratelyActiveDistance,
LightActiveDistance,SedentaryActiveDistance, VeryActiveMinutes, FairlyActiveMinutes, 
LightlyActiveMinutes, SedentaryMinutes

FROM [google project].dbo.dailyActivity AS activity
 JOIN [google project].dbo.weightLogInfo AS weight
ON activity.Id = weight.Id AND convert(date, activity.ActivityDate) = convert(date, weight.Date)

order by Calories desc




-- THE (AVG ACTIVITY AND WEIGHT/BMI) FOR EACH PERSON

	SELECT 
    Id, 
    sum(days_num) as numofdays, 
    avg(Calories) AS avg_Calories, 
    AVG(BMI) AS avg_BMI, 
    avg(TotalSteps) AS avg_TotalSteps, 
    avg(TotalDistance) AS avg_TotalDistance, 
    avg(TrackerDistance) AS avg_TrackerDistance, 
    avg(LoggedActivitiesDistance) AS avg_LoggedActivitiesDistance, 
    avg(VeryActiveDistance) AS avg_VeryActiveDistance, 
    avg(ModeratelyActiveDistance) AS avg_ModeratelyActiveDistance, 
    avg(LightActiveDistance) AS avg_LightActiveDistance, 
    avg(SedentaryActiveDistance) AS avg_SedentaryActiveDistance, 
    avg(VeryActiveMinutes) AS avg_VeryActiveMinutes, 
    avg(FairlyActiveMinutes) AS avg_FairlyActiveMinutes, 
    avg(LightlyActiveMinutes) AS avg_LightlyActiveMinutes, 
    avg(SedentaryMinutes) AS avg_SedentaryMinutes
FROM 
    (
        SELECT 
            activity.Id, 
            COUNT(ActivityDate) AS days_num, 
            Calories, 
            BMI, 
            TotalSteps, 
            TotalDistance, 
            TrackerDistance, 
            LoggedActivitiesDistance, 
            VeryActiveDistance, 
            ModeratelyActiveDistance, 
            LightActiveDistance, 
            SedentaryActiveDistance, 
            VeryActiveMinutes, 
            FairlyActiveMinutes, 
            LightlyActiveMinutes, 
            SedentaryMinutes
        FROM 
            [google project].dbo.dailyActivity AS activity
        INNER JOIN 
            [google project].dbo.weightLogInfo AS weight ON activity.Id = weight.Id 
            AND CONVERT(DATE, activity.ActivityDate) = CONVERT(DATE, weight.Date)
        GROUP BY 
            activity.Id,
            Calories, 
            BMI, 
            TotalSteps, 
            TotalDistance, 
            TrackerDistance, 
            LoggedActivitiesDistance, 
            VeryActiveDistance, 
            ModeratelyActiveDistance, 
            LightActiveDistance,
            SedentaryActiveDistance, 
            VeryActiveMinutes, 
            FairlyActiveMinutes, 
            LightlyActiveMinutes, 
            SedentaryMinutes
        HAVING 
            COUNT(ActivityDate) >= 1
    ) AS subquery
GROUP BY 
    Id, 
    days_num
ORDER BY 
    Id DESC;





--For finding activity level and calories burnt

SELECT Id, ActivityDate,Calories, TotalSteps,
TotalDistance, TrackerDistance, LoggedActivitiesDistance,
(VeryActiveDistance+ModeratelyActiveDistance+LightActiveDistance) AS TotalActiveDistance,SedentaryActiveDistance,
(VeryActiveMinutes+FairlyActiveMinutes+LightlyActiveMinutes) AS TotalActiveMinutes, SedentaryMinutes

FROM [google project].dbo.dailyActivity

ORDER BY Calories DESC


-- (activity level and calories burnt) for each unique id
SELECT Id,
     COUNT(ActivityDate) AS num_days ,
     AVG(Calories) AS avg_calories,
     AVG(TotalSteps) AS avg_totalsteps,
     AVG(TotalDistance) AS vag_totalDistance,
     AVG(TrackerDistance) AS avg_trackerDistance,
     AVG(LoggedActivitiesDistance) AS avg_loggedActiveDistance,
     AVG(VeryActiveDistance+ModeratelyActiveDistance+LightActiveDistance) AS avg_TotalActiveDistance,
     AVG(SedentaryActiveDistance) AS avg_SedentaryActiveDistance,
     AVG(VeryActiveMinutes+FairlyActiveMinutes+LightlyActiveMinutes) AS avg_TotalActiveMinutes,
     AVG(SedentaryMinutes) AS avg_sedentaryMinutes
	 

FROM [google project].dbo.dailyActivity

GROUP BY Id

HAVING
    COUNT(ActivityDate) >= 27 /* to filter users that have been tracked for less than 4 weeks*/

ORDER BY
    num_days DESC