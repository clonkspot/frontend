module.exports = (grunt) ->
  grunt.initConfig
    stylus:
      compile:
        files:
          'public/css/clonkspot.css': 'css/*.styl'
    watch:
      stylus:
        files: 'css/*.styl'
        tasks: 'stylus'

  grunt.loadNpmTasks 'grunt-contrib-stylus'

  grunt.registerTask 'default', 'stylus'
