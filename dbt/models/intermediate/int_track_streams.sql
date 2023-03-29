{{
    config(
        materialized='table'
    )
}}

with

tracks_streams as (
    select
        *
    from {{ ref('stg_spotify__streams') }}
    where 1 = 1
        and media_type = 'track'
)

select
    *
from tracks_streams
where 1 = 1
