{{
    config(
        materialized='table'
    )
}}

with

local_file_streams as (
    select
        *
    from {{ ref('stg_spotify__streams') }}
    where 1 = 1
        and media_type = 'local file'
)

select
    *
from local_file_streams
where 1 = 1
