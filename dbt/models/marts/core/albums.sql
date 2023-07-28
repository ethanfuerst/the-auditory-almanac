with
albums as (
    select
        album
        , artist
        , string_agg(
                distinct uri::text
                , ','
            ) as uris
        , min(stream_start) as first_stream
        , max(stream_start) as most_recent_stream
        , sum(ms_played) as total_ms_played
    from {{ ref('stg_spotify__streams') }}
    where 1 = 1
        and media_type = 'track'
    {{ dbt_utils.group_by(2) }}
)

select *
from albums