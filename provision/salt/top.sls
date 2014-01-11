base:
  '*':
    - git           # must have this for projects
    - server
    - webserver
    - cacheserver
    - dbserver
    - projects      # loaded any projects on it's own
  'env:vagrant':
    - match: grain
    - devserver
  'env:production':
    - match: grain

