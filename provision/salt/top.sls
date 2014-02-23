base:
{% if 'serverroles' in salt['grains.get']('roles') %}
    - serverbase
{% endif %}