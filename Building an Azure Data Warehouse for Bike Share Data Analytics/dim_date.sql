BEGIN
    Drop Table Dim_date
END;

GO

CREATE TABLE Dim_date(
    date DATETIME,
    year INT,
    quarter INT,
    month INT,
    day INT,
    hour_of_day INT,
    week INT,
    day_of_week INT
)

GO;

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'temp_latest_dates')
    DROP TABLE [temp_latest_dates]
GO
CREATE TABLE [temp_latest_dates] (
    [date] datetime
);

INSERT INTO [temp_latest_dates](date)
SELECT date FROM 
(SELECT TOP 1 CONVERT(DATETIME, SUBSTRING([ended_at], 1, 19),120) AS date FROM [dbo].[staging_trip] ORDER BY date DESC) as latest_trip
UNION ALL SELECT date FROM 
(SELECT TOP 1 CONVERT(DATETIME, SUBSTRING([date], 1, 19),120) AS date FROM [dbo].[staging_payment] ORDER BY date DESC) as latest_payment;

DECLARE @start_date DATETIME = (SELECT TOP 1 CONVERT(DATETIME, SUBSTRING([account_start_date], 1, 19),120)
    FROM [dbo].[staging_rider] ORDER BY [account_start_date]);
DECLARE @num_years INT = 30;
DECLARE @cutoff_date DATETIME = (SELECT TOP 1 DATEADD(YEAR, @num_years, [date]) FROM
        [temp_latest_dates] ORDER BY [date] DESC);

INSERT [Dim_date]([date])
SELECT d
FROM
(
    SELECT d = DATEADD(HOUR, rn - 1, @start_date)
    FROM
    (
    SELECT TOP (DATEDIFF(HOUR, @start_date, @cutoff_date))
        rn = ROW_NUMBER() OVER (ORDER BY s1.[object_id])
    FROM sys.all_objects AS s1
    CROSS JOIN sys.all_objects AS s2
    ORDER BY s1.[object_id]
    ) AS x
) AS y;

UPDATE [Dim_date]
SET
    [year]          = DATEPART(YEAR, [date]),
    [quarter]       = DATEPART(QUARTER, [date]),
    [month]         = DATEPART(MONTH, [date]),
    [day]           = DATEPART(DAY, [date]),
    [hour_of_day]   = DATEPART(HOUR, [date]),
    [week]          = DATEPART(WEEK, [date]),
    [day_of_week]   = DATEPART(DAY, [date])
;
GO

GO

SELECT TOP 10 * from Dim_date

GO