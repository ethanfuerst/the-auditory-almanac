with

episodes as (
    select
        episode_id as id
        , show_name
        , episode_name
        , uri
        , count(distinct id) as num_streams
        , min(stream_start) as first_stream
        , max(stream_end) as most_recent_stream
        , sum(ms_played) as total_ms_played
    from {{ ref('streams') }}
    where 1 = 1
        and media_type = 'episode'
    {{ dbt_utils.group_by(4) }}
)

, final as (
    select
        id
        , show_name
        , episode_name
        , uri
        , num_streams
        , first_stream
        , most_recent_stream
        , total_ms_played
        , total_ms_played::real / num_streams as avg_ms_per_stream
        -- episode metadata like release date
    from episodes
    where 1 = 1
)

select
    *
from final
where 1 = 1
order by
    first_stream
    , most_recent_stream desc