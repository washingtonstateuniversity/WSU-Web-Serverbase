{%- set isLocal = "false" -%}
{% for host,ip in salt['mine.get']('*', 'network.ip_addrs').items() -%}
    {% if ip|replace("10.255.255", "LOCAL").split('LOCAL').count() == 2  %}
        {%- set isLocal = "true" -%}
    {%- endif %}
{%- endfor %}
base:
  '*':
    - os.centos
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
{% if 'java' in grains.get('roles') %}
    - java
{% endif %}
{% if isLocal == "true" %}
    - env.development
{% else %}
    - env.production
{%- endif %}
    - finalize.restart