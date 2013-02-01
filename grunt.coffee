module.exports = (grunt) ->
  grunt.initConfig
    stylus:
      compile:
        files:
          'public/css/clonkspot.css': 'css/*.styl'

  grunt.loadNpmTasks 'grunt-contrib-stylus'

  grunt.registerTask 'default', 'stylus'
