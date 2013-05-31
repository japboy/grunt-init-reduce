'use strict'

# Load required Node.js modules
path = require 'path'

# Load LiveReload snippet
lrUtils = require 'grunt-contrib-livereload/lib/utils'
lrSnippet = lrUtils.livereloadSnippet

# Helper function for LiveReload
folderMount = (connect, point) ->
  return connect.static path.resolve(point)


#
# Grunt main configuration
# ------------------------
module.exports = (grunt) ->

  #
  # Initial configuration object for Grunt
  # passed to `grunt.initConfig()`
  #
  conf =

    # Read `package.json` by `<%= pkg.PROP  %>`
    pkg: grunt.file.readJSON 'package.json'

    # Banner string read by `<%= banner %>`
    banner: """
      /*!
       * <%= pkg.title || pkg.name %>
       * v<%= pkg.version %> - <%= grunt.template.today('isoDateTime') %>
       */
      """

    # Setup basic paths and read them by `<%= path.PROP %>`
    path:
      source: 'src'
      intermediate: '.intermediate'
      publish: 'dist'
      test: 'test'

    #
    # Task to compile CoffeeScript
    #
    # * [grunt-contrib-coffee](https://github.com/gruntjs/grunt-contrib-coffee)
    #
    coffee:
      options:
        bare: false
        sourceMap: true
      general:
        expand: true
        cwd: '<%= path.source %>/js'
        src: '*.coffee'
        dest: '<%= path.intermediate %>/js'
        ext: '.js'
      modules:
        files:
          '<%= path.intermediate %>/js/modules.js': [
            '<%= path.source%>/js/modules/*.coffee'
          ]

    #
    # Task to lint CoffeeScript
    #
    # * [grunt-coffeelint](https://github.com/vojtajina/grunt-coffeelint)
    # * [CoffeeLint options](http://www.coffeelint.org/#options)
    #
    coffeelint:
      options:
        indentation: 2
        max_line_length: 80
        camel_case_classes: true
        no_trailing_semicolons:  true
        no_implicit_braces: true
        no_implicit_parens: false
        no_empty_param_list: true
        no_tabs: true
        no_trailing_whitespace: true
        no_plusplus: false
        no_throwing_strings: true
        no_backticks: true
        line_endings: true
        no_stand_alone_at: false
      source:
        expand: true
        cwd: '<%= path.source %>'
        src: [
          'js/**/*.coffee'
          'js/**/*.litcoffee'
          '!js/vendor/**/*'
          'Gruntfile.coffee'
        ]

    #
    # Task to remove files & directories
    #
    # * [grunt-contrib-clean](https://github.com/gruntjs/grunt-contrib-clean)
    #
    clean:
      options:
        force: true
      intermediate:
        src: '<%= path.intermediate %>'
      publish:
        src: '<%= path.publish %>'

    #
    # Task to launch Connect & LiveReload static web server
    #
    # * [grunt-contrib-connect](https://github.com/gruntjs/grunt-contrib-connect)
    # * [grunt-contrib-livereload](https://github.com/gruntjs/grunt-contrib-livereload)
    #
    connect:
      intermediate:
        options:
          port: 50000
          middleware: (connect, options) ->
            return [lrSnippet, folderMount(connect, '.intermediate')]
      publish:
        options:
          port: 50001
          base: '<%= path.publish %>'

    #
    # Task to copy files
    #
    # * [grunt-contrib-copy](https://github.com/gruntjs/grunt-contrib-copy)
    #
    copy:
      source:
        expand: true
        cwd: '<%= path.source %>'
        src: [
          '**/*'
          '!**/*.coffee'
          '!**/*.hbs'
          '!**/*.jade'
          '!**/*.jst'
          '!**/*.less'
          '!**/*.litcoffee'
          '!**/*.sass'
          '!**/*.scss'
          '!**/*.styl'
        ]
        dest: '<%= path.intermediate %>'

    #
    # Task to compile Jade
    #
    # * [grunt-contrib-jade](https://github.com/gruntjs/grunt-contrib-jade)
    #
    jade:
      options:
        pretty: true
        data: ->
          return grunt.file.readJSON './src/meta.json'
      source:
        expand: true
        cwd: '<%= path.source %>'
        src: '**/!(_)*.jade'
        dest: '<%= path.intermediate %>'
        ext: '.html'

    #
    # Task to lint JavaScript by JSHint
    #
    # * [grunt-contrib-jshint](https://github.com/gruntjs/grunt-contrib-jshint)
    #
    jshint:
      options:
        jshintrc: '.jshintrc'
      source:
        expand: true
        cwd: '<%= path.source %>/js'
        src: [
          '**/*.js'
          '!vendor/**/*.js'
          '!socials.js'
        ]

    #
    # Task to lint JSON
    #
    # * [grunt-jsonlint](https://github.com/brandonramirez/grunt-jsonlint)
    #
    jsonlint:
      source:
        src: [
          '<%= path.source %>/**/*.json'
          'package.json'
        ]

    #
    # Task to notify messages
    #
    # * [grunt-notify](https://github.com/dylang/grunt-notify)
    #
    notify:
      build:
        options:
          title: 'Build completed'
          message: 'Successfully finished.'
      watch:
        options:
          title: 'Watch started'
          message: 'Local server launched: http://localhost:50000/'

    #
    # Task to optimise HTML/CSS/JavaScript & images by AssetGraph Builder
    #
    # * [grunt-reduce](https://github.com/Munter/grunt-reduce)
    # * [AssetGraph](https://github.com/One-com/assetgraph)
    # * [AssetGraph-sprite](https://github.com/One-com/assetgraph-sprite)
    # * [AssetGraph-builder](https://github.com/One-com/assetgraph-builder)
    #
    reduce:
      root: '<%= path.intermediate %>'
      outRoot: '<%= path.publish %>'
      less: false
      manifest: false
      pretty: false
      asyncScripts: false
      sharedBundles: true

    #
    # Task to compile Stylus
    #
    # * [grunt-contrib-stylus](https://github.com/gruntjs/grunt-contrib-stylus)
    #
    stylus:
      options:
        compress: false
      source:
        expand: true
        cwd: '<%= path.source %>/css'
        src: '**/!(_)*.styl'
        dest: '<%= path.intermediate %>/css'
        ext: '.css'

    #
    # Task to observe file changes & fire up related tasks
    #
    # * [grunt-contrib-watch](https://github.com/gruntjs/grunt-contrib-watch)
    #
    watch:
      options:
        livereload: true
      source:
        files: '<%= path.source %>/**/*'
        tasks: [
          'default'
        ]


  #
  # List of sequential tasks
  # passed to `grunt.registerTask tasks.TASK`
  #
  tasks =
    css: [
      'stylus'
    ]
    html: [
      'jade'
    ]
    js: [
      'jshint'
      #'coffeelint'
      'coffee'
    ]
    json: [
      'jsonlint'
    ]
    watcher: [
      'connect'
      'watch'
      'notify:watch'
    ]
    default: [
      'css'
      'html'
      'js'
      'json'
      'copy:source'
      'reduce'
      'notify:build'
    ]


  # Load Grunt plugins
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-livereload'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-jsonlint'
  grunt.loadNpmTasks 'grunt-notify'
  grunt.loadNpmTasks 'grunt-reduce'

  # Load initial configuration being set up above
  grunt.initConfig conf

  # Regist sequential tasks being listed above
  grunt.registerTask 'css', tasks.css
  grunt.registerTask 'html', tasks.html
  grunt.registerTask 'js', tasks.js
  grunt.registerTask 'json', tasks.json
  grunt.registerTask 'watcher', tasks.watcher
  grunt.registerTask 'default', tasks.default
