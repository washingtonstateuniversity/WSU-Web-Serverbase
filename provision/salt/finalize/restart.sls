# Whenever provisioning runs, it doesn't hurt to flush our object cache.
flush-cache:
  cmd.run:
    - name: sudo service memcached restart
    - cwd: /
    - require:
      - sls: caching

clear-mysqld:
  cmd.run:
    - name: sudo service mysqld restart
    - cwd: /
    - require:
      - sls: web
      

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
