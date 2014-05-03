PackageKit:
  pkg.removed:
    - name: PackageKit

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

# install Node.Js
npm:
  pkg.installed:
    - name: npm

# bypass self signing certs issues for npm
update-npm:
  cmd.run:
    - name: npm config set ca=""
  require:
    - pkg: npm

grunt:
  cmd.run:
    - name: npm install -g grunt-cli
    - require:
      - pkg: npm
      - cmd: update-npm

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
    
