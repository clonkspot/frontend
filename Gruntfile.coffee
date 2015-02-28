module.exports = (grunt) ->
  grunt.initConfig
    stylus:
      compile:
        options:
          compress: off
        files:
          'public/css/clonkspot.css': 'css/*.styl'
          'public/css/pages.css': 'css/pages/*.styl'
    browserify:
      main:
        files: 'public/js/main.js': 'js/main.coffee'
      home:
        files: 'public/js/home.js': 'js/home.coffee'
      games:
        files: 'public/js/games.js': 'js/games.coffee'
    coffee:
      header:
        files: 'public/js/header.js': 'js/header.coffee'
    watch:
      stylus:
        files: 'css/**/*.styl'
        tasks: 'stylus'
      browserify:
        files: 'js/**/*'
        tasks: ['browserify', 'coffee']

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'default', ['stylus', 'browserify', 'coffee']

  grunt.registerMultiTask 'browserify', 'Runs browserify', ->
    browserify = require 'browserify'
    for file, i in @files
      b = browserify(@options())
      b.addEntry(f) for f in file.src
      bundle = b.bundle()
      grunt.file.write file.dest, bundle
    return

  grunt.registerTask 'layout', 'Create the static layout files', ->
    done = @async()
    request = require('supertest')(require('./app').app)
    ['de', 'en'].forEach (lang) ->
      request.get('/_layout')
        .set('Accept-Language', lang)
        .expect(200)
        .end (err, res) ->
          throw err if err
          for key, content of res.body
            grunt.file.write "public/layout/#{key}-#{lang}.html", content
          done()
