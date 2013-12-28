# We set up projects based on what is set up in the pillar data
# find settings in pillar/projects.sls

{% for project, project_arg in pillar.get('projects',{}).items() %}
load-project-{{ project }}:
  git.latest:
    - name: {{ project_arg['name'] }}
    - force:True
    {% if project_arg['rev'] != '' %}- rev: {{ project_arg['rev'] }}{%- endif %}
    - target: /var/www/{{ project_arg['target'] }}
    - unless: cd /var/www/{{ project_arg['target'] }}/provision/salt/config  #maybe this shouldn't be at all?
    #- submodules:True    
{% endfor %}