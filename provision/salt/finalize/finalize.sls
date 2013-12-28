# After the operations in /var/www/ are complete, the mapped directory needs to be
# unmounted and then mounted again with www-data:www-data ownership.
www-umount-initial:
  cmd.run:
    - name: sudo umount /var/www/
    - cwd: /
    - require:
      #- sls: webserver
      - git: wsuwp-dev-initial
    - require_in:
      - cmd: www-mount-initial

www-mount-initial:
  cmd.run:
    - name: sudo mount -t vboxsf -o dmode=775,fmode=664,uid=`id -u www-data`,gid=`id -g www-data` /var/www/ /var/www/
    - cwd: /

# Whenever provisioning runs, it doesn't hurt to flush our object cache.
flush-cache:
  cmd.run:
    - name: sudo service memcached restart
    - cwd: /
    #- require:
    #  - sls: cacheserver

# Whenever provisioning runs, it doesn't hurt to restart php-fpm, flushing the opcode cache.
flush-php-fpm:
  cmd.run:
    - name: sudo service php-fpm restart
    - cwd: /
   #- require:
   #  - sls: webserver

