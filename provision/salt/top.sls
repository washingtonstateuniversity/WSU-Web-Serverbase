base:
  'env:vagrant':
    - match: grain
    - env.development
    - finalize.restart
  'env:production':
    - match: grain
    - env.production
    - finalize.restart
serverbase:
  '*':
    - serverbase
database:
  '*':
    - database
security:
  '*':
    - security
web:
  '*':
    - web
caching:
  '*':
    - caching