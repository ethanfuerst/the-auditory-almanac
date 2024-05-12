{% macro split_uri(long_uri) -%}
    str_split({{ long_uri }}, ':')[3]
{%- endmacro %}

{% macro uri_to_link(uri_column, media_type) -%}
    {%- if media_type != 'local_file' -%}
        concat('https://open.spotify.com/{{ media_type }}/', {{ uri_column }})
    {%- else -%}
        ''
    {%- endif -%}
{%- endmacro %}
