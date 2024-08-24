select
    month
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
from {{ ref('int_monthly_track_streams') }}
where play_time_rank <= 25
order by
    month
    , play_time_rank
