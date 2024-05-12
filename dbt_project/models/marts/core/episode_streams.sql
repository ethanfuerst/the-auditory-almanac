select
    stream_start
    , stream_end
    , username
    , platform
    , ms_played
    , conn_country
    , uri
    , track
    , artist
    , album
    , episode_name
    , show_name
    , media_type
    , reason_start
    , reason_end
    , shuffle
    , skipped
    , offline
    , incognito_mode
from {{ ref('stg_spotify__streams') }}
where media_type = 'episode'
