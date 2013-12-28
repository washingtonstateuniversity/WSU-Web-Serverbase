base:
  '*':
    - git           # must have this for projects
    - projects      # loaded first processed last
    - server
    - webserver
    - cacheserver
    - dbserver
  'env:vagrant':
    - match: grain
    - devserver
  'env:production':
    - match: grain

