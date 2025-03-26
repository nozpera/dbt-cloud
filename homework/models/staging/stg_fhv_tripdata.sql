select
    dispatching_base_num,
    pickup_datetime,
    drop_off_datetime as dropoff_datetime,
    p_ulocation_id as pickup_locationid,
    d_olocation_id as dropoff_locationid,
    cast(sr_flag as numeric) as sr_flag,
    affiliated_base_number
 from {{ source('sources', 'fhv_sources') }}
 where dispatching_base_num is not null