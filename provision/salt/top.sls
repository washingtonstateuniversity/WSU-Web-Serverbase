{%- set isLocal = "false" -%}
base:
{% if 'serverroles' in salt['grains.get']('roles', []) %}
    - serverbase
{% endif %}
    - finalize.restart