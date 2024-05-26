select
    min(stream_start) as first_stream
    , max(stream_start) as last_stream
from {{ ref("track_streams") }}
