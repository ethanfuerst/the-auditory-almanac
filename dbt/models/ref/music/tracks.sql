with

tracks as (
    select
        track
        , artist
        , count(distinct id) as num_streams
	    , count(distinct uri) as num_uris
        , count(distinct album) as num_albums
        , min(stream_start) as first_stream
        , max(stream_end) as most_recent_stream
        , sum(ms_played) as total_ms_played
        , string_agg(
            distinct uri::text
            , ','
        ) as uris
        , row_number() over (order by min(stream_start)) || '_track' as id
    from {{ ref('streams') }}
    where 1 = 1
        and media_type = 'track'
    {{ dbt_utils.group_by(2) }}
)

, final as (
    select
        id
        , track
        , artist
        , num_streams
        , num_uris
        , num_albums
        , first_stream
        , most_recent_stream
        , total_ms_played
        , uris
        , total_ms_played::real / num_streams as avg_ms_played
    from tracks
    where 1 = 1
)

select
    *
from final
where 1 = 1
order by
    first_stream
    , most_recent_stream desc