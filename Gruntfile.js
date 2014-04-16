module.exports = function(grunt) {
	// Project configuration
	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),
		env : {
			options : {
				/* Shared Options Hash */
				//globalOption : 'foo'
			},
			dev: {
				NODE_ENV : 'DEVELOPMENT'
			},
			prod : {
				NODE_ENV : 'PRODUCTION'
			}
		},
		/*concat: {
			styles: {
				src: ['styles/skeleton.css','styles/colors.css','styles/spine.css','styles/respond.css'],
				dest: 'build/<%= pkg.build_version %>/spine.css',
			},
			scripts: {
				src: [
					'scripts/debug.js',
				],
				dest: 'build/<%= pkg.build_version %>/spine.js',
			},
		},
		uglify: {
			options: {
				banner: ''
			},
			build: {
				src: 'build/<%= pkg.build_version %>/spine.js',
				dest: 'build/<%= pkg.build_version %>/spine.min.js'
			}
		},
		cssmin: {
			combine: {
				files: {
					// Hmmm, in reverse order
					'build/<%= pkg.build_version %>/spine.min.css': ['build/<%= pkg.build_version %>/spine.css']
				}
			}
		},*/
		copy: {
			main: {
				files: [
					{expand: true,flatten: true, src: ['pub/build/*.html'], dest: ''}
				]
			}
		},
		includereplace: {
			prep: {
				// Files to perform replacements and includes with
				src: 'build/*.html',
				// Destination directory to copy files to
				dest: 'pub/'
			},
		},
		preprocess : {
			options: {
				inline: true,
				context : {
					DEBUG: true,
					build_version : '<%= pkg.build_version %>',
				}
			},
			index : {
				src : 'src/index.html',
				dest : 'build/index.html',
				options : {
					context : {
						page : 'index'
					}
				}
			},
			production : {
				src : 'src/index.html',
				dest : 'build/production.html',
				options : {
					context : {
						page : 'production'
					}
				}
			},
		}
	});

	// Load the plugin that provides the "uglify" task.
	grunt.loadNpmTasks('grunt-env');
	grunt.loadNpmTasks('grunt-include-replace');
	grunt.loadNpmTasks('grunt-contrib-less');
	grunt.loadNpmTasks('grunt-contrib-uglify');
	grunt.loadNpmTasks('grunt-contrib-jshint');
	grunt.loadNpmTasks('grunt-contrib-concat');
	grunt.loadNpmTasks('grunt-contrib-copy');
	grunt.loadNpmTasks('grunt-contrib-cssmin');
	grunt.loadNpmTasks('grunt-preprocess');

	// Default task(s).
	grunt.registerTask('default', ['jshint']);
	grunt.registerTask('prod', ['env:prod', 'concat','preprocess:js','cssmin','uglify','copy','includereplace','preprocess:html']);	
	
	grunt.registerTask('dev', [
								'env:dev',
								'preprocess',
								'includereplace',
								'copy',
								]);
		
		
};