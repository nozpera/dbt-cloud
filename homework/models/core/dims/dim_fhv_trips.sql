with stg_fhv_tripdata as (
    select *
    from {{ ref('stg_fhv_tripdata') }}
),
dim_zones as (
    select * from {{ ref('dim_zones') }}
    where borough != 'Unknown'
)
select
    fhv.dispatching_base_num,
    fhv.pickup_datetime,
    fhv.dropoff_datetime,
    fhv.pickup_locationid,
    pz.borough as pickup_borough,
    pz.zone as pickup_zone,
    fhv.dropoff_locationid,
    dz.borough as dropoff_borough,
    dz.zone as dropoff_zone,
    sr_flag,
    affiliated_base_number
from stg_fhv_tripdata as fhv
inner join dim_zones as pz
on fhv.pickup_locationid = pz.locationid
inner join dim_zones as dz
on fhv.dropoff_locationid = dz.locationid