extraRequires = ["react", "lodash"]

module.exports = (grunt) ->
  grunt.initConfig
    clean: ["dist"]

    watch:
      elm:
        files: ["Dreamwriter/**/*.elm", "*.elm"]
        tasks: ["elm"]

      stylus:
        files: ["src/stylesheets/**/*.styl"]
        tasks: ["stylesheets"]

      html:
        files: ["src/index.html"]
        tasks: ["copy:index"]

      images:
        files: ["src/images/*.*"]
        tasks: ["copy:images"]

      fonts:
        files: ["src/fonts/*.*"]
        tasks: ["copy:fonts"]

      coffee:
        files: ["src/**/*.coffee"]
        tasks: ["coffee"]

      dist:
        files: ["dist/**/*", "!dist/dreamwriter.appcache", "!dist/cache/**/*"]
        tasks: ["copy:cache", "appcache"]

    connect:
      static:
        options:
          port: 8000,
          base: 'dist'

    copy:
      index:
        src:  "src/index.html"
        dest: "dist/index.html"

      images:
        expand: true
        cwd: "src"
        src: "images/**"
        dest: "dist/"

      fonts:
        expand: true
        cwd: "src"
        src: "fonts/**"
        dest: "dist/"

      cache:
        expand: true
        cwd: "dist"
        src: [
          "*.*"
          "fonts/*.*"
          "images/*.*"
        ]
        dest: "dist/cache/"

      vendor:
        src:  "vendor/**/*.js"
        dest: "dist/vendor.js"

    stylus:
      compile:
        options:
          paths: ["src/stylesheets/*.styl"]
        files:
          "dist/dreamwriter.css": ["src/stylesheets/*.styl"]

    autoprefixer:
      dreamwriter:
        options:
          map: true

        src: "dist/dreamwriter.css"
        dest: "dist/dreamwriter.css"

    elm:
      dreamwriter:
        srcDir:   "Dreamwriter"
        files:
          "dist": "**/*.elm"

    coffee:
      bootstrap:
        options: sourceMap: true
        files:
          "dist/bootstrap-elm.js": "src/bootstrap-elm.coffee"

    appcache:
      options:
        basePath: 'dist'

      all:
        dest:     'dist/dreamwriter.appcache'
        cache:    patterns: ['dist/cache/**/*']
        network:  '*'
        fallback: [
          # TODO need to find some way to auto-generate this...
          '/                               /cache/index.html'
          '/index.html                     /cache/index.html'
          '/dreamwriter.css                /cache/dreamwriter.css'
          '/dreamwriter.css.map            /cache/dreamwriter.css.map'
          '/dreamwriter.js                 /cache/dreamwriter.js'
          '/vendor.js                      /cache/vendor.js'
          '/fonts/robot-slab-bold.woff     /cache/fonts/roboto-slab-bold.woff'
          '/fonts/roboto-slab-regular.woff /cache/fonts/roboto-slab-regular.woff'
          '/fonts/ubuntu.woff              /cache/fonts/ubuntu.woff'
          '/images/dlogo.png               /cache/images/dlogo.png'
          '/images/dropbox-logo.png        /cache/images/dropbox-logo.png'
          '/images/favicon.ico             /cache/images/favicon.ico'
          '/images/quarter-backdrop.jpg    /cache/images/quarter-backdrop.jpg'
        ]

  ["grunt-contrib-watch", "grunt-contrib-clean", "grunt-elm", "grunt-contrib-coffee", "grunt-contrib-copy", "grunt-contrib-connect", "grunt-contrib-stylus", "grunt-autoprefixer", "grunt-appcache"].forEach (plugin) -> grunt.loadNpmTasks plugin

  grunt.registerTask "build", [
    "stylesheets"
    "coffee"
    "elm"
    "copy"
    "appcache"
  ]

  grunt.registerTask "stylesheets", [
    "stylus"
    "autoprefixer"
  ]

  grunt.registerTask "default", [
    "clean"
    "build"
    "connect"
    "watch"
  ]
