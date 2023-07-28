with
    yearly_track_streams as (
        select
            date_trunc('year', stream_start) as year
            , uri
            , track
            , artist
            , sum(ms_played) as ms_played
            , min(stream_start) as first_stream
            , max(stream_end) as most_recent_stream
            , count(*) as num_streams
        from {{ ref('track_streams') }}
        {{ dbt_utils.group_by(4) }}
    )

select
    *
    , {{ uri_to_link('uri', 'track') }} as spotify_link
    , row_number() over (partition by year order by ms_played desc) as play_time_rank
    , round(ms_played / num_streams, 2) as avg_ms_played
    , date_diff('day', first_stream, most_recent_stream) as days_between_streams
    , coalesce(round(num_streams / days_between_streams, 2), 0) as streams_per_day
    , row_number() over (partition by year order by streams_per_day desc) as binge_rank
from yearly_track_streams
order by
    year
    , play_time_rank
