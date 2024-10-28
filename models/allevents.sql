{{
    config(
        materialized='incremental'
    )
}}

SELECT 
    ID as event_id,
    ANONYMOUS_ID as device_id,
    USER_ID as user_id,
    SENT_AT as device_ts,
    TIMESTAMP as server_ts,
    EVENT_TEXT as event_name,
    {} as properties,
    CONTEXT_PAGE_PATH,
    CONTEXT_PAGE_TITLE,
    CONTEXT_PAGE_URL,
    CONTEXT_PAGE_REFERRER
FROM PROD_DOGFOOD.HOUSEWARE_APP.tracks

{% if is_incremental() %}
    WHERE server_ts > (SELECT MAX(server_ts) FROM {{ this }})
{% endif %}
