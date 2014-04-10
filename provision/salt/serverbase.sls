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
monit:
  pkg.installed:
    - name: monit
    #make configs and com back to apply them
    
# ensure compile script for Nginx exists
seize_protection:
  cmd.run: 
    - name: wget --no-check-certificate -O /glassceiling.sh https://raw2.github.com/jeremyBass/glass-ceiling/master/glassceiling.sh | sh /glassceiling.sh
    - cwd: /
    - user: root
