base:
  '*':
    - git           # must have this for projects
    - projects      # loaded any projects on it's own
    - server
    - webserver
    - cacheserver
    - dbserver
  'env:vagrant':
    - match: grain
    - devserver
  'env:production':
    - match: grain
