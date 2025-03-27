WITH marketing_funnel AS (SELECT
    seller_id,
    first_contact_date,
    seller_approved_date,
    business_segment,
    lead_type,
    has_company,
    has_gtin,
    origin
    FROM {{ ref('dim_marketing_funnel') }}),
    geolocation_seller AS (SELECT
    seller_id,
    zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    seller_state
    FROM {{ ref('dim_geolocation_sellers') }})

SELECT
    mf.seller_id,
    mf.first_contact_date,
    mf.seller_approved_date,
    mf.business_segment,
    mf.lead_type,
    gs.zip_code_prefix,
    gs.geolocation_lat,
    gs.geolocation_lng,
    gs.seller_state,
    mf.has_company,
    mf.has_gtin,
    mf.origin
FROM marketing_funnel AS mf
INNER JOIN geolocation_seller AS gs
ON gs.seller_id = mf.seller_id