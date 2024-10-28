# Events Transformation dbt Project

This dbt project contains a transformation model to standardize raw event data into the Houseware events schema format.

## Models

### allevents

The `allevents` model performs the core transformation of raw events data into a standardized schema with the following key fields:

- event_id
- device_id (from anonymous_id)
- user_id  
- device_ts (client-side timestamp)
- server_ts (server-side timestamp)
- event_name
- properties (event properties)
- Page context fields (path, title, url, referrer)

The model is configured to run incrementally, which means it will only process new records since the last run. This is critical for event data because:

1. Event tables typically grow very large over time
2. Historical events are immutable (don't change)
3. Processing only new data significantly reduces computation time and costs
4. Enables more frequent refreshes of recent data

## Getting Started

1. Update the source table references in `allevents.sql` to point to your raw events table:
   - SOURCE_DATABASE_NAME
   - SOURCE_SCHEMA_NAME 
   - RAW_EVENTS_TABLE_NAME

2. Configure any additional properties or columns you want to include in the transformation

3. Run the model:
   - For first time setup: `dbt run --select allevents --full-refresh`
   - For subsequent incremental runs: `dbt run --select allevents`
