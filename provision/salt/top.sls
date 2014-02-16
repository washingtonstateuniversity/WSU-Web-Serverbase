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
  'env:serverbase':
    - serverbase
database:
  'env:database':
    - database
security:
  'env:security':
    - security
web:
  'env:web':
    - web
caching:
  'env:caching':
    - caching