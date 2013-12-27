base:
  '*':
    - server
    - webserver
    - cacheserver
    - dbserver
    - projects
  'env:vagrant':
    - match: grain
    - devserver
  'env:production':
    - match: grain

