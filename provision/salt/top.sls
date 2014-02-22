{% for host,ip in salt['mine.get']('*', 'network.ip_addrs').items() %}
    {% if ip|replace("10.255.255", "LOCAL").split('LOCAL').count() == 2  %}
        {%- set is_local = true -%}
    {% else %}
        {%- set is_local = false -%}
    {%- endif %}
{% endfor %}
base:
{% if 'serverbase' in grains['roles'] %}
    - serverbase
{%- endif %}
  'G@role:database':
    - match: compound
    - database
  'G@role:security':
    - match: compound
    - security
  'G@role:web':
    - match: compound
    - web
  'G@role:webcaching':
    - match: compound
    - caching
  'G@role:dbcaching':
    - match: compound
    - caching
{% if is_local equals true %}
    - env.development
{% else %}
    - env.production
{%- endif %}
    - finalize.restart