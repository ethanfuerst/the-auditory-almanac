{% macro split_uri(long_uri) %}
    -- Removes 'spotify:{{ media_type }}:' from a uri.
    split_part({{ long_uri }}, ':', 3)
{% endmacro %}

{% macro uri_to_link(uri, media_type) %}
    -- Changes a uri to a link with a media_type.
    -- If media_type is local file then will return null.
    {% if media_type != 'local file'%}
        'https://open.spotify.com/' || {{ media_type }} || '/' || {{ uri }}
    {% endif %}
{% endmacro %}