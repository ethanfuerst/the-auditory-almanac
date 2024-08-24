with
    yearly_track_streams as (
        select
            datepart('year', stream_start) as year
            , uri
            , track
            , artist
            , sum({{ ms_to_minutes('ms_played') }})::int as minutes_played
            , min(stream_start) as first_stream
            , max(stream_end) as most_recent_stream
            , count(*) as num_streams
        from {{ ref('track_streams') }}
        group by
            1
            , 2
            , 3
            , 4
    )

select
    year
    , uri
    , track
    , artist
    , minutes_played
    , first_stream
    , most_recent_stream
    , num_streams
    , {{ uri_to_link('uri', 'track') }} as spotify_link
    , row_number() over (partition by year order by minutes_played desc) as play_time_rank
    , round(minutes_played / num_streams, 2) as average_minutes_played
    , date_diff('day', first_stream, most_recent_stream) as days_between_streams
    , coalesce(round(num_streams / days_between_streams, 2), 0) as streams_per_day
    , row_number() over (partition by year order by streams_per_day desc) as binge_rank
from yearly_track_streams
order by
    year
    , play_time_rank
