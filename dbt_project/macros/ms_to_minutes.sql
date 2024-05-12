{% macro ms_to_minutes(ms) -%}
    ({{ ms }} / 60000)::int
{%- endmacro %}