# set up data first
###########################################################
{% set vars = {'isLocal': False} %}
{% for ip in salt['grains.get']('ipv4') if ip.startswith('10.255.255') -%}
    {% if vars.update({'isLocal': True}) %} {% endif %}
{%- endfor %}



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