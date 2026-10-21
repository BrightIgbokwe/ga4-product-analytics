select
    parse_date('%Y%m%d', event_date) as event_date,
    timestamp_micros(event_timestamp) as event_timestamp,
    event_name,
    user_pseudo_id as user_id,
    (select value.int_value from unnest(event_params) where key = 'ga_session_id') as session_id,
    (select value.string_value from unnest(event_params) where key = 'page_location') as page_location,
    device.category as device_category,
    geo.country as country,
    traffic_source.medium as traffic_medium,
    ecommerce.transaction_id,
    ecommerce.purchase_revenue_in_usd as purchase_revenue_usd
from {{ source('ga4', 'events') }}