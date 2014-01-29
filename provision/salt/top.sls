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
    - finalize.restart
  'env:production':
    - match: grain
    - env.production
    - finalize.restart
  