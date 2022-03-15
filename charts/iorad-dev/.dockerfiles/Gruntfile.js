'use strict';

module.exports = function (grunt) {
  // load all grunt tasks
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks);

  grunt.initConfig({
    watch: {
      app: {
        files: [
          'index.js'
        ],
        tasks: ['templates', 'workers', 'build']
      }
    },
    clean: {
      dist: {
        files: [
          {
            dot: true,
            src: [
              'node/dist/*',
            ]
          }
        ]
      },
      templates: {
        files: [
          {
            dot: true,
            src: [
              'node/dist/*'
            ]
          }
        ]
      },
      workers: {
        files: [
          {
            dot: true,
            src: [
              'node/dist/*'
            ]
          }
        ]
      },
      dt: {
        files: [
          {
            dot: true,
            src: [
              'node/dist/*'
            ]
          }
        ]
      }
    },
  });

  grunt.registerTask('templates', [
    'clean:templates',
  ]);

  grunt.registerTask('workers', [
    'clean:workers',
  ]);

  grunt.registerTask('dt', [
    'clean:dt',
  ]);

  grunt.registerTask('build', [
    'clean:dist',
  ]);

  grunt.registerTask('default', ['build']);
};