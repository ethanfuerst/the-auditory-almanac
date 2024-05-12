with
    overall_track_streams as (
        select
            uri
            , track
            , artist
            , sum({{ ms_to_minutes('ms_played') }})::int as minutes_played
            , count(*) as number_of_streams
        from {{ ref('track_streams') }}
        group by
            1
            , 2
            , 3
        limit 100
    )

select
    row_number() over (order by minutes_played desc) as play_time_rank
    , track
    , artist
    , minutes_played
    , number_of_streams
    , {{ uri_to_link('uri', 'track') }} as spotify_link
from overall_track_streams
order by
    1
