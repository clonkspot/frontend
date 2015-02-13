// Run the application.

require('coffee-script/register')
var app = require('./app').app
var cfg = require('./cfg')

var PORT = cfg.get('port')
app.listen(PORT)
console.log('Running on port ' + PORT)
