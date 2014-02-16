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

#for dev
#bootstrap="washingtonstateuniversity/WSU-Web-Serverbase/master"
bootstrap="jeremyBass/WSU-Web-Serverbase/bootstrap"

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
            load 'includes/automated_salt_setup.rb'
    
    ################################################################ 
    # Start Vagrant
    ################################################################   
    Vagrant.configure("2") do |config|

        load 'includes/vagrant_env.rb'

        # CentOS 6.4, 64 bit release
        ################################################################  
            config.vm.box     = "centos-64-x64-puppetlabs"
            config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210-nocm.box"



        # Virtualbox specific settings for the virtual machine.
        ################################################################ 
            config.vm.provider :virtualbox do |v|
                v.gui = false
                v.name = @CONFIG[:hostname]
                v.memory = @CONFIG[:memory].to_i
                cores= @CONFIG[:cores].to_i
                if cores>1
                    v.customize ["modifyvm", :id, "--vram", @CONFIG[:vram].to_i]
                    v.customize ["modifyvm", :id, "--cpus", cores ]
                    if @CONFIG[:host_64bit] == 'true'
                        v.customize ["modifyvm", :id, "--ioapic", "on"]
                    end
                end
            end
        
        # Set networking options
        ################################################################           
            if !(@CONFIG[:hostname].nil? || !@CONFIG[:hostname].empty?)
                config.vm.hostname = @CONFIG[:hostname]
            end
            config.vm.network :private_network, ip: @CONFIG[:ip]

        # register hosts for all hosts for apps and the server
        ################################################################
        # Local Machine Hosts
        # Capture the paths to all `hosts` files under the repository's provision directory.
        
            hosts = []
            @config_obj[:apps].each do |app,obj|
                hosts.concat obj[:hosts]
            end
            
            if defined? VagrantPlugins::HostsUpdater
                config.hostsupdater.aliases = hosts
            end
            
            config.vm.provision :hosts do |provisioner|
              provisioner.add_host '127.0.0.1', hosts
            end

        # Set file mounts
        ################################################################           
        # Mount the local project's app/ directory as /var/app inside the virtual machine. This will
        # be mounted as the 'vagrant' user at first, then unmounted and mounted again as 'www-data'
        # during provisioning.
        
            config.vm.synced_folder "app", "/var/app", :mount_options => [ "uid=510,gid=510", "dmode=775", "fmode=774" ]

        # Provisioning: Salt 
        ################################################################              
            $provision_script=""
            $provision_script<<"curl -L https://raw.github.com/#{bootstrap}/bootstrap.sh | sudo sh -s -- -m #{@CONFIG[:minion]} "
        
        # Set up the web apps
        ################################################################  
        
            @config_obj[:apps].each_pair do |appname, obj|
                $provision_script<<" -a #{appname}:#{obj[:repoid]} "
            end
            
            $provision_script<<" -i -b bootstrap -o jeremyBass \n"
            
            if !@destroying
                puts "running : #{$provision_script}"
                config.vm.provision "shell", inline: $provision_script
            else
                puts "About to destroy the local server"
            end
    end
    