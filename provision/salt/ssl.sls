# set up data first
###########################################################
{%- set nginx_version = pillar['nginx']['version'] -%} 
{%- set isLocal = "false" -%}
{% for host,ip in salt['mine.get']('*', 'network.ip_addrs').items() -%}
    {% if ip|replace("10.255.255", "LOCAL").split('LOCAL').count() == 2  %}
        {%- set isLocal = "true" -%}
    {%- endif %}
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