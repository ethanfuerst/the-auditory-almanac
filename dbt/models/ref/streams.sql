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

, albums as (
    select
        album
        , artist
        , row_number() over (order by min(stream_start)) as album_id
    from source_data
    where 1 = 1
        and media_type = 'track'
    {{ dbt_utils.group_by(2) }}
)

, tracks as (
    select
        track
        , artist
        , row_number() over (order by min(stream_start)) as track_id
    from source_data
    where 1 = 1
        and media_type = 'track'
    {{ dbt_utils.group_by(2) }}
)

, episodes as (
    select
        uri
        , row_number() over (order by min(stream_start)) as episode_id
    from source_data
    where 1 = 1
        and media_type = 'episode'
    {{ dbt_utils.group_by(1) }}
)

, shows as (
    select
        show_name
        , row_number() over (order by min(stream_start)) as show_id
    from source_data
    where 1 = 1
        and media_type = 'episode'
    {{ dbt_utils.group_by(1) }}
)

, final as (
    select
        row_number() over (order by sd.stream_start)::text as id
        , t.track_id::text
        , a.album_id::text
        , case
            when sd.media_type = 'local file'
                then row_number() over (partition by sd.media_type order by sd.stream_start)::text
            end as local_file_id
        , e.episode_id::text
        , s.show_id::text
        , sd.stream_start
        , sd.stream_end
        , sd.username
        , sd.platform
        , sd.ms_played
        , sd.conn_country
        , sd.uri
        , sd.track
        , sd.artist
        , sd.album
        , sd.episode_name
        , sd.show_name
        , sd.media_type
        , sd.reason_start
        , sd.reason_end
        , sd.shuffle
        , sd.skipped
        , sd.offline
        , sd.incognito_mode
    from source_data as sd
    left join tracks as t
        on sd.track = t.track
        and sd.artist = t.artist
    left join albums as a
        on sd.album = a.album
        and sd.artist = a.artist
    left join episodes as e
        on sd.uri = e.uri
    left join shows as s
        on sd.show_name = s.show_name
    where 1 = 1
)

select
    *
from final
where 1 = 1
order by
    stream_start
    , stream_end desc