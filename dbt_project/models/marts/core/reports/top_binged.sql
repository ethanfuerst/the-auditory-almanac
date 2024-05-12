with
    filtered as (
        select
            year
            , streams_per_day
            , track
            , artist
            , minutes_played
            , spotify_link
        from {{ ref('int_yearly_track_streams') }}
        where streams_per_day > 1
        and minutes_played >= 10
    )

select
    year
    , row_number() over (partition by year order by streams_per_day desc) as binge_rank
    , track
    , artist
    , minutes_played
    , spotify_link
from filtered
qualify binge_rank <= 5
order by
    year
    , binge_rank
