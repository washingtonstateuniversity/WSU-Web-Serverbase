module.exports = function(grunt) {
	grunt.registerTask('build_site', 'Set up all pages', function() {
		function cmd_exec(cmd, args, cb_stdout, cb_end) {
			var spawn = require('child_process').spawn,
				child = spawn(cmd, args),
				me = this;
			me.exit = 0;  // Send a cb to set 1 when cmd exits
			child.stdout.on('data', function (data) { cb_stdout(me, data) });
			child.stdout.on('end', function () { cb_end(me) });
		}
		
		var nunjucks = require('nunjucks'),
			markdown = require('nunjucks-markdown');
		var env = nunjucks.configure('views');
			markdown.register(env);
		
		
		
		var fs = require('fs');
		var extend = require('extend');
		var wrench = require('wrench'),
			util = require('util');

		sitemap = grunt.file.readJSON('../sitemap.json');
		
		function build_site_obj(){
			var nav = {};
			for (var page_key in sitemap.pages) {
				var page = sitemap.pages[page_key];
				page.nav_key = page_key;
				sitemap.pages[page_key] = extend(sitemap.page_defaults,page);
				var tmpobj={};
				tmpobj[page_key]=page_obj.root.trim('/')+'/'+page_obj.nav_key+"html";
				nav = extend(nav,tmpobj);
			}
			sitemap.nav = nav;
		}
		
		
		function build_page(page_obj){
			var sourceFile = 'template/'+page_obj.template+'.tmpl';
			var tmpFile = 'build/deletable.tmp';
			var targetFile = page_obj.root.trim('/')+'/'+page_obj.nav_key+"html";
			var content = fs.readFileSync(sourceFile,'utf8')
			
			sitemap.current_build=page_obj.nav_key;
			grunt.log.writeln("building "+targetFile);
			var tmpl = new nunjucks.Template(content);
			grunt.log.writeln(targetFile + "compiled");
			var res = tmpl.render(sitemap);
			grunt.log.writeln(targetFile + "renderd");
		}
		
		build_site_obj();
		for (var page_key in sitemap.pages) {
			build_page(sitemap.pages[page_key]);
		}
		
		
		/*
		var page_vars = {
			"ip": ip,
			"branch": "master",
			"owner": "washingtonstateuniversity",
			"box": "hansode/centos-6.5-x86_64",
			"box_url": false,
			"hostname": "general_server",
			"memory": "1024",
			"vram": "8",
			"cores": "1",
			"host_64bit": "false",
			"verbose_output": "true",
			"gui":"false"
		};
		serverobj = grunt.file.readJSON('server_project.conf');
		var servers = serverobj.servers;
		//set up the vagrant object so that we can just define the server if we want to
		//the vagrant needs some defaults, and so it's vagrant default then remote then 
		//vagrant opptions
		for (var key in servers) {
			grunt.log.writeln("found server "+key);
			var server = servers[key];
			server.vagrant = extend(default_vagrant,server.remote,server.vagrant||{});
			grunt.log.writeln("extenting server "+key);
			servers[key]=server;
		}
		serverobj.servers = servers;


		var sourceFile = 'tasks/jigs/vagrant/Vagrantfile';
		var tmpFile = 'tasks/jigs/vagrant/Vagrantfile.tmp';
		var targetFile = 'Vagrantfile';
		var content = fs.readFileSync(sourceFile,'utf8')

		grunt.log.writeln("read file");
		grunt.log.writeln("renderString of file");
		var tmpl = new nunjucks.Template(content);
		grunt.log.writeln("compile");
		var res = tmpl.render(serverobj);
		grunt.log.writeln("renderd");
*/

		grunt.task.current.async();
	});
};