{% set vars = {'isLocal': False} %}
{% for ip in salt['grains.get']('ipv4') if ip.startswith('10.255.255') -%}
    {% if vars.update({'isLocal': True}) %} {% endif %}
{%- endfor %}

#this maybe can be removed?  Look in to this.
group-vagrant:
  group.present:
    - name: vagrant

user-vagrant:
  user.present:
    - name: vagrant
    - groups:
      - vagrant
      - www-data
      - mysql
    - require:
      - group: www-data
      - group: mysql
    - require_in:
      - pkg: mysql








{% if 'database' in grains.get('roles') %}
group-mysql:
  group.present:
    - name: mysql

user-mysql:
  user.present:
    - name: mysql
    - groups:
      - mysql
    - require_in:
      - pkg: mysql
{% endif %}




