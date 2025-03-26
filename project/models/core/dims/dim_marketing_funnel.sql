WITH marketing_funnel_olist AS (SELECT
cd.mql_id,
cd.seller_id,
mql.first_contact_date,
cd.won_date,
cd.business_segment,
cd.lead_type,
cd.has_company,
cd.has_gtin,
mql.origin
FROM {{ source('sources', 'olist_closed_deals_dataset') }} AS cd
INNER JOIN {{ source('sources', 'olist_marketing_qualified_leads_dataset') }} AS mql
ON mql.mql_id = cd.mql_id)
SELECT * FROM marketing_funnel_olist WHERE first_contact_date <= won_date ORDER BY first_contact_date