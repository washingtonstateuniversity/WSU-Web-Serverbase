base:
  '*':
    - serverbase
    - security
    - web
    - caching
    - database
  'env:vagrant':
    - match: grain
    - env.development
  'env:production':
    - match: grain
    - env.production
  'env:*':
    - match: grain
    - finalize.restart
  