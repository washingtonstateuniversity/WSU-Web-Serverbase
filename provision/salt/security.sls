# set up data first
###########################################################
{%- set nginx_version = pillar['nginx']['version'] -%} 
{% set vars = {'isLocal': False} %}
{% for ip in salt['grains.get']('ipv4') if ip.startswith('10.255.255') -%}
    {% if vars.update({'isLocal': True}) %} {% endif %}
    {% if vars.update({'ip': ip}) %} {% endif %}
{%- endfor %}
{% set cpu_count = salt['grains.get']('num_cpus', '') %}



###########################################################
###########################################################
# iptables
###########################################################
/etc/sysconfig/iptables:
  file.managed:
    - source: salt://config/iptables/iptables
    - user: root
    - group: root
    - mode: 600
    - template: jinja
    - context:
      isLocal: {{ vars.isLocal }}
      ip: {{ vars.ip }}
      saltenv: {{ saltenv }}
  cmd.run: #insure it's going to run on windows hosts.. note it's files as folders the git messes up
    - name: dos2unix /etc/sysconfig/iptables
    - require:
      - pkg: dos2unix
    
iptables:
  pkg.installed:
    - name: iptables


# Set iptables to run in levels 2345.
iptables-reboot-auto:
  cmd.run:
    - name: chkconfig --level 2345 iptables on
    - cwd: /
    - require:
      - pkg: iptables



# Turn off iptables for install
iptables-stopped:
  cmd.run:
    - name: service iptables stop
    - cwd: /




###########################################################
###########################################################
# fail2ban
###########################################################
fail2ban:
  pkg.installed:
    - name: fail2ban


/etc/fail2ban/jail.local:
  file.managed:
    - source: salt://config/fail2ban/jail.local
    - user: root
    - group: root
    - mode: 600

/etc/fail2ban/fail2ban.conf:
  file.managed:
    - source: salt://config/fail2ban/fail2ban.conf
    - user: root
    - group: root
    - mode: 600


#we want to store the ip blocked
/etc/fail2ban/ip.blacklist:
  file.managed:
    - user: root
    - group: root
    - mode: 600



# set up so passive filters that look for some we app logs like spam from WP and Magento
# this are only example defaults.  Should be altered to best fit with least amount Ad hoc
/etc/fail2ban/filter.d/spam-log.conf:
  file.managed:
    - source: salt://config/fail2ban/filter.d/spam-log.conf
    - user: root
    - group: root
    - mode: 600

/etc/fail2ban/filter.d/repeatoffender.conf:
  file.managed:
    - source: salt://config/fail2ban/filter.d/repeatoffender.conf
    - user: root
    - group: root
    - mode: 600


# Provide the actions directory for fail2ban
/etc/fail2ban/actions.d:
  file.directory:
    - user: root
    - group: root
    - mode: 600
    - makedirs: true


/etc/fail2ban/actions.d/mail.-nmap.conf:
  file.managed:
    - source: salt://config/fail2ban/actions.d/mail.-nmap.conf
    - user: root
    - group: root
    - mode: 600


/etc/fail2ban/actions.d/iptables-multiport.conf:
  file.managed:
    - source: salt://config/fail2ban/actions.d/iptables-multiport.conf
    - user: root
    - group: root
    - mode: 600

/etc/fail2ban/actions.d/repeatoffender.conf:
  file.managed:
    - source: salt://config/fail2ban/actions.d/repeatoffender.conf
    - user: root
    - group: root
    - mode: 600


/etc/logrotate.d/fail2ban:
  file.managed:
    - source: salt://config/fail2ban/logrotate.d/fail2ban
    - user: root
    - group: root
    - mode: 600

# Set fail2ban to run in levels 2345.
fail2ban-reboot-auto:
  cmd.run:
    - name: chkconfig --level 2345 fail2ban on
    - cwd: /
    - require:
      - pkg: fail2ban
    