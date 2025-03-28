with green_tripdata as (
    select *,
    'Green' as service_type
    from {{ ref('stg_green_tripdata') }}
),
yellow_tripdata as (
    select *,
    'Yellow' as service_type
    from {{ ref('stg_yellow_tripdata') }}
),
tripdata_merged as (
    select * from green_tripdata
    union all 
    select * from yellow_tripdata
),
dim_zones as (
    select * from {{ ref('dim_zones') }}
    where borough != 'Unknown'
)
select 
    tm.tripid,
    tm.vendorid,
    tm.service_type,
    tm.ratecodeid,
    tm.pickup_locationid,
    pz.borough as pickup_borough,
    pz.zone as pickup_zone,
    tm.dropoff_locationid,
    dz.borough as dropoff_borough,
    dz.zone as dropoff_zone,
    tm.pickup_datetime, 
    tm.dropoff_datetime,
    extract(year from tm.pickup_datetime) as year,
    extract(month from tm.pickup_datetime) as month,
    extract(quarter from tm.pickup_datetime) as quarter,
    concat(extract(year from tm.pickup_datetime), '/Q', extract(quarter from tm.pickup_datetime)) as year_quarter,
    tm.store_and_fwd_flag, 
    tm.passenger_count, 
    tm.trip_distance, 
    tm.trip_type, 
    tm.fare_amount, 
    tm.extra, 
    tm.mta_tax, 
    tm.tip_amount, 
    tm.tolls_amount, 
    tm.ehail_fee, 
    tm.improvement_surcharge, 
    tm.total_amount, 
    tm.payment_type, 
    tm.payment_type_description,
    tm.anomaly_flag
from tripdata_merged as tm
inner join dim_zones as pz
on tm.pickup_locationid = pz.locationid
inner join dim_zones as dz
on tm.dropoff_locationid = dz.locationid