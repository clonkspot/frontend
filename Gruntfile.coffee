module.exports = (grunt) ->
  grunt.initConfig
    stylus:
      compile:
        options:
          compress: off
        files:
          'public/css/clonkspot.css': 'css/*.styl'
    browserify:
      main:
        files: 'public/js/main.js': 'js/main.coffee'
      home:
        files: 'public/js/home.js': 'js/home.coffee'
    watch:
      stylus:
        files: 'css/*.styl'
        tasks: 'stylus'
      browserify:
        files: 'js/**/*'
        tasks: 'browserify'

  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'default', ['stylus', 'browserify']

  grunt.registerMultiTask 'browserify', 'Runs browserify', ->
    browserify = require 'browserify'
    for file, i in @files
      b = browserify(@options())
      b.addEntry(f) for f in file.src
      bundle = b.bundle()
      grunt.file.write file.dest, bundle
    return
