{%- set web = pillar['web'] -%} 
{% do web.update({'isLocal':'false'}) %}
{% for host,ip in salt['mine.get']('*', 'network.ip_addrs').items() -%}
    {% if ip|replace("10.255.255", "LOCAL").split('LOCAL').count() == 2  %}
        {% do web.update({'isLocal':'true'}) %}
    {%- endif %}
{%- endfor %}
{%- set isLocal = pillar['web']['isLocal'] -%} 

base:
  '*':
{% if 'serverbase' in grains.get('roles') %}
    - serverbase
{% endif %}
{% if 'database' in grains.get('roles') %}
    - database
{% endif %}
{% if 'security' in grains.get('roles') %}
    - security
{% endif %}
{% if 'web' in grains.get('roles') %}
    - web
{% endif %}
{% if 'webcaching' in grains.get('roles') %}
    - caching
{% endif %}
{% if isLocal == "true" %}
    - env.development
{% else %}
    - env.production
{%- endif %}
    - finalize.restart