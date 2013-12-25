group-www-data:
  group.present:
    - name: www-data

user-www-data:
  user.present:
    - name: www-data
    - groups:
      - www-data
    - require:
      - group: www-data

/etc/hosts:
  file.managed:
    - source: salt://config/hosts
    - user: root
    - group: root
    - mode: 644

/etc/resolv.conf:
  file.managed:
    - source: salt://config/resolv.conf
    - user: root
    - group: root
    - mode: 644
    
###########################################################
# nginx
###########################################################
nginx-compiler-base:
  pkg.installed:
    - pkgs:
      - gcc
      - gcc-c++
      - make
      - zlib-devel
      - pcre-devel 
      - openssl-devel

# Adds the service.
/etc/init.d/nginx:
  file.managed:
    - name: /etc/init.d/nginx
    - source: salt://config/nginx/nginx
    - user: root
    - group: root
    - mode: 744
    
# Ensure a source folder (/src/) is there to do `make`'s in
/src/:
  file.directory:
    - name: /src/
    - user: root
    - group: root
    - mode: 644
    
# Run compiler
nginx-compile:
  cmd.run:
    - name: /srv/salt/config/nginx/compiler.sh
    - cwd: /
    - stateful: True
    - require:
      - pkg: nginx-compiler-base

# Adds the service.
nginx-init:
  cmd.run:
    - name: chkconfig --add nginx
    - cwd: /
    - require:
      - cmd: nginx-compile
      
# Set Nginx to run in levels 2345.
nginx-persistent-state:
  cmd.run:
    - name: chkconfig --level 2345 nginx on
    - cwd: /
    - require:
      - cmd: nginx-init

# Start nginx
nginx:
  service.running:
    - require:
      - cmd: nginx-init
      - user: www-data
      - group: www-data
    - watch:
      - file: /etc/nginx/nginx.conf
      - file: /etc/nginx/sites-enabled/default
      - file: /etc/nginx/sites-enabled/store.mage.dev.conf
      
#***************************************      
# files & configs
#***************************************         
/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://config/nginx/nginx.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: nginx-init

/etc/nginx/sites-enabled/default:
  file.managed:
    - source: salt://config/nginx/default
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: nginx-init

/etc/nginx/sites-enabled/store.mage.dev.conf:
  file.managed:
    - source: salt://config/nginx/store.mage.dev.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: nginx-init

    
###########################################################
# php-fpm
###########################################################
php-fpm:
  pkg.installed:
    - pkgs:
      - php-fpm
      - php-cli
      - php-common
      - php-mysql
      - php-pear
      - php-pdo
      - php-mcrypt
      - php-imap
      - php-pecl-zendopcache
      - php-pecl-xdebug
      - php-pecl-memcached
  service.running:
    - require:
      - pkg: php-fpm
    - watch:
      - file: /etc/php-fpm.d/www.conf

# Set php-fpm to run in levels 2345.
php-fpm-init:
  cmd.run:
    - name: chkconfig --level 2345 php-fpm on
    - cwd: /
    - require:
      - pkg: php-fpm

ImageMagick:
  pkg.installed:
    - pkgs:
      - php-pecl-imagick
      - ImageMagick
      
#***************************************      
# files & configs
#***************************************    
/etc/php-fpm.d/www.conf:
  file.managed:
    - source: salt://config/php-fpm/www.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: php-fpm

/etc/php.ini:
  file.managed:
    - source: salt://config/php-fpm/php.ini
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: php-fpm

    
###########################################################
# security
###########################################################
iptables:
  pkg.installed:
    - name: iptables
  service.running:
    - watch:
      - file: /etc/sysconfig/iptables

/etc/sysconfig/iptables:
  file.managed:
    - source: salt://config/iptables/iptables
    - user: root
    - group: root
    - mode: 600

fail2ban:
  pkg.installed:
    - name: fail2ban


/etc/fail2ban/jail.local:
  file.managed:
    - source: salt://config/fail2ban/jail.local
    - user: root
    - group: root
    - mode: 600
    
/etc/fail2ban/filter.d/spam-log.conf:
  file.managed:
    - source: salt://config/fail2ban/filter.d/spam-log.conf
    - user: root
    - group: root
    - mode: 600
    
/etc/fail2ban/actions.d/mail.-nmap.conf:
  file.managed:
    - source: salt://config/fail2ban/actions.d/mail.-nmap.conf
    - user: root
    - group: root
    - mode: 600
    
    
    
    
###########################################################
# performance and tunning
###########################################################

monit:
  pkg.installed:
    - name: monit
    #make configs and com back to apply them
    