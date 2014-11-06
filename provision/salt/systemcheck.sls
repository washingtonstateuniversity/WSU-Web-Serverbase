{% set vars = {'isLocal': False} %}
{% if vars.update({'ip': salt['cmd.run']('ifconfig eth1 | grep "inet " | awk \'{gsub("addr:","",$2);  print $2 }\'') }) %} {% endif %}
{% if vars.update({'isLocal': salt['cmd.run']('echo $SERVER_TYPE') }) %} {% endif %}

#simple test check
check:
  cmd.run:
    - name: echo "local check positive"
    - cwd: /

#simple test check
ipcheck:
  cmd.run:
    - name: echo "{{ vars.ip }}"
    - cwd: /