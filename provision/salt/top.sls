base:
  '*':
    - serverbase
    - database
    - security
    - web
    - caching
  'env:vagrant':
    - match: grain
    - env.development
  'env:production':
    - match: grain
    - env.production
  'env:*':
    - match: grain
    - finalize.restart
  