with

shows as (
    select
        show_name
        , count(distinct episode_name) as num_episodes_streamed
        , count(distinct id) as num_streams
        , min(stream_start) as first_stream
        , max(stream_end) as most_recent_stream
        , sum(ms_played) as total_ms_played
        , string_agg(
            distinct uri::text
            , ','
        ) as uris
        , row_number() over (order by min(stream_start)) || '_show' as id
    from {{ ref('streams') }}
    where 1 = 1
        and media_type = 'episode'
    {{ dbt_utils.group_by(1) }}
)

, final as (
    select
        id
        , show_name
        , num_episodes_streamed
        , num_streams
        , first_stream
        , most_recent_stream
        , total_ms_played
        , total_ms_played::real / num_streams as avg_ms_per_stream
        -- show metadata like release date
    from shows
    where 1 = 1
)

select
    *
from final
where 1 = 1
order by
    first_stream
    , most_recent_stream desc