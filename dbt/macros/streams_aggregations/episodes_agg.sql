{% macro episodes_agg(date_grain='month') %}
-- date_grain is one of month, year or all_time
with

episodes as (
    select
        episode_id
        , show_name
        , episode_name
        , uri
        {% if date_grain != 'all_time' -%}
        , date_trunc('{{ date_grain }}', stream_start)::date as {{ date_grain }}
        {% endif -%}
        , count(distinct id) as num_streams
        , min(stream_start) as first_stream
        , max(stream_end) as most_recent_stream
        , sum(ms_played) as total_ms_played
    from {{ ref('streams') }}
    where 1 = 1
        and media_type = 'episode'
    {{ dbt_utils.group_by(4 if date_grain == 'all_time' else 5) }}
)

, final as (
    select
        episode_id
        , show_name
        , episode_name
        , uri
        {% if date_grain != 'all_time' -%}
        , {{ date_grain }}
        {% endif -%}
        , num_streams
        , first_stream
        , most_recent_stream
        , total_ms_played
        -- episode metadata like release date
        , total_ms_played::real / num_streams as avg_ms_played
        , extract(epoch from (most_recent_stream - first_stream)) / 86400 as days_between_streams
        , num_streams::real / nullif(extract(epoch from (most_recent_stream - first_stream))::real / 86400, 0) as streams_per_day
        , extract(epoch from (current_date - first_stream)) / 86400 as days_between_streams2
        , num_streams::real / nullif(extract(epoch from (current_date - first_stream))::real / 86400, 0) as streams_per_day2
        , extract(epoch from ((select max(stream_end) from {{ ref('streams') }}) - first_stream)) / 86400 as days_between_streams3
        , case
            when extract(epoch from ((select max(stream_end) from {{ ref('streams') }}) - first_stream)) / 86400 >= 7
                then num_streams::real / nullif(extract(epoch from ((select max(stream_end) from {{ ref('streams') }}) - first_stream))::real / 86400, 0)
            end as streams_per_day3
    from episodes
    where 1 = 1
)

select
    *
from final
where 1 = 1
order by
{% if date_grain != 'all_time' -%}
    {{ date_grain }}
    , total_ms_played desc
{% else -%}
    first_stream
    , most_recent_stream desc
{% endif -%}
{% endmacro %}