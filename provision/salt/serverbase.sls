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
# Server Variables
###########################################################
# example custom
# Set incron to run in levels 2345.
#set-SERVER_IP:
#  cmd.run:
#    - name: echo 'export SERVER_IP="10.255.255.2"' >> /etc/profile
#    - cwd: /
#    - user: root

/etc/profile.d/system_vars.sh:
  file.managed:
    - source: salt://config/iptables/profile.d/system_vars.sh
    - user: root
    - group: root
    - mode: 600
    - template: jinja
    - context:
      isLocal: {{ vars.isLocal }}
      ip: {{ vars.ip }}
      saltenv: {{ saltenv }}



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

unzip:
  pkg.installed:
    - name: unzip

wget:
  pkg.installed:
    - name: wget

incron:
  pkg.installed:
    - name: incron

# Set incron to run in levels 2345.
incrond-reboot-auto:
  cmd.run:
    - name: chkconfig --level 2345 incrond on
    - cwd: /
    - user: root
    - require:
      - pkg: incron

###########################################################
###########################################################
# Add editors 
###########################################################
nano:
  pkg.installed:
    - name: nano


###########################################################
###########################################################
# performance and tunning
###########################################################
#monit:
#  pkg.installed:
#    - name: monit
#    #make configs and com back to apply them
    
