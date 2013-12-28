###########################################################
###########################################################
# Server Utilities
###########################################################
server-utilities:
  pkg.installed:
    - pkgs:
      - curl
      - dos2unix




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
###########################################################
# performance and tunning
###########################################################
monit:
  pkg.installed:
    - name: monit
    #make configs and com back to apply them
    