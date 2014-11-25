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
		var env = nunjucks.configure('templates');
		env.addFilter('indexof', function(str, cmpstr) {
			return str.indexOf(cmpstr);
		});
		var marked = require('marked');
			// Async highlighting with pygmentize-bundled
			marked.setOptions({
			  highlight: function (code, lang, callback) {
				require('pygmentize-bundled')({ lang: lang, format: 'html' }, code, function (err, result) {
				  callback(err, result.toString());
				});
			  }
			});
			markdown.register(env,{
				renderer: new marked.Renderer(),
				gfm: true,
				tables: true,
				breaks: false,
				pendantic: false,
				sanitize: false,
				smartLists: true,
				smartypants: false
			});

		
		
		var fs = require('fs');
		var extend = require('extend');
		var wrench = require('wrench'),
			util = require('util');

		sitemap = grunt.file.readJSON('../sitemap.json');
		var defaults = sitemap.page_defaults;
		
		
		/*
		 * This will apply defaults and build the nav
		 */
		function build_site_obj(){
			var nav = {};
			for (var page_key in sitemap.pages) {
				grunt.log.writeln("working "+page_key);
				
				//apply defaults were needed
				sitemap.pages[page_key].nav_key = page_key;
				//note extend will not work here, for some reason it'll alter the ref of defaults
				//we'll have to do it by hand for the moment
				for (var objKey in defaults){
					if(typeof sitemap.pages[page_key][objKey] === "undefined"){
						sitemap.pages[page_key][objKey] = defaults[objKey];
					}
				}
				
				//build nav
				var tmpobj={};
				var root = sitemap.pages[page_key].nav_root.replace(new RegExp("[\/]+$", "g"), "");
				
				var linkTitle = sitemap.pages[page_key].title;
				if(typeof sitemap.pages[page_key].nav_title !== "undefined" ){
					linkTitle = sitemap.pages[page_key].nav_title;
				}

				if(typeof sitemap.pages[page_key].nav_link !== "undefined" ){
					tmpobj[linkTitle]=sitemap.pages[page_key].nav_link;
				}else{
					tmpobj[linkTitle]=root+'/'+sitemap.pages[page_key].nav_key+".html";
				}
				if(typeof sitemap.pages[page_key].child_nav !== "undefined"){
					var r = tmpobj[linkTitle];
					var navarray = {};
					
					var mainlink= sitemap.pages[page_key].title;
					if(typeof sitemap.pages[page_key].nav_title !== "undefined" ){
						mainlink = sitemap.pages[page_key].nav_title;
					}
					navarray[mainlink] = r;
					for (var link in sitemap.pages[page_key].child_nav){
						var url = link;
						var title = sitemap.pages[page_key].child_nav[link];
						if(link.indexOf('#')==0){
							url=r+link;
						}
						navarray[title] = url;
					}
					tmpobj[linkTitle]=navarray;
				}
				nav = extend(nav,tmpobj);
				grunt.log.writeln("worked "+page_key);
			}
			sitemap.nav = nav;
		}

		build_site_obj();

		
		/*
		 * Construct the static pages
		 */
		function build_page(){
			console.log(sitemap);
			for (var key in sitemap.pages) {

				var site_obj = sitemap;
				var page_obj = site_obj.pages[key];
				var sourceFile = 'templates/'+page_obj.template+'.tmpl';
				//var tmpFile = 'build/deletable.tmp';
				var root = page_obj.root.replace(new RegExp("[\/]+$", "g"), "");
				
				var page = page_obj.nav_key+".html";
				var targetFile = root+'/'+page;
				var content = fs.readFileSync(sourceFile,'utf8')
				
				site_obj.current_page=page;
				site_obj.current_build=page_obj.nav_key;
				grunt.log.writeln("building "+targetFile);
				var tmpl = new nunjucks.Template(content,env);
				grunt.log.writeln(targetFile + " compiled");
				var res = tmpl.render(site_obj);
				grunt.log.writeln(targetFile + " renderd");
				fs.writeFile(targetFile, res, function(err){
					grunt.log.writeln("wrote to file "+targetFile);
				});

			}
		}
		build_page();
		
		
		
		
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