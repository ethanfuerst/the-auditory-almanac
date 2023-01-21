-- id is number_l
select
    row_number() over (order by stream_start) || '_local_file' as id
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