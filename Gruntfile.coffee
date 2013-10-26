module.exports = (grunt) ->
  grunt.initConfig
    stylus:
      compile:
        options:
          compress: off
        files:
          'public/css/clonkspot.css': 'css/*.styl'
          'public/css/pages.css': 'css/pages/*.styl'
    coffee:
      # Replicate structure in /js in /public/js/app.
      compile:
        expand: true
        cwd: 'js'
        src: ['**/*.coffee']
        dest: 'public/js/app'
        ext: '.js'

    copy:
      # Copy non-CS files in the respective folder.
      js:
        expand: true
        cwd: 'js'
        src: ['**/*.js']
        dest: 'public/js/app'

    bower:
      install:
        options:
          targetDir: './public/js/lib'
          layout: (type, component) -> component
          cleanTargetDir: true

    watch:
      stylus:
        files: 'css/**/*.styl'
        tasks: 'stylus'
      js:
        files: 'js/**/*'
        tasks: ['coffee', 'copy']

  grunt.loadNpmTasks 'grunt-bower-task'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'default', ['stylus', 'coffee', 'copy']

