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
    
