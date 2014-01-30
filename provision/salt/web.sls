# set up data first
###########################################################
{%- set nginx_version = pillar['nginx']['version'] -%} 



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

/etc/hosts:
  file.managed:
    - source: salt://config/hosts
    - user: root
    - group: root
    - mode: 644


#worth noting that there will be some changes as this just gets nuked it seems
#a fix here http://totalcae.com/blog/2013/06/prevent-etcresolv-conf-from-being-blown-away-by-rhelcentos-after-customizing/
/etc/resolv.conf:
  file.managed:
    - source: salt://config/resolv.conf
    - user: root
    - group: root
    - mode: 644

###########################################################
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
    - require:
      - sls: serverbase

# Adds the service file.
/etc/init.d/nginx:
  file.managed:
    - name: /etc/init.d/nginx
    - source: salt://config/nginx/nginx
    - user: root
    - group: root
    - mode: 755
  cmd.run: #insure it's going to run on windows hosts
    - name: dos2unix /etc/init.d/nginx
    - require:
      - pkg: dos2unix

# Ensure a source folder (/src/) is there to do `make`'s in
/src/:
  file.directory:
    - name: /src/
    - user: root
    - group: root
    - mode: 777

#/srv/salt/base/config/nginx/compiler.sh:
#  file.managed:
#   - user: root
#   - group: root
#   - mode: 755

# Run compiler
nginx-compile:
  file.managed:
    - name: /src/nginx/compiler.sh
    - source: salt://config/nginx/compiler.sh
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: /src/nginx/compiler.sh {{ nginx_version }}
    - cwd: /
    - user: root
    - stateful: True
    - unless: nginx -v 2>&1 | grep -qi "{{ nginx_version }}"
    - require:
      - pkg: nginx-compiler-base

# Set Nginx to run in levels 2345.
nginx-reboot-auto:
  cmd.run:
    - name: chkconfig --level 2345 nginx on
    - cwd: /
    - user: root
    - require:
      - cmd: nginx-compile

# Start nginx
nginx:
  service.running:
    - user: root
    - require:
      - cmd: nginx-compile
      - user: www-data
      - group: www-data
    - watch:
      - file: /etc/nginx/nginx.conf
      - file: /etc/nginx/sites-enabled/default
    - required_in:
      - sls: finalize.restart
      
#***************************************      
# nginx files & configs
#***************************************         
/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://config/nginx/nginx.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: nginx-compile


/etc/nginx/sites-enabled/default:
  file.managed:
    - source: salt://config/nginx/default
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: nginx-compile


###########################################################  
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
      - php-gd
      - php-mbstring
      - php-pecl-zendopcache
      - php-pecl-xdebug
      - php-pecl-memcached
    - require:
      - sls: serverbase
  service.running:
    - require:
      - pkg: php-fpm
    - watch:
      - file: /etc/php-fpm.d/www.conf
    - required_in:
      - sls: finalize.restart

# Set php-fpm to run in levels 2345.
php-fpm-reboot-auto:
  cmd.run:
    - name: chkconfig --level 2345 php-fpm on
    - cwd: /
    - user: root
    - require:
      - pkg: php-fpm

ImageMagick:
  pkg.installed:
    - pkgs:
      - php-pecl-imagick
      - ImageMagick

      
#***************************************      
# php-fpm files & configs
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

/etc/php.d/opcache.ini:
  file.managed:
    - source: salt://config/php-fpm/opcache.ini
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: php-fpm


###########################################################
###########################################################
# composer
###########################################################    
get-composer:
  cmd.run:
    - name: 'CURL=`which curl`; $CURL -sS https://getcomposer.org/installer | php'
    - unless: test -f /usr/local/bin/composer
    - user: root
    - cwd: /root/
 
install-composer:
  cmd.wait:
    - name: mv /root/composer.phar /usr/local/bin/composer
    - cwd: /root/
    - user: root
    - watch:
      - cmd: get-composer
    

