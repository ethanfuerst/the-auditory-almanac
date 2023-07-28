with
episode_streams as (
    select
        *
    from {{ ref('stg_spotify__streams') }}
    where 1 = 1
        and media_type = 'episode'
)

select *
from episode_streams
