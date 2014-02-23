{%- set isLocal = "false" -%}
base:
{% if salt['grains.get']('roles:serverbase', False) == True %}
    - serverbase
{% endif %}
    - finalize.restart