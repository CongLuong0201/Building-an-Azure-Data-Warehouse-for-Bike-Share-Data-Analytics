
BEGIN 
    DROP TABLE Fact_trip
End;

GO

CREATE TABLE Fact_trip(
    trip_id VARCHAR(50),
    rideable_type VARCHAR(50),
    start_station_id VARCHAR(255),
    end_station_id VARCHAR(255),
    started_date DATE,
    ended_date DATE,
    total_time_trip INT,
    rider_id INT,
    ride_age INT
)

INSERT INTO Fact_trip(trip_id, rideable_type, start_station_id, end_station_id, started_date, ended_date, rider_id, total_time_trip, ride_age)
SELECT 
    t.trip_id as trip_id, 
    t.rideable_type as rideable_type,
    t.start_station_id as start_station_id,
    t.end_station_id as end_station_id,
    Convert(Datetime, SUBSTRING(t.start_at,1,19),120) as started_date,
    Convert(Datetime, SUBSTRING(t.ended_at,1,19),120) as ended_date,
    Datediff(Minute,Convert(Datetime, SUBSTRING(t.start_at,1,19),120),Convert(Datetime, SUBSTRING(t.ended_at,1,19),120)) as total_time_trip,
    t.rider_id as rider_id,
    (Datediff(year,Convert(Datetime, SUBSTRING(r.[birthday],1,19),120), 
    Convert(Datetime, SUBSTRING(t.start_at,1,19),120)) - 
    (
        CASE WHEN MONTH(Convert(Datetime, SUBSTRING(r.[birthday],1,19),120)) > MONTH(Convert(Datetime, SUBSTRING(t.start_at,1,19),120))
            OR MONTH(Convert(Datetime, SUBSTRING(r.[birthday],1,19),120)) = MONTH(Convert(Datetime, SUBSTRING(t.start_at,1,19),120))
                AND Day(Convert(Datetime, SUBSTRING(r.[birthday],1,19),120)) > Day(Convert(Datetime, SUBSTRING(t.start_at,1,19),120))
        THEN 1 ELSE 0 End        
    )) as ride_age
FROM staging_trip as t 
JOIN staging_rider as r ON (t.rider_id = r.rider_id)

GO

Select top 10 * from Fact_trip