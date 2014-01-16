# We set up projects based on what is set up in the pillar data
# find settings in pillar/projects.sls

{% for project, project_arg in pillar.get('projects',{}).items() %}
load-project-{{ project }}:
  git.latest:
    - name: {{ project_arg['name'] }}
    - target: /var/www/{{ project_arg['target'] }}
    - unless: cd /var/www/{{ project_arg['target'] }}/provision/salt/config
    {% if project_arg['rev'] is defined and project_arg['rev'] != '' %}- rev: {{ project_arg['rev'] }}{%- endif %}
    {% if project_arg['remote_name'] is defined and project_arg['remote_name'] != '' %}- remote_name: {{ project_arg['remote_name'] }}{%- endif %}
    {% if project_arg.get( 'force', False ) is sameas True %}- force: True{%- endif %}
    {% if project_arg.get( 'submodules', False ) is sameas True %}- submodules: True{%- endif %}
    {% if project_arg.get( 'force_checkout', False ) is sameas True %}- force_checkout: True{%- endif %}
    {% if project_arg.get( 'mirror', False ) is sameas True %}- mirror: True{%- endif %}
    {% if project_arg.get( 'bare', False ) is sameas True %}- bare: True{%- endif %}
    {% if project_arg['identity'] is defined and project_arg['identity'] != '' %}- identity: {{ project_arg['identity'] }}{%- endif %}
    {% if project_arg['user'] is defined and project_arg['user'] != '' %}- user: {{ project_arg['user'] }}{%- endif %}
{% endfor %}


refresh_modules:
  module.run:
    - name: saltutil.refresh_modules
refresh_pillar:
  module.run:
    - name: saltutil.refresh_pillar
sync-minions:
  module.run:
    - name: saltutil.sync_all    
    

#{% for project, project_arg in pillar.get('projects',{}).items() %}
#project-install-{{ project }}:
#  cwd.run:
#    - name: /var/www/{{ project_arg['name'] }}
#    - target: /var/www/{{ project_arg['target'] }}
#    - unless: cd /var/www/{{ project_arg['target'] }}/provision/salt/config
#{% endfor %}