base:
 'G@role:serverbase':
    - match: compound
    - serverbase
 'G@role:database':
    - match: compound
    - database
 'G@role:security':
    - match: compound
    - security
 'G@role:web':
    - match: compound
    - web
 'G@role:caching':
    - match: compound
    - caching
  'env:vagrant':
    - match: grain
    - env.development
    - finalize.restart
  'env:production':
    - match: grain
    - env.production
    - finalize.restart