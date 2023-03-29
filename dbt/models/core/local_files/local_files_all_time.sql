{{
    config(
        alias='local_files'
    )
}}

with

final as (
	select
		local_file_id
		, id as stream_id
		, stream_start
		, stream_end
		, ms_played
		, reason_start
		, reason_end
		, shuffle
		, skipped
		, offline
		, incognito_mode
	from {{ ref('streams') }}
	where 1 = 1
		and media_type = 'local file'
)

select
	*
from final
where 1 = 1
order by
	stream_start asc
	, stream_end desc
