# set up data first
###########################################################
{% set vars = {'isLocal': False} %}
{% if vars.update({'ip': salt['cmd.run']('ifconfig eth1 | grep "inet " | awk \'{gsub("addr:","",$2);  print $2 }\'') }) %} {% endif %}
{% if vars.update({'isLocal': salt['cmd.run']('echo $SERVER_TYPE') }) %} {% endif %}

ssl-cert:
  tls.create_self_signed_cert
    - bits: 2048
    - CN: localhost
    - C: US
    - ST: Washington
    - L: Pullman
    - O: WSU
    - emailAddress: dev.hotseat.wsu.edu