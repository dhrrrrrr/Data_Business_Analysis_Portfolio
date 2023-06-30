--All source tables are available in BigQuery

--Create a view to store bike trip information 
--Since the most recent records in the citibike_trips are bewtween year 2017 and 2018, I extracted the latest records for analysis

CREATE OR REPLACE VIEW `ba-project-390100.cyclistic.citibike_trips_view` AS
SELECT
    *
  FROM
    `bigquery-public-data.new_york_citibike.citibike_trips`
  WHERE
    extract(year from starttime) between 2017 and 2018;

--Create a view to store New York stations information

CREATE OR REPLACE VIEW `ba-project-390100.cyclistic.citibike_stations_view` AS
SELECT 
  *
  FROM 
    `bigquery-public-data.new_york_citibike.citibike_stations`;

--Create a view for (latitude, longitude) and zip code mapping
CREATE OR REPLACE VIEW `ba-project-390100.cyclistic.geo_zip_codes_view` AS
SELECT
  *
FROM
  `bigquery-public-data.geo_us_boundaries.zip_codes`;

--Create a view to store weather informatin for the year 2017 and 2018

CREATE OR REPLACE VIEW `ba-project-390100.cyclistic.gsod2017_nyc_view` AS
SELECT
  stn,
  wban,
  year,
  mo,
  da,
  `temp`,
  visib,
  wdsp,
  min,
  prcp,
  fog
FROM
  `bigquery-public-data.noaa_gsod.gsod2017`
WHERE
  wban='94728';

CREATE OR REPLACE VIEW `ba-project-390100.cyclistic.gsod2018_nyc_view` AS
SELECT
  stn,
  wban,
  year,
  mo,
  da,
  `temp`,
  visib,
  wdsp,
  min,
  prcp,
  fog
FROM
  `bigquery-public-data.noaa_gsod.gsod2018`
WHERE
  wban='94728';

CREATE OR REPLACE VIEW `ba-project-390100.cyclistic.gsod2017_2018_nyc_view` AS
SELECT
  *
FROM
  `ba-project-390100.cyclistic.gsod2017_nyc_view`
UNION ALL
SELECT
  *
FROM
  `ba-project-390100.cyclistic.gsod2018_nyc_view`;

--Finally, create the dashboard with the following:

CREATE OR REPLACE VIEW
  `ba-project-390100.cyclistic.cyclistic_dashboard_view` AS
SELECT
  DATE(starttime) AS start_day,
  DATE(stoptime) AS stop_day,
  start_zip.zip_code AS start_zip_code,
  start_neighbor.borough AS start_borough,
  start_neighbor.neighborhood AS start_neighborhood,
  end_zip.zip_code AS end_zip_code,
  end_neighbor.borough AS end_borough,
  end_neighbor.neighborhood AS end_neighborhood,
  usertype,
  weather.prcp AS percipitation,
  weather.temp AS temperature,
  weather.wdsp AS wind_speed,
  weather.fog AS fog,
  ROUND(CAST(trip.tripduration / 60 AS INT64), -1) AS trip_minutes,
  COUNT(trip.bikeid) AS trip_count
FROM
  `ba-project-390100.cyclistic.citibike_trips_view` trip
INNER JOIN
  `ba-project-390100.cyclistic.geo_zip_codes_view` start_zip
ON
  ST_WITHIN(ST_GEOGPOINT(trip.start_station_longitude, trip.start_station_latitude), start_zip.zip_code_geom)
INNER JOIN
  `ba-project-390100.cyclistic.geo_zip_codes_view` end_zip
ON
  ST_WITHIN(ST_GEOGPOINT(trip.end_station_longitude, trip.end_station_latitude), start_zip.zip_code_geom)
INNER JOIN
  `ba-project-390100.cyclistic.zip_codes` start_neighbor
ON
  start_zip.zip_code = CAST(start_neighbor.zip AS STRING)
INNER JOIN
  `ba-project-390100.cyclistic.zip_codes` end_neighbor
ON
  end_zip.zip_code = CAST(end_neighbor.zip AS STRING)
INNER JOIN
  `ba-project-390100.cyclistic.gsod2017_2018_nyc_view` weather
ON
  PARSE_DATE("%Y%m%d", CONCAT(weather.year, weather.mo, weather.da)) = DATE(trip.starttime)
GROUP BY
  1,2,3,4,5,6,7,8,9,10,11,12,13,14;
