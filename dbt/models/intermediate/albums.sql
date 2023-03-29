-- source of truth for albums (includes metadata)
with

albums as (
    select
        album_id
        , album
        , artist
        , string_agg(
                distinct uri::text
                , ','
            ) as uris
        , min(stream_start) as first_stream
        , max(stream_end) as most_recent_stream
        , sum(ms_played) as total_ms_played
    from {{ ref('stg_spotify__streams') }}
    where 1 = 1
        and media_type = 'track'
    {{ dbt_utils.dbt_utils.group_by(3) }}
)