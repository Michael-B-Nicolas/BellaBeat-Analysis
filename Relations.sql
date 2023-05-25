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

--THE AVG ACTIVITY LEVEL AND SLEEP FOR EACH PERSON
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
	 sum(days_num) >= 1
ORDER BY 
    avg_TotalMinutesAsleep DESC;



--For finding relationship between activiy and weight/BMI
SELECT activity.Id, convert(Date, ActivityDate) as date_column, Calories, BMI, TotalSteps, TotalDistance, TrackerDistance, LoggedActivitiesDistance, VeryActiveDistance, ModeratelyActiveDistance, LightActiveDistance,SedentaryActiveDistance, VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, SedentaryMinutes
FROM [google project].dbo.dailyActivity AS activity
 JOIN [google project].dbo.weightLogInfo AS weight
ON activity.Id = weight.Id AND convert(date, activity.ActivityDate) = convert(date, weight.Date)
order by Calories desc




-- THE AVG ACTIVITY AND WEIGHT/BMI FOR EACH PERSON

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

SELECT Id, ActivityDate,Calories, TotalSteps, TotalDistance, TrackerDistance, LoggedActivitiesDistance,
(VeryActiveDistance+ModeratelyActiveDistance+LightActiveDistance) AS TotalActiveDistance,SedentaryActiveDistance,
(VeryActiveMinutes+FairlyActiveMinutes+LightlyActiveMinutes) AS TotalActiveMinutes, SedentaryMinutes
FROM [google project].dbo.dailyActivity


-- this code of chunk is only for tracked users in 4 weeks and above
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
    COUNT(ActivityDate) >= 27

ORDER BY
    num_days DESC