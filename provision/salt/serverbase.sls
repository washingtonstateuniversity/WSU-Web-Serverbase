# set up data first
###########################################################
{% set vars = {'isLocal': False} %}
{% if vars.update({'ip': salt['cmd.run']('ifconfig eth1 | grep "inet " | awk \'{gsub("addr:","",$2);  print $2 }\'') }) %} {% endif %}
{% if vars.update({'isLocal': salt['cmd.run']('echo $SERVER_TYPE') }) %} {% endif %}


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
    - source: salt://config/profile/profile.d/system_vars.sh
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
# general updates to items 
###########################################################
# Ensure that bash is at the latest version.
bash:
  pkg.latest:
    - name: bash



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
    
