---
layout: post
title: "Simple tasks with Grunt"
date: 2014-03-03 15:16
comments: true
categories:
- technology
---
Developers are lazy by nature and always look for ways to avoid having to perform repetitive tasks. There are plenty of options when you're working with conventional server-side platforms.  Unfortunately, when it comes to JavaScripts and CSS, automation tools are harder to find. That is, until Grunt comes along (following Node, which turned upside down the whole idea of server vs client side in the first place).

As a self-described "task runner", Grunt is powerful and pleasantly approachable.  Its succinctness makes it a joy to use.  This carries over into the Grunt documentation, which is really excellent.  Inspired by the [Sample Gruntfile tutorial](http://gruntjs.com/sample-gruntfile), I'd like to walk through my own `Gruntfile` created for a [small JavaScript library](https://github.com/dinhyen/darkbox).  The goal is to automate a typical process of building the app, from generating CSS from Sass, aggregating various source files into a single file, and minifying the result.

Once you [have Grunt installed](http://gruntjs.com/installing-grunt) using the Node Package Manager, you will need a `package.json` file, just as for other Node utilities.  The quickest way to create a `package.json` file is to simply run `npm init` which generates the file after a series of questions.

The following libraries will be used:

* [grunt-contrib-compass](https://github.com/gruntjs/grunt-contrib-compass): generates CSS from Sass
* [grunt-contrib-concat](https://github.com/gruntjs/grunt-contrib-concat): combines various files into a single file
* [grunt-contrib-cssmin](https://github.com/gruntjs/grunt-contrib-cssmin): minifies CSS
* [grunt-contrib-jshint](https://github.com/gruntjs/grunt-contrib-jshint): combs through JavaScript and flags errors or usage issues
* [grunt-contrib-uglify](https://github.com/gruntjs/grunt-contrib-uglify): mangles and minifies JavaScript
* [grunt-contrib-watch](https://github.com/gruntjs/grunt-contrib-watch): performs tasks whenever a file changes

The recommended approach, as stated at the beginning of the documentation for each plugin, is to run `npm install grunt-contrib-xxx --save-dev`, which has the dual benefit of installing the plugin and also adding a reference to it in `package.json`.

Besides `package.json`, the only other file you need is `Gruntfile`, in which you define and configure the tasks to run. Configuration options are specified as the argument to `grunt.initConfig`.

The first line reads in `package.json` and turns it into an object.  In this case, I'm interested in product name, but it can provide [many other useful properties](http://package.json.nodejitsu.com).

``` javascript
pkg: grunt.file.readJSON('package.json'),
```

All `Gruntfile` tasks share the [same basic syntax](http://gruntjs.com/configuring-tasks) for specifying options, input and output.  Each task's configuration block is named after the plugin; for example, the configuration block for the `grunt-contrib-uglify` is simply `uglify`.  Each task can have arbitrary targets.  You'll probably see a "test" target for testing or a "dist" target for building a distribution.  Since I want to build CSS and JavaScript, here I have 2 targets, "scripts" and "stylesheets".  When there are multiple targets in a task, each target can be executed directly.  For example, `grunt concat:scripts` runs just the "scripts" target.  If you don't provide a target, then all targets would be run in order.

The Compass task generates CSS from Sass source.  Of course, Compass [must be installed](http://compass-style.org/install) first.  The following options simply instruct Compass to process Sass files in the directory "sass" and generate the corresponding CSS files in the directory "css".
``` javascript
compass: {
  stylesheets: {
    options: {
      sassDir: 'sass',
      cssDir: 'css'
    }
  }
}
```

When developing, it would be nice to be able to preview changes made to the Sass source.  This is where the watch plugin comes in.  In the simplest use case it simply detects that one or more files have been changed and then runs certain tasks.  The following options allow me to re-generate CSS each time a Sass file is modified.  Start watching by typing `grunt watch` at the command prompt.

``` javascript
watch: {
  stylesheets: {
    files: '**/*.scss',
    tasks: ['compass']
  }
}
```

Typically JavaScript and CSS source is distributed over multiple files.  In production you'd want to combine the various source files into a single file for performance reason.  This can be done with the concat plugin.  For the source, I'm using a globbing pattern for simplicity; `src/**/*.js` means all `.js` files in the `src` directory and any of its sub-directories.  The files would be combined in alphabetical order. An alternative would be to specify an array of individual files.  While this lets you control the ordering of files, it becomes unwieldy for a large number of files. Of course, there are [many ways](http://gruntjs.com/configuring-tasks#globbing-patterns) to skin the cat.  For the output, I'm using the project's name which comes from `package.json`.

``` javascript
concat: {
  scripts: {
    options: {
      separator: ';'
    },
    src: 'src/**/*.js',
    dest: 'dist/<%= pkg.name %>.js'
  },
  stylesheets: {
    src: 'css/**/*.css',
    dest: 'dist/<%= pkg.name %>.css'
  }
}
```

The cssmin plugin provides CSS minification.  The source should be the output of the concat stage.  Note the variable substitution syntax.

``` javascript
cssmin: {
  stylesheets: {
    src: '<%= concat.stylesheets.dest %>',
    dest: 'dist/<%= pkg.name %>.min.css'
  }
}
```

The uglify plugin is the JavaScript equivalent of cssmin.  It also mangles variable names which reduces file size further at the expense of readability.  Since mangling pretty much makes your JavaScript indecipherable and impossible to debug, you can also provide a [source map](http://www.html5rocks.com/en/tutorials/developertools/sourcemaps/) which lets you view the original, non-uglified source when debugging.  The uglify plugin have all these and sundry options.  Here it also inserts a comment with some basic information at the top of the file.

``` javascript
uglify: {
  options: {
    banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n',
    sourceMap: true
  },
  scripts: {
    src: '<%= concat.scripts.dest %>',
    dest: 'dist/<%= pkg.name %>.min.js'
  }
}
```

The jshint configuration block just sets some [options for jshint](http://www.jshint.com/docs/options).
``` javascript
jshint: {
  options: {
    curly: true,
    eqeqeq: true,
    immed: true,
    latedef: true,
    newcap: true,
    noarg: true,
    sub: true,
    undef: true,
    unused: true,
    boss: true,
    eqnull: true,
    node: true
  }
```

Finally register a default task and a useful task.  Tasks would be executed in the order specified.
``` javascript
grunt.registerTask('default', ['jshint', 'compass', 'concat', 'cssmin', 'uglify']);
grunt.registerTask('sassify', ['compass']);
```

To run a task, simply specify the task's name as a argument to `grunt` on the command line; e.g., `grunt jshint`.  Simply typing `grunt` runs the default task.  Below is the output for running the default task; even for this small set of tasks, running them manually or maintaining a script without Grunt would have been a tedious chore.

```
Running "jshint:scripts" (jshint) task
>> 2 files lint free.

Running "compass:stylesheets" (compass) task
unchanged sass/darkbox.scss
unchanged sass/mixins.scss
unchanged sass/screen.scss
Compilation took 0.012s

Running "concat:scripts" (concat) task
File dist/darkbox.js created.

Running "concat:stylesheets" (concat) task
File dist/darkbox.css created.

Running "cssmin:stylesheets" (cssmin) task
File dist/darkbox.min.css created: 3.9 kB → 2.78 kB

Running "uglify:scripts" (uglify) task
File dist/darkbox.min.map created (source map).
File dist/darkbox.min.js created: 5.45 kB → 2.51 kB

Done, without errors.
```

Below is the entire `Gruntfile`.  Happy grunting.


``` javascript
module.exports = function (grunt) {

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    compass: {
      stylesheets: {
        options: {
          sassDir: 'sass',
          cssDir: 'css'
        }
      }
    },
    concat: {
      scripts: {
        options: {
          separator: ';'
        },
        src: 'src/**/*.js',
        dest: 'dist/<%= pkg.name %>.js'
      },
      stylesheets: {
        src: 'css/**/*.css',
        dest: 'dist/<%= pkg.name %>.css'
      }
    },
    cssmin: {
      stylesheets: {
        src: '<%= concat.stylesheets.dest %>',
        dest: 'dist/<%= pkg.name %>.min.css'
      }
    },
    jshint: {
      options: {
        curly: true,
        eqeqeq: true,
        immed: true,
        latedef: true,
        newcap: true,
        noarg: true,
        sub: true,
        undef: true,
        unused: true,
        boss: true,
        eqnull: true,
        node: true
      },
      scripts: {
        src: ['Gruntfile.js', 'src/*.js']
      }
    },
    uglify: {
      options: {
        banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n',
        sourceMap: true
      },
      scripts: {
        src: '<%= concat.scripts.dest %>',
        dest: 'dist/<%= pkg.name %>.min.js'
      }
    },
    watch: {
      stylesheets: {
        files: '**/*.scss',
        tasks: ['compass']
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-compass');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-watch');

  grunt.registerTask('default', ['jshint', 'compass', 'concat', 'cssmin', 'uglify']);
  grunt.registerTask('sassify', ['compass']);
};
```
