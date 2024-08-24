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
        and minutes_played >= 20
    )

select
    year
    , dense_rank() over (partition by year order by streams_per_day desc, minutes_played desc) as binge_rank
    , track
    , artist
    , minutes_played
    , spotify_link
from filtered
qualify binge_rank <= 5
order by
    year
    , binge_rank
