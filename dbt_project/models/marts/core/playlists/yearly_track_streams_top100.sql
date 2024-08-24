select
    year
    , uri
    , track
    , artist
    , minutes_played
    , first_stream
    , most_recent_stream
    , num_streams
    , spotify_link
    , play_time_rank
    , average_minutes_played
    , days_between_streams
    , streams_per_day
    , binge_rank
from {{ ref('int_yearly_track_streams') }}
where play_time_rank <= 100
order by
    year
    , play_time_rank
