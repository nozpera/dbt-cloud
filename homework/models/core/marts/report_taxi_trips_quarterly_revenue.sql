with quarterly_revenue as (select
    service_type,
    year,
    quarter,
    year_quarter,
    cast(sum(total_amount) as integer) as total_revenue
from {{ ref('fact_taxi_trips') }}
group by service_type, year, quarter, year_quarter
order by service_type, total_revenue desc),
yoy_growth as (select
    service_type,
    year,
    year_quarter,
    total_revenue,
    lag(total_revenue) over (partition by service_type, quarter order by year) as last_year_revenue,
    round(((total_revenue - lag(total_revenue) over (
            partition by service_type, quarter
            order by year)) / lag(total_revenue) over (
            partition by service_type, quarter
            order by year)) * 100, 2) as yoy_growth_percent
    from quarterly_revenue
)

select
    service_type,
    year_quarter,
    total_revenue,
    yoy_growth_percent
from yoy_growth
where year = 2020
order by service_type, yoy_growth_percent desc