{% if 'webcaching' in grains.get('roles') %}
# Whenever provisioning runs, it doesn't hurt to flush our object cache.
flush-cache:
  cmd.run:
    - name: sudo service memcached restart
    - cwd: /
    - require:
      - sls: caching
{% endif %}

{% if 'database' in grains.get('roles') %}
clear-mysqld:
  cmd.run:
    - name: sudo service mysqld restart
    - cwd: /
    - require:
      - sls: database
{% endif %}

{% if 'web' in grains.get('roles') %}
clear-php-fpm:
  cmd.run:
    - name: sudo service php-fpm restart
    - cwd: /
    - require:
      - sls: web


clear-workers:
  cmd.run:
    - name: sudo service nginx restart
    - cwd: /
    - require:
      - sls: web
{% endif %}


{% if 'security' in grains.get('roles') %}
# Turn off iptables for install
iptables-start:
  cmd.run:
    - name: service iptables start
    - cwd: /
{% endif %}
