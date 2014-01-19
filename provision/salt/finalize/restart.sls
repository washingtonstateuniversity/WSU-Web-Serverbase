# Whenever provisioning runs, it doesn't hurt to flush our object cache.
flush-cache:
  cmd.run:
    - name: sudo service memcached restart
    - cwd: /
    - require:
      - sls: caching

# Whenever provisioning runs, it doesn't hurt to restart php-fpm, flushing the opcode cache.
flush-php-fpm:
  cmd.run:
    - name: sudo service php-fpm restart
    - cwd: /
    - require:
      - sls: web

# Whenever provisioning runs, it doesn't hurt to restart php-fpm, flushing the opcode cache.
clear-workers:
  cmd.run:
    - name: sudo service nginx restart
    - cwd: /
    - require:
      - sls: web
