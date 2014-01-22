base:
  '*':
    - serverbase
    - database
    - security
    - web
    - caching
    - finalize.restart
  'env:vagrant':
    - match: grain
    - env.development
    - finalize.restart
  'env:production':
    - match: grain
    - env.production
    - finalize.restart

    
  