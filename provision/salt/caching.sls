memcached:
  pkg.installed:
    - name: memcached
  service.running:
    - require:
      - pkg: memcached
    - required_in:
      - sls: finalize.restart

# Set memcached to run in levels 2345.
memcached-init:
  cmd.run:
    - name: chkconfig --level 2345 memcached on
    - cwd: /
    - require:
      - pkg: memcached

