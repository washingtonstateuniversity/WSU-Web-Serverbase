# set up data first
###########################################################
{% set vars = {'isLocal': False} %}
{% if vars.update({'ip': salt['cmd.run']('ifconfig eth1 | grep "inet " | awk \'{gsub("addr:","",$2);  print $2 }\'') }) %} {% endif %}
{% if vars.update({'isLocal': salt['cmd.run']('echo $SERVER_TYPE') }) %} {% endif %}



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