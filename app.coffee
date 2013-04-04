# Frontend application

fs = require 'fs'

express = require 'express'
ECT = require 'ect'

# Initialize the application
module.exports.app = app = express()

# Is the application running in production?
GLOBAL.PRODUCTION = app.get('env') is 'production'

# Setup ECT rendering
renderer = ECT root: "#{__dirname}/html", watch: !PRODUCTION, ext: '.ect'

uncachedRequire = (path) ->
  delete require.cache[require.resolve path]
  require path

# Get the language strings
lang = if PRODUCTION
  de: require('./lang/de')
  en: require('./lang/en')
  common: require('./data')
else
  Object.create null,
    de:
      get: -> uncachedRequire('./lang/de')
    en:
      get: -> uncachedRequire('./lang/en')
    common:
      get: -> uncachedRequire('./data')

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

if PRODUCTION
  app.use express.logger()
else
  app.use express.logger 'dev'

app.use express.static('public')
app.use express.cookieParser()

app.engine 'ect', renderer.render

app.get '/', (req, res) ->
  res.send renderer.render 'index', {data: lang.common, t: chooseLanguage(req)}

# Semi-static pages
getPage = (page, url = "/#{page}") ->
  app.get url, (req, res) ->
    res.send renderer.render "pages/#{page}", {data: lang.common, t: chooseLanguage(req)}

fs.readdir "#{__dirname}/html/pages", (err, files) ->
  unless err
    for file in files
      if m = file.match /^(\w+)\.ect$/
        getPage m[1]
  return

# Comics
comics = lang.common.comics.length
# Renders the given comic, defaulting to the last one.
renderComic = (req, id = comics) ->
  renderer.render 'comic', {id, data: lang.common, t: chooseLanguage(req)}

app.get '/comic', (req, res) ->
  res.send renderComic(req)
app.get '/comic/random', (req, res) ->
  id = 1 + Math.floor(Math.random() * comics)
  res.redirect "/comic/#{id}"
app.get '/comic/:id', (req, res, next) ->
  id = +req.params.id
  if id > 0 && id <= comics
    res.send renderComic(req, id)
  else
    # Pass through to the 404 handler
    next()

unless PRODUCTION
  # Get images from the production server.
  app.get '/images/*', (req, res) ->
    res.redirect 'http://clonkspot.org/images/'+req.params[0]

# 404 handler
app.use (req, res, next) ->
  res.status(404).send renderer.render '404', {data: lang.common, t: chooseLanguage(req)}

# Only run if invoked directly.
if process.argv[1] is __filename
  PORT = 3235
  app.listen PORT
  console.log "Running on port #{PORT}"
