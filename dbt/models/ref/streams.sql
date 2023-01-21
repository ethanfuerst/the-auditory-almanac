with

source_data as (
    select
        to_timestamp(
            extract(epoch from ts::timestamp) - (ms_played::real / 1000)::int
        ) at time zone 'UTC' as stream_start
        , ts::timestamp as stream_end
        , username
        , platform
        , ms_played
        , conn_country
        , coalesce(
            {{ split_uri('spotify_track_uri') }}
            , {{ split_uri('spotify_episode_uri') }}
        ) as uri
        , master_metadata_track_name as track
        , master_metadata_album_artist_name as artist
        , master_metadata_album_album_name as album
        , episode_name
        , episode_show_name as show_name
        , coalesce(
            split_part(spotify_track_uri, ':', 2)
            , split_part(spotify_episode_uri, ':', 2)
            , 'local file'
        ) as media_type
        , reason_start
        , reason_end
        , coalesce(shuffle, false) as shuffle
        , coalesce(skipped = 'True', false) as skipped
        , coalesce(offline, false) as offline
        , coalesce(incognito_mode, false) as incognito_mode
    from {{ source('spotify_raw', 'endsong') }}
    where 1 = 1
)

, final as (
    select
        row_number() over (order by stream_start) || '_stream' as id
        , stream_start
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
    from source_data
    where 1 = 1
)

select
    *
from final
where 1 = 1
order by
    stream_start
    , stream_end desc