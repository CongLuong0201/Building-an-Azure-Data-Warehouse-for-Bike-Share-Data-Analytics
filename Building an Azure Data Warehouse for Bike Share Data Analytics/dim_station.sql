BEGIN  
    DROP TABLE Dim_station
END;

GO

CREATE TABLE Dim_station(
    station_id varchar(255),
    name_station varchar(255),
    longitude float,
    latitude float
)

GO

INSERT INTO Dim_station (station_id, name_station, longitude, latitude)
SELECT s.station_id as station_id, s.name as name_station, s.longitude as longitude, s.latitude as latitude
FROM staging_station as s

GO

Select top 10 * from Dim_station

Go