{{ config(materialized='table') }}

with events as (
    select * from {{ ref('stg_ga4__events') }}
)

select
    concat(user_id, '-', cast(session_id as string)) as session_key,
    user_id,
    session_id,
    min(event_timestamp) as session_start,
    timestamp_diff(max(event_timestamp), min(event_timestamp), second) as session_duration_seconds,
    any_value(device_category) as device_category,
    any_value(country) as country,
    any_value(traffic_medium) as traffic_medium,
    countif(event_name = 'page_view') as page_views,
    max(case when event_name = 'view_item' then 1 else 0 end) as viewed_item,
    max(case when event_name = 'add_to_cart' then 1 else 0 end) as added_to_cart,
    max(case when event_name = 'begin_checkout' then 1 else 0 end) as began_checkout,
    max(case when event_name = 'purchase' then 1 else 0 end) as purchased,
    sum(purchase_revenue_usd) as revenue_usd
from events
where session_id is not null
group by user_id, session_id
