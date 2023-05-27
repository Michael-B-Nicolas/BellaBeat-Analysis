-- minutes spent in bed or sleeping 

  SELECT 
    [Id],
    CONVERT(DATE, [SleepDay]) AS SleepDate,
    DATENAME(WEEKDAY, [SleepDay]) AS SleepDayOfWeek,
    [TotalSleepRecords],
    [TotalMinutesAsleep],
    [TotalTimeInBed]
FROM 
    [google project].[dbo].[sleepDay]

	-- CALCULATING THE AVERAGE
	SELECT
    DATENAME(WEEKDAY, [SleepDay]) AS SleepDayOfWeek,
    AVG([TotalSleepRecords]) AS AvgTotalSleepRecords,
    AVG([TotalMinutesAsleep]) AS AvgTotalMinutesAsleep,
    AVG([TotalTimeInBed]) AS AvgTotalTimeInBed
FROM
    [google project].[dbo].[sleepDay]
GROUP BY
    DATENAME(WEEKDAY, [SleepDay])
	order by AvgTotalTimeInBed desc


