# WSU Server Base Vagrant Configuration
#
# Matches the WSU Server environment production setup as closely as possible.
# This will auto edit some of the local provisioning file but not the production.
# All production states/grains/pillars are to be managed by hand.
#
# We recommend Vagrant 1.3.5 and Virtualbox 4.3.
#
# -*- mode: ruby -*-
# vi: set ft=ruby :

#######################
# Setup
######################
# There shouldn't be anything to edit below this point config wise
####################################################################


require 'json'


################################################################ 
# Setup value defaults
################################################################ 

	#base dir
	################################################################ 
		@vagrant_dir = File.expand_path(File.dirname(__FILE__))

	# the sub projects :: writes out the salt "config data" and 
	# sets up for vagrant.  The production is done by hand on purpose
	###############################################################
		@destroying=false
		ARGV.each do |arg|        
			if arg.include?'destroy'
				@destroying=true
			end
		end
		load 'includes/vagrant_loadconfig.rb'


################################################################ 
# Start Vagrant
################################################################   
Vagrant.configure("2") do |config|
	load 'includes/vagrant_env.rb'

	# CentOS 6.4, 64 bit release
	################################################################  
		config.vm.box     = "centos-64-x64-puppetlabs"
		config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-65-x64-virtualbox-nocm.box"

	#for dev
	owner="washingtonstateuniversity"
	branch="bootstrap"
	bootstrap_path="#{owner}/WSU-Web-Serverbase/#{branch}"
	if @vm_pack
		@vm_pack.each_pair do |server, server_obj|
			@server=nil
			@server_obj=nil
			config.vm.define server_obj[:hostname] do |vmConfig|
				@server=server
				@server_obj=server_obj
				owner=@server_obj[:owner]
				branch=@server_obj[:branch]
				bootstrap_path="#{owner}/WSU-Web-Serverbase/#{branch}"
				load 'includes/vagrant_apps.rb'
				load 'includes/automated_salt_setup.rb'

				# Virtualbox specific settings for the virtual machine.
				################################################################ 
					vmConfig.vm.provider :virtualbox do |v|
						v.gui = false
						v.name = @server_obj[:hostname]
						v.memory = @server_obj[:memory].to_i
						cores= @server_obj[:cores].to_i
						if cores>1
							v.customize ["modifyvm", :id, "--vram", @server_obj[:vram].to_i]
							v.customize ["modifyvm", :id, "--cpus", cores ]
							if @server_obj[:host_64bit] == 'true'
								#v.customize ["modifyvm", :id, "--ioapic", "on"]
							end
						end
					end

				# Set networking options
				################################################################           
					if !(@server_obj[:hostname].nil? || !@server_obj[:hostname].empty?)
						vmConfig.vm.hostname = @server_obj[:hostname]
					end
					vmConfig.vm.network :private_network, ip: @server_obj[:ip]

				# register hosts for all hosts for apps and the server
				################################################################
				# Local Machine Hosts
				# Capture the paths to all `hosts` files under the repository's provision directory.
				
					hosts = []
					if @apps
						@apps.each do |app,obj|
							hosts.concat obj[:hosts]
						end
					end
					
					if defined? VagrantPlugins::HostsUpdater
						vmConfig.hostsupdater.aliases = hosts
					end
					
					vmConfig.vm.provision :hosts do |provisioner|
					  provisioner.add_host '127.0.0.1', hosts
					end

				# Provisioning: Salt 
				################################################################              
					$provision_script=""
					$provision_script<<"curl -L https://raw.github.com/#{bootstrap_path}/server-bootstrap.sh | sudo sh -s -- "
					vmConfig.vm.synced_folder "provision/salt/minions", "/srv/salt/base/minions"
					$provision_script<<" -m #{@server_obj[:minion]}_#{@server_obj[:hostname]} "
				
				# Set up the web apps
				################################################################  
				
					if @apps
						# Set file mounts
						################################################################           
						# Mount the local project's app/ directory as /var/app inside the virtual machine. This will
						# be mounted as the 'vagrant' user at first, then unmounted and mounted again as 'www-data'
						# during provisioning.
						vmConfig.vm.synced_folder "app", "/var/app", :mount_options => [ "uid=510,gid=510", "dmode=775", "fmode=774" ]
						@apps.each_pair do |appname, obj|
							$provision_script<<" -a #{appname}:#{obj[:repoid]} "
						end
					end
					
					$provision_script<<" -b #{branch} -o #{owner} \n"
					
					if !@destroying
						$running="echo \"about to run running: #{$provision_script} \" \n"
						vmConfig.vm.provision "shell", inline: "#{$running}#{$provision_script}"
					else
						puts "About to destroy the local server"
					end
			end
		end
	end
end
