base:
  '*':
{% if 'serverbase' in grains.get('roles') %}
    - serverbase
{% endif %}