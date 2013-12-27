#We set up projects based on what is set up in the config

{% for user, user_arg in pillar.get('projects',{}).items() %}
wp-add-user-{{ user }}:
  cmd.run:
    - name: wp user get {{ user_arg['login'] }} || wp user create {{ user_arg['login'] }} {{ user_arg['email'] }} --role={{ user_arg['role'] }} --user_pass={{ user_arg['pass'] }} --display_name="{{ user_arg['name'] }}"
    - cwd: /var/www/wsuwp-platform/wordpress/
    - require:
      - cmd: wsuwp-install-network
{% endfor %}