module.exports = (grunt) ->

  # Load Grunt tasks declared in the package.json file
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  # Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")
    exec:
      casper: 'casperjs --web-security=false --ignore-ssl-errors=true --ssl-protocol=any --user=20009324 --class-time="6:30am" --class-name="Stretching" booking.coffee'
    watch:
      exec:
        files: ['**/*.coffee']
        tasks: ['exec']

  # Default task(s).
  grunt.registerTask "default", ['exec','watch']
