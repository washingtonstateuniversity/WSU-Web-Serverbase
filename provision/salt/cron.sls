{% set vars = {'isLocal': False} %}
{% if vars.update({'ip': salt['cmd.run']('ifconfig eth1 | grep "inet " | awk \'{gsub("addr:","",$2);  print $2 }\'') }) %} {% endif %}
{% if vars.update({'isLocal': salt['cmd.run']('echo $SERVER_TYPE') }) %} {% endif %}

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