# Frontend application

fs = require 'fs'
url = require 'url'

express = require 'express'
ECT = require 'ect'
proxy = require 'proxy-middleware'

cfg = require './cfg'

require './lib/polyfill'

# Initialize the application
module.exports.app = app = express()

# Is the application running in production?
GLOBAL.PRODUCTION = app.get('env') is 'production'

# Setup ECT rendering
renderer = ECT root: "#{__dirname}/html", watch: !PRODUCTION, ext: '.ect'

# Get the page data.
loader = require './lib/loader'

if PRODUCTION
  app.use express.logger()
else
  app.use express.logger 'dev'

  # Proxy api requests to the online backend.
  app.use '/api', proxy(url.parse(cfg.get('proxy.api')))
  # Proxy blog and forum pages to prevent broken links in the dev environment.
  app.use '/blog', proxy(url.parse('https://clonkspot.org/blog'))
  app.use '/forum', proxy(url.parse('https://clonkspot.org/forum'))

app.use express.static('public')
app.use express.cookieParser()

app.engine 'ect', renderer.render

app.get '/', (req, res) ->
  res.send renderer.render 'index', loader.pageData(req)

# Semi-static pages
getPage = (page, url = "/#{page}") ->
  app.get url, (req, res) ->
    res.send renderer.render "pages/#{page}", loader.pageData(req)

fs.readdir "#{__dirname}/html/pages", (err, files) ->
  unless err
    for file in files
      if m = file.match /^(\w+)\.ect$/
        getPage m[1]
  return

# Comics
comics = loader.lang.common.comics.length
# Renders the given comic, defaulting to the last one.
renderComic = (req, id = comics) ->
  renderer.render 'comic', loader.pageData(req, {id})

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

# Header/footer in JSON for the blog
app.get '/_layout', (req, res) ->
  header = renderer.render 'header', loader.pageData(req)
  footer = renderer.render 'footer', loader.pageData(req)
  res.send {header, footer}

unless PRODUCTION
  # Get images from the production server.
  app.get '/images/*', (req, res) ->
    res.redirect 'https://clonkspot.org/images/'+req.params[0]

# 404 handler
app.use (req, res, next) ->
  res.status(404).send renderer.render '404', loader.pageData(req)
