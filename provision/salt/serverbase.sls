###########################################################
###########################################################
# Server Utilities
###########################################################
curl:
  pkg.installed:
    - name: curl
    
dos2unix:
  pkg.installed:
    - name: dos2unix

git:
  pkg.installed:
    - name: git

patch:
  pkg.installed:
    - name: patch

wget:
  pkg.installed:
    - name: wget


###########################################################
###########################################################
# Mangage the kernel
###########################################################
kernel-headers:
  pkg.installed:
    - name: kernel-headers

###########################################################
###########################################################
# Add editors 
###########################################################
nano:
  pkg.installed:
    - name: nano


###########################################################
###########################################################
# Remi Repository 
###########################################################
remi-rep:
  pkgrepo.managed:
    - humanname: Remi Repository
    - baseurl: http://rpms.famillecollet.com/enterprise/6/remi/x86_64/
    - gpgcheck: 0
    - require_in:
      - pkg: mysql
      - pkg: php-fpm
      - pkg: memcached

###########################################################
###########################################################
# performance and tunning
###########################################################
monit:
  pkg.installed:
    - name: monit
    #make configs and com back to apply them
    