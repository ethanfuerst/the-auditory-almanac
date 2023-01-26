{% macro local_files_agg(date_grain='month') %}
-- date_grain is one of month or year
with

local_files as (
    select
        date_trunc('{{ date_grain }}', stream_start)::date as {{ date_grain }}
        , count(distinct local_file_id) as num_local_files_streamed
        , min(stream_start) as first_stream
        , max(stream_end) as most_recent_stream
        , sum(ms_played) as total_ms_played
    from {{ ref('streams') }}
    where 1 = 1
        and media_type = 'local file'
    {{ dbt_utils.group_by(1) }}
)

, final as (
    select
        {{ date_grain }}
        , num_local_files_streamed
        , first_stream
        , most_recent_stream
        , total_ms_played
        , total_ms_played::real / num_local_files_streamed as avg_ms_played
        , extract(epoch from (most_recent_stream - first_stream)) / 86400 as days_between_streams
        , num_local_files_streamed::real / nullif(extract(epoch from (most_recent_stream - first_stream))::real / 86400, 0) as streams_per_day
        , extract(epoch from (current_date - first_stream)) / 86400 as days_between_streams2
        , num_local_files_streamed::real / nullif(extract(epoch from (current_date - first_stream))::real / 86400, 0) as streams_per_day2
        , extract(epoch from ((select max(stream_end) from {{ ref('streams') }}) - first_stream)) / 86400 as days_between_streams3
        , case
            when extract(epoch from ((select max(stream_end) from {{ ref('streams') }}) - first_stream)) / 86400 >= 7
                then num_local_files_streamed::real / nullif(extract(epoch from ((select max(stream_end) from {{ ref('streams') }}) - first_stream))::real / 86400, 0)
            end as streams_per_day3
    from local_files
    where 1 = 1
)

select
    *
from final
where 1 = 1
order by
    first_stream
    , most_recent_stream desc
{% endmacro %}