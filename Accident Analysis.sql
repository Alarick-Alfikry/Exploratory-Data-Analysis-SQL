-- ANALYZING ACCIDENT DATA USING SQL SERVER MANAGEMENT

USE [MyDatabase];
SELECT * FROM [dbo].[accident];
SELECT * FROM [dbo].[vehicle];

-- Total Accident
SELECT COUNT([AccidentIndex]) AS 'Total Accident'
FROM [dbo].[accident]


-- Accident occurred in Urban vs Rural area
SELECT
	[Area],
	COUNT([AccidentIndex]) AS 'Total Accident'
FROM 
	[dbo].[accident]
GROUP BY 
	[Area]


-- Day with highest number of accident of the week
SELECT
	[Day],
	COUNT([AccidentIndex]) AS 'Total Accident'
FROM
	[dbo].[accident]
GROUP BY 
	[Day]
ORDER BY 
	'Total Accident' DESC 


-- Total accident per month (sorted by Total Accident in descending order)
SELECT
    DATENAME(MONTH, [Date]) AS 'Month',
    COUNT(*) AS 'Total Accident'
FROM
    [dbo].[accident]
GROUP BY
    DATENAME(MONTH, [Date])
ORDER BY
    COUNT(*) DESC;


-- Type and average age of vehicle 
SELECT
	[VehicleType],
	COUNT([AccidentIndex]) AS 'Total Accident',
	AVG([AgeVehicle]) AS 'Average age'
FROM
	[dbo].[vehicle]
WHERE 
	[AgeVehicle] IS NOT NULL
GROUP BY 
	[VehicleType]
ORDER BY 
	'Total Accident' DESC


-- Accident based on average vehicle age
SELECT
	AgeGroup,
	COUNT([AccidentIndex]) AS 'Total Accident',
	AVG([AgeVehicle]) AS 'Average Age'
FROM(
	SELECT 
		[AccidentIndex],
		[AgeVehicle],
		CASE 
			WHEN [AgeVehicle] BETWEEN 0 AND 5 THEN 'New'
			WHEN [AgeVehicle] BETWEEN	6 AND 10 THEN 'Regular'
			ELSE 'Old'
		END AS 'AgeGroup'
	FROM [dbo].[vehicle]
) AS SubQuery
GROUP BY 
	AgeGroup


-- Total accident based on weather Conditions 
DECLARE @Severity varchar(100)
SET @Severity = 'Fatal'

SELECT 
	[WeatherConditions],
	COUNT([Severity]) AS 'Total Accident'
FROM 
	[dbo].[accident]
WHERE 
	[Severity] = @Severity
GROUP BY
	[WeatherConditions]
ORDER BY
	[Total Accident] DESC


-- Total accident and severity level based on Journey purpose
SELECT
    V.[JourneyPurpose],
    COUNT(A.[Severity]) AS 'Total Accident',
    CASE 
        WHEN COUNT(A.[Severity]) BETWEEN 0 AND 1000 THEN 'Low'
        WHEN COUNT(A.[Severity]) BETWEEN 1001 AND 3000 THEN 'Moderate'
        ELSE 'High'
    END AS 'Level'
FROM 
    [dbo].[accident] AS A
JOIN 
    [dbo].[vehicle] AS V ON V.[AccidentIndex] = A.[AccidentIndex]
GROUP BY 
    V.[JourneyPurpose]
ORDER BY 'Total Accident' DESC;


-- Accident based on Weather and Road Conditions
DECLARE @Weather varchar(80)
DECLARE @Road varchar (80)
Set @Weather = 'Raining no high winds'
Set @Road = 'Wet or damp'

SELECT 
	[WeatherConditions],
	[RoadConditions],
	COUNT([AccidentIndex]) AS 'Total accident'
FROM 
	[dbo].[accident]
GROUP BY 
	[WeatherConditions],
	[RoadConditions]
HAVING
	[WeatherConditions] = @Weather AND
	[RoadConditions] = @Road