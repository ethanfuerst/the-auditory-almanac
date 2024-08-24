with
    source as (
        select
            epoch_ms(epoch(ts)::bigint * 1000 - ms_played)::timestamp as stream_start
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
                str_split(spotify_track_uri, ':')[2]
                , str_split(spotify_episode_uri, ':')[2]
                , 'local_file'
            ) as media_type
            , reason_start
            , reason_end
            , coalesce(shuffle, false) as shuffle
            , coalesce(skipped = 'True', false) as skipped
            , coalesce(offline, false) as offline
            , coalesce(incognito_mode, false) as incognito_mode
            , row_number() over (partition by uri, media_type order by ts) as stream_number
        from {{ source('spotify_raw', 'endsong') }}
    )

select
    md5(stream_end::text || stream_start::text || coalesce(uri, '') || stream_number) as id
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
from source

