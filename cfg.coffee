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
    dpd:
      doc: 'The dpd api url.'
      format: 'url'
      default: 'http://clonkspot.org/dpd'
      env: 'DPD_PROXY'
    api:
      doc: 'The backend api url.'
      format: 'url'
      default: 'http://clonkspot.org/api'
      env: 'API_PROXY'

conf.validate()
module.exports = conf
