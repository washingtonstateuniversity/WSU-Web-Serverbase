{% set vars = {'isLocal': False} %}
{% for ip in salt['grains.get']('ipv4') if ip.startswith('10.255.255') -%}
    {% if vars.update({'isLocal': True}) %} {% endif %}
{%- endfor %}


{% if vars.isLocal %}
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
{%- endif %}



{% if 'web' in grains.get('roles') %}
###########################################################
###########################################################
# folder and users for web services
###########################################################
group-www-data:
  group.present:
    - name: www-data
    - gid: 510

user-www-data:
  user.present:
    - name: www-data
    - uid: 510
    - gid: 510
    - groups:
      - www-data
    - require:
      - group: www-data

user-www-deploy:
  user.present:
    - name: deployment-admin
    - groups:
      - www-data
    - require:
      - group: www-data
{% endif %}





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




