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
where media_type = 'track'
group by
    1
    , 2