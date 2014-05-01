{% set vars = {'isLocal': False} %}
{% for ip in salt['grains.get']('ipv4') if ip.startswith('10.255.255') -%}
    {% if vars.update({'isLocal': True}) %} {% endif %}
{%- endfor %}

base:
  '*':
    - os.centos
    - users
{% if 'serverbase' in grains.get('roles') %}
    - serverbase
{% endif %}
{% if 'email' in grains.get('roles') %}
    - email
{% endif %}
{% if 'database' in grains.get('roles') %}
    - database
{% endif %}
{% if 'security' in grains.get('roles') %}
    - security
{% endif %}
{% if 'ssl' in grains.get('roles') %}
    - ssl
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
{% if vars.isLocal %}
    - env.development
{% else %}
    - env.production
{%- endif %}
    - finalize.restart