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
