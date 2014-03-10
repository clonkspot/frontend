convict = require 'convict'

conf = convict
  env:
    doc: 'The applicaton environment.'
    format: ['production', 'development', 'test']
    default: 'development'
    env: 'NODE_ENV'

  port:
    doc: 'The port to bind.'
    format: 'port'
    default: 3235
    env: 'PORT'

  proxy:
    api:
      doc: 'The backend api url.'
      format: 'url'
      default: 'https://clonkspot.org/api'
      env: 'API_PROXY'

conf.validate()
module.exports = conf
