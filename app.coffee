# Frontend application

express = require 'express'
ECT = require 'ect'

# Setup ECT rendering
renderer = ECT root: "#{__dirname}/html", watch: on, ext: '.ect'

# Get the language strings
lang =
  de: require('./lang/de')
  en: require('./lang/en')

data = require './data'

# Returns the best fitting language strings.
chooseLanguage = (req) ->
  # Check the cookies.
  switch req.cookies.language
    when 'de' then return lang.de
    when 'en' then return lang.en
  # Try to guess the correct language based on browser settings.
  for l in req.acceptedLanguages
    return lang.de if l.indexOf('de') != -1
    return lang.en if l.indexOf('en') != -1
  # Default to English
  lang.en

module.exports.app = app = express()

app.use express.static('public')
app.use express.cookieParser()

app.engine 'ect', renderer.render

app.get '/', (req, res) ->
  res.send renderer.render 'index', {data, t: chooseLanguage(req)}

unless app.get('env') is 'production'
  # Get images from the production server.
  app.get '/images/*', (req, res) ->
    res.redirect 'http://clonkspot.org/images/'+req.params[0]

PORT = 3235
app.listen PORT
console.log "Running on port #{PORT}"
