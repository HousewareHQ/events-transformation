{{
    config(
        materialized='incremental',
        incremental_strategy = 'append',
        cluster_by=['DATE(server_ts)', 'event_name']
    )
}}

SELECT 
    ID as event_id,
    ANONYMOUS_ID as device_id,
    USER_ID as user_id,
    SENT_AT as device_ts,
    TIMESTAMP as server_ts,
    EVENT_TEXT as event_name,
    {} as properties, --can be set to empty dictionary for simplicity in getting started
    CONTEXT_PAGE_PATH, --can be changed to any other column available in the events table
    CONTEXT_PAGE_TITLE, --can be changed to any other column available in the events table
    CONTEXT_PAGE_URL, --can be changed to any other column available in the events table
    CONTEXT_PAGE_REFERRER, --can be changed to any other column available in the events table 
  from SOURCE_DATABASE_NAME.SOURCE_SCHEMA_NAME.RAW_EVENTS_TABLE_NAME

{% if is_incremental() %}
    WHERE server_ts > (SELECT MAX(server_ts) FROM {{ this }})
{% endif %}
