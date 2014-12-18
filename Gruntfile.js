
module.exports = function(grunt) {
	require('load-grunt-tasks')(grunt);
  grunt.initConfig({

  	app: {
  	  name: 'raspberrypi_twitter_slideshow',
  	  dist: 'dist',
  	  node: 'node_app',
  	  shell: 'shell_scripts',
  	},
  	sshconfig:{
  		'raspberry': grunt.file.readJSON('secrets.json'),
  	},

  	coffee: {
  	  compile: {
  	    files: [{
  	      expand: true,
  	      cwd: '<%= app.node %>',
  	      src: [
  	        // '{app,components}/**/*.coffee',
  	        '**/*.coffee',
  	      ],
  	      dest: '<%= app.dist %>/',
  	      ext: '.js'
  	    }]
  	  }
  	},

  	watch: {
  	  coffee: {
  	    files: [
  	      '<%= app.node %>/**/*.{coffee,litcoffee,coffee.md}',
  	    ],
  	    tasks: ['coffee:compile']
  	  },
  	  shell: {
  	    files: [
  	      '<%= app.shell %>/**/*',
  	    ],
  	    tasks: ['copy:dist']
  	  },
  	},

  	nodemon: {
  	  dev: {
  	    script: '<%= app.dist %>/app.js'
  	  }
  	},

  	copy: {
  	  dist: {
  	    files: [{
  	      expand: true,
  	      dest: '<%= app.dist %>',
  	      src: [
  	        'package.json',
  	        'secrets.json',
  	        '<%= app.shell %>/**/*'
  	      ]
  	    }]
  	  },
  	},

  	clean: {
  	  dist: {
  	    files: [{
  	      dot: true,
  	      src: [
  	        '<%= app.dist %>/*',
  	      ]
  	    }]
  	  },
  	},

  	env: {
  	  prod: {
  	    NODE_ENV: 'production'
  	  },
  	  // all: require('./config/local.env')
  	},

  	sftp: {
  	  deploy: {
  	    files: {
  	      "./": "<%= app.dist %>/**"
  	    },
  	    options: {
  	      config: 'raspberry',
  	      path: '/home/pi/<%= app.name %>/',
  	      srcBasePath: "<%= app.dist %>/",
  	      showProgress: true,
  	      createDirectories: true,
  	    }
  	  }
  	},
  	sshexec: {
  	  start: {
  	    command: [
  	      'cd ~/<%= app.name %>',
  	      'source ~/.bash_profile',
  	      'npm install --production',
  	      'export NODE_ENV=production',
  	      'forever stopall',
  	      'forever start app.js',
  	      'forever list',
  	    ].join(' && '),
  	    options: {
  	      config: 'raspberry',
  	    }
  	  }
  	}

  });
  grunt.registerTask('compile', [
  	'clean:dist',
  	'copy:dist',
  	'coffee:compile'
	]);
  grunt.task.registerTask(
  	'deploy',
  	'Deploy to Raspberry Pi. Pass "start" as second argument to start app after deployment',
  	function(arg) {
	    if (arg === 'start') {
	      return grunt.task.run(['compile', 'sftp:deploy', 'sshexec:start',]);
	    } else {
	      return grunt.task.run(['compile', 'sftp:deploy',]);
	    }
  });
  grunt.registerTask('default', [
  	'compile',
  	'watch',
  ]);

};
