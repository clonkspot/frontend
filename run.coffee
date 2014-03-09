# Run the application.

{app} = require './app'
cfg = require './cfg'

PORT = cfg.get 'port'
app.listen PORT
console.log "Running on port #{PORT}"
