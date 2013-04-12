# Helpers for loading page data.

_ = require 'underscore'

uncachedRequire = (path) ->
  delete require.cache[require.resolve path]
  require path

# Get the language strings
lang = if PRODUCTION
  de: require('../lang/de')
  en: require('../lang/en')
  common: require('../data')
else
  Object.create null,
    de:
      get: -> uncachedRequire('../lang/de')
    en:
      get: -> uncachedRequire('../lang/en')
    common:
      get: -> uncachedRequire('../data')

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

# Returns an object containing data for passing to templates.
pageData = (req, data = {}) ->
  _.extend {req, t: chooseLanguage(req), data: lang.common}, data

module.exports = {lang, chooseLanguage, pageData}
