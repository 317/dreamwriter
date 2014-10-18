module.exports = function(grunt) {
  htmlminFiles = {"dist/index.html": "src/index.html"}

  grunt.initConfig({
    clean: ["dist"],

    watch: {
      elm: {
        files: ["Dreamwriter/**/*.elm", "*.elm"],
        tasks: ["elm"]
      },
      stylus: {
        files: ["src/stylesheets/**/*.styl"],
        tasks: ["stylus:dev", "autoprefixer:dev"]
      },
      html: {
        files: ["src/index.html"],
        tasks: ["htmlmin"]
      },
      images: {
        files: ["src/images/*.*"],
        tasks: ["copy:images"]
      },
      fonts: {
        files: ["src/fonts/*.*"],
        tasks: ["copy:fonts"]
      },
      bower: {
        files: ["bower.json"],
        tasks: ["browserifyBower"]
      },
      dist: {
        files: ["dist/**/*", "!dist/dreamwriter.appcache", "!dist/cache/**/*"],
        tasks: ["copy:cache", "appcache"]
      },
      distJS: {
        files: ["dist/**/*.js"],
        tasks: ["uglify:dev"]
      }
    },

    connect: {
      dev: {
        options: {
          port: 8000,
          base: 'dist'
        }
      },
      prod: {
        options: {
          port: "<%= connect.dev.options.port %>",
          base: '<%= connect.dev.options.base %>',
          keepalive: true
        }
      }
    },

    uglify: {
      prod: {
        options: {
          sourceMap: false
        },
        files: {
          "dist/App.js": "dist/App.js",
          "dist/vendor.js": "dist/vendor.js",
          "dist/bootstrap-elm.js": "dist/bootstrap-elm.js"
        },
      }
    },

    copy: {
      images: {
        expand: true,
        cwd: "src",
        src: "images/**",
        dest: "dist/"
      },
      fonts: {
        expand: true,
        cwd: "src",
        src: "fonts/**",
        dest: "dist/"
      },
      cache: {
        expand: true,
        cwd: "dist",
        src: ["*.*", "fonts/*.*", "images/*.*"],
        dest: "dist/cache/"
      }
    },

    stylus: {
      dev: {
        linenos: true,
        paths: ["src/stylesheets/*.styl"],
        files: {
          "dist/dreamwriter.css": ["src/stylesheets/*.styl"]
        }
      },
      prod: {
        linenos: false,
        paths: "<%= stylus.dev.paths %>",
        files: "<%= stylus.dev.files %>"
      }
    },

    autoprefixer: {
      dev: {
        options: {
          map: true,
          src: "dist/dreamwriter.css",
          dest: "dist/dreamwriter.css"
        },
      },
      prod: {
        options: {
          map: false,
          src: "<%= autoprefixer.dev.src %>",
          dest: "<%= autoprefixer.dev.dest %>"
        }
      }
    },

    elm: {
      dreamwriter: {
        srcDir: "Dreamwriter",
        files: {
          "dist": "App.elm"
        }
      }
    },

    browserify: {
      options: {
        transform: ['browserify-mustache', 'coffeeify']
      },
      dev: {
        extensions: ['.coffee', '.mustache', '.json'],
        src: ["./src/**/*.coffee", "./src/**/*.mustache", "./src/**/*.json"],
        dest: "dist/bootstrap-elm.js",
        browserifyOptions: {
          debug: true
        },
        watch: true
      },
      prod: {
        extensions: "<%= browserify.dev.extensions %>",
        src: "<%= browserify.dev.src %>",
        dest: "<%= browserify.dev.dest %>",
        browserifyOptions: {
          debug: false
        }
      }
    },

    browserifyBower: {
      options: {
        file: "dist/vendor.js",
        forceResolve: {
          "FileSaver.js": "FileSaver.min.js",
          "db.js": "src/db.js"
        }
      },
      vendor: {}
    },

    htmlmin: {
      options: {
        removeComments: true,
        collapseWhitespace: true
      },
      dev: {
        files: htmlminFiles
      },
      prod: {
        files: htmlminFiles
      }
    },

    cssmin: {
      dev: {
        files: {
          'dist/dreamwriter.css': 'dist/dreamwriter.css'
        }
      },
      prod: {
        files: "<%= cssmin.dev.files %>"
      }
    },

    appcache: {
      options: {
        basePath: 'dist'
      },
      dev: {
        dest: 'dist/dreamwriter.appcache',
        network: '*'
      },
      prod: {
        dest: 'dist/dreamwriter.appcache',
        cache: {
          patterns: ['dist/cache/**/*']
        },
        network: '*',
        fallback: [
          '/                               /cache/index.html',
          '/index.html                     /cache/index.html',
          '/dreamwriter.css                /cache/dreamwriter.css',
          '/App.js                         /cache/App.js',
          '/vendor.js                      /cache/vendor.js',
          '/bootstrap-elm.js               /cache/bootstrap-elm.js',
          '/fonts/robot-slab-bold.woff     /cache/fonts/roboto-slab-bold.woff',
          '/fonts/roboto-slab-regular.woff /cache/fonts/roboto-slab-regular.woff',
          '/fonts/ubuntu.woff              /cache/fonts/ubuntu.woff',
          '/images/dlogo.png               /cache/images/dlogo.png',
          '/images/dropbox-logo.png        /cache/images/dropbox-logo.png',
          '/images/favicon.ico             /cache/images/favicon.ico',
          '/images/quarter-backdrop.jpg    /cache/images/quarter-backdrop.jpg']
      }
    }
  });

  ["grunt-contrib-watch", "grunt-contrib-htmlmin", "grunt-contrib-cssmin", "grunt-contrib-htmlmin", "grunt-contrib-uglify", "grunt-contrib-clean", "grunt-elm", "grunt-browserify", "grunt-browserify-bower", "grunt-contrib-copy", "grunt-contrib-connect", "grunt-contrib-stylus", "grunt-autoprefixer", "grunt-appcache"].forEach(function(plugin) {
    grunt.loadNpmTasks(plugin);
  });

  grunt.registerTask("build:prod", ["stylus:prod", "autoprefixer:prod", "browserifyBower", "browserify:prod", "elm", "htmlmin:prod", "copy", "uglify:prod", "cssmin:prod", "appcache:prod"]);
  grunt.registerTask("build:dev",  ["stylus:dev",  "autoprefixer:dev",  "browserifyBower", "browserify:dev",  "elm", "htmlmin:dev",  "copy",                               "appcache:dev"]);

  grunt.registerTask("build", ["build:dev"]);
  grunt.registerTask("prod",  ["build:prod", "connect:prod"]);

  grunt.registerTask("default", ["clean", "build", "connect:dev", "watch"]);
};