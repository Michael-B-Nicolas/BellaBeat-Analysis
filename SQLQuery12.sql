/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (10) [Id]
      ,[ActivityHour]
      ,[Calories]
      ,[TotalIntensity]
      ,[AverageIntensity]
      ,[StepTotal]
  FROM [google project].[dbo].[hourly_activity]


  SELECT DISTINCT FORMAT(CAST(ActivityHour AS DATETIME), 'hh:mm tt') AS activity_time,
       AVG(TotalIntensity) OVER (PARTITION BY DATEPART(HOUR, ActivityHour)) AS average_intensity,
       AVG(METs/10.0) OVER (PARTITION BY DATEPART(HOUR, ActivityHour)) AS average_mets
FROM [google project].dbo.hourly_activity AS hourly_activity
JOIN [google project].dbo.minuteMETsNarrow AS METs
    ON hourly_activity.Id = METs.Id AND hourly_activity.ActivityHour = METs.ActivityMinute
ORDER BY average_intensity DESC
