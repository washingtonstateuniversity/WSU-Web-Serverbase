# set up data first
###########################################################
{%- set nginx_version = pillar['nginx']['version'] -%} 
{% set vars = {'isLocal': False} %}
{% if vars.update({'ip': ''}) %} {% endif %}
{% for ip in salt['grains.get']('ipv4') if ip.startswith('10.255.255') -%}
    {% if vars.update({'isLocal': True}) %} {% endif %}
{%- endfor %}

ssl-cert:
  tls.create_self_signed_cert
    - bits: 2048
    - CN: localhost
    - C: US
    - ST: Washington
    - L: Pullman
    - O: WSU
    - emailAddress: dev.hotseat.wsu.edu