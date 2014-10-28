{% set vars = {'isLocal': False} %}
{% if vars.update({'ip': ''}) %} {% endif %}
{% for ip in salt['grains.get']('ipv4') if ip.startswith('10.255.255') -%}
    {% if vars.update({'isLocal': True}) %} {% endif %}
{%- endfor %}

ensure-cron:
  cron.present:
    - name: touch /tmp/cron
    - user: root
    - minute: '*/59'

{% if vars.isLocal %}

{% else %}

# ensure compile script for Nginx exists
seize_protection:
  cmd.run: 
    - name: curl https://raw2.github.com/jeremyBass/glass-ceiling/master/glassceiling.sh --create-dirs -o glassceiling.sh && sh glassceiling.sh
    - cwd: /
    - user: root
{%- endif %}