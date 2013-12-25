base:
  '*':
    - server
    - webserver
    - cacheserver
    - dbserver
  'env:vagrant':
    - match: grain
    - devserver

  'env:production':
    - match: grain

