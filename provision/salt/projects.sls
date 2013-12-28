# We set up projects based on what is set up in the pillar data
# find settings in pillar/projects.sls

{% for project, project_arg in pillar.get('projects',{}).items() %}
load-project-{{ project }}:
  git.latest:
    - name: {{ project_arg['name'] }}
    {% if project_arg['rev'] is defined && project_arg['rev'] != '' %}- rev: {{ project_arg['rev'] }}{%- endif %}
    - target: /var/www/{{ project_arg['target'] }}
    {% if project_arg['remote_name'] is defined && project_arg['remote_name'] != '' %}- remote_name: {{ project_arg['remote_name'] }}{%- endif %}
    {% if project_arg['force'] is defined && project_arg['force'] == 'True' %}- force: True{%- endif %} 
    - unless: cd /var/www/{{ project_arg['target'] }}/provision/salt/config  #maybe this shouldn't be at all?
    {% if project_arg['submodules'] is defined && project_arg['submodules'] == 'True' %}- submodules: True{%- endif %} 
    {% if project_arg['force_checkout'] is defined && project_arg['force_checkout'] == 'True' %}- force_checkout: True{%- endif %} 
    {% if project_arg['mirror'] is defined && project_arg['mirror'] == 'True' %}- mirror: True{%- endif %} 
    {% if project_arg['bare'] is defined && project_arg['bare'] == 'True' %}- bare: True{%- endif %} 
    {% if project_arg['identity'] is defined && project_arg['identity'] != '' %}- identity: {{ project_arg['identity'] }}{%- endif %}
    {% if project_arg['user'] is defined && project_arg['user'] != '' %}- user: {{ project_arg['user'] }}{%- endif %}
{% endfor %}