base:
  'env:serverbase':
    - serverbase
  'env:database':
    - database
  'env:security':
    - security
  'env:web':
    - web
  'env:caching':
    - caching
  'env:vagrant':
    - match: grain
    - env.development
    - finalize.restart
  'env:production':
    - match: grain
    - env.production
    - finalize.restart