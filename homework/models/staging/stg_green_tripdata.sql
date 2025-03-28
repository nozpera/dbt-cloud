with tripdata as (
    select *,
    row_number() over (partition by vendor_id, lpep_pickup_datetime) as rn
    from {{ source('sources', 'green_tripdata') }}
    where vendor_id is not null
)
select
    --identifiers
    {{ dbt_utils.generate_surrogate_key(['vendor_id', 'lpep_pickup_datetime']) }} as tripid,
    vendor_id as vendorid,
    ratecode_id as ratecodeid,
    pu_location_id as pickup_locationid,
    do_location_id as dropoff_locationid,

    --timestamps
    lpep_pickup_datetime as pickup_datetime,
    lpep_dropoff_datetime as dropoff_datetime,

    --trip-info
    store_and_fwd_flag,
    passenger_count,
    cast(trip_distance as numeric) as trip_distance,
    trip_type,

    -- payment info
    cast(fare_amount as numeric) as fare_amount,
    cast(extra as numeric) as extra,
    cast(mta_tax as numeric) as mta_tax,
    cast(tip_amount as numeric) as tip_amount,
    cast(tolls_amount as numeric) as tolls_amount,
    cast(ehail_fee as numeric) as ehail_fee,
    cast(improvement_surcharge as numeric) as improvement_surcharge,
    cast(total_amount as numeric) as total_amount,
    coalesce(payment_type,0) as payment_type,
    {{ get_payment_type_description("payment_type") }} as payment_type_description,
    case
        when total_amount < 0 AND {{ get_payment_type_description('payment_type') }} != 'Dispute' then 'Y'
        else 'N'
    end as anomaly_flag
from tripdata
where (rn = 1) AND (lpep_pickup_datetime BETWEEN '2019-01-01' AND '2021-01-01')