# We set up projects based on what is set up in the pillar data
# find settings in pillar/projects.sls

{% for project, project_arg in pillar.get('projects',{}).items() %}
load-project-{{ project }}:
  git.latest:
    - name: {{ project_arg['name'] }}
    - target: /var/www/{{ project_arg['target'] }}
    - unless: cd /var/www/{{ project_arg['target'] }}/provision/salt/config  #maybe this shouldn't be at all?
    {% if project_arg['rev'] is defined and project_arg['rev'] != '' %}- rev: {{ project_arg['rev'] }}{%- endif %}
    {% if project_arg['remote_name'] is defined and project_arg['remote_name'] != '' %}- remote_name: {{ project_arg['remote_name'] }}{%- endif %}
    {% if project_arg.get( 'force', False ) == 'True' %}- force: True{%- endif %}
    {% if project_arg.get( 'submodules', False ) == 'True' %}- submodules: True{%- endif %}
    {% if project_arg.get( 'force_checkout', False ) == 'True' %}- force_checkout: True{%- endif %}
    {% if project_arg.get( 'mirror', False ) == 'True' %}- mirror: True{%- endif %}
    {% if project_arg.get( 'bare', False ) == 'True' %}- bare: True{%- endif %}
    {% if project_arg['identity'] is defined and project_arg['identity'] != '' %}- identity: {{ project_arg['identity'] }}{%- endif %}
    {% if project_arg['user'] is defined and project_arg['user'] != '' %}- user: {{ project_arg['user'] }}{%- endif %}
{% endfor %}