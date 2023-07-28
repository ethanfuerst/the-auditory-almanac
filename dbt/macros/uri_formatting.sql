-- Removes 'spotify:{{ media_type }}:' from a uri.
{% macro split_uri(long_uri) %}
    str_split({{ long_uri }}, ':')[3]
{% endmacro %}

-- Changes a uri to a link with a media_type.
-- If media_type is local file then will return null. -- need to fix this
{% macro uri_to_link(uri_column, media_type) %}
    {% if media_type != 'local_file' %}
        concat('https://open.spotify.com/{{ media_type }}/', {{ uri_column }})
    {% endif %}
{% endmacro %}