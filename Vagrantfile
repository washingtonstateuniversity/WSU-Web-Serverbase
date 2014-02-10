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

require 'json'


#######################
# Setup
######################
# There shouldn't be anything to edit below this point config wise
####################################################################
    
    ################################################################ 
    # Setup value defaults
    ################################################################ 
    
        #base dir
        ################################################################ 
        vagrant_dir = File.expand_path(File.dirname(__FILE__))
        
        # the sub projects :: writes out the salt "config data" and 
        # sets up for vagrant.  The production is done by hand on purpose
        ###############################################################
        destroying=false
        ARGV.each do |arg|        
            if arg.include?'destroy'
                destroying=true
            end
        end
        configFile="config.json"
        if File.exist?("config.json")
            # See e.g. https://gist.github.com/karmi/2050769#file-node-example-json
            begin
                config_obj = JSON.parse(File.read(configFile), symbolize_names: true)
                rescue Exception => e
                STDERR.puts "[!] Error when reading the configuration file:",
                e.inspect
            end
        else
            config_obj = {
              :vagrant_options => {
                    :ip => "10.10.30.120",
                    :hostname => "WSUBASE",
                    :memory => "512",
                    :cores => "2",
                    :host_64bit => true,
                    :install_type => 'testing',
                    :minion => 'vagrant',
                    :verbose_output => true 
                }
            }
        end
        
        #######################
        # CONFIG Values
        #####################
        CONFIG=config_obj[:vagrant_options]
        
        if !destroying        
            config_obj[:apps].each_pair do |name, obj|
                appname=name.to_s
                repolocation=obj[:repo].to_s
                puts "cloning repo that was missing"
                puts `git clone https://github.com/#{repolocation}.git app/#{appname}`
            end
        end
        filename = vagrant_dir+"/provision/salt/minions/#{minion}.conf"
        text = File.read(filename)
        
        PILLARFILE=   "#PILLAR_ROOT-\n"
        PILLARFILE << "pillar_roots:\n"
        PILLARFILE << "  base:\n"
        PILLARFILE << "    - /srv/salt/base/pillar\n"

        ROOTFILE=   "#FILE_ROOT-\n"
        ROOTFILE << "file_roots:\n"
        ROOTFILE << "  base:\n"
        ROOTFILE << "    - /srv/salt/base\n"
        
        SALT_ENV=   "#ENV_START-\n"
        SALT_ENV << "  env:\n"
        SALT_ENV << "    - base\n"
        SALT_ENV << "    - vagrant\n"
    
        apps = []
        paths = []
        Dir.glob(vagrant_dir + "/app/*").each do |path|
          paths << path
        end
        paths.each do |path|
            if path.include? "app/html"
                next
            end
            
            appfolder = path.split( "/" ).last
            app=appfolder.strip! || appfolder
            apps <<  app
            
            SALT_ENV << "    - #{app}\n"

            PILLARFILE << "  #{app}:\n"
            PILLARFILE << "    - /srv/salt/#{app}/pillar\n"
            
            ROOTFILE << "  #{app}:\n"
            ROOTFILE << "    - /srv/salt/#{app}\n"
        end
    
        SALT_ENV << "#ENV_END-"
        PILLARFILE << "#END_OF_PILLAR_ROOT-"
        ROOTFILE << "#END_OF_FILE_ROOT-"
 
        edited = text.gsub(/\#FILE_ROOT-.*\#END_OF_FILE_ROOT-/im, ROOTFILE)
        edited = edited.gsub(/\#PILLAR_ROOT-.*\#END_OF_PILLAR_ROOT-/im, PILLARFILE)
        edited = edited.gsub(/\#ENV_START-.*\#ENV_END-/im, SALT_ENV)
        File.open(filename, "w") { |file| file << edited }
    
    ################################################################ 
    # Start Vagrant
    ################################################################   
    Vagrant.configure("2") do |config|



        # check all versions of vagrant and plugins first
        ################################################################ 

        if Gem::Version.new(Vagrant::VERSION) > Gem::Version.new('1.4.0')
            $ok_msg = "Vagrant is #{Vagrant::VERSION}"
            puts $ok_msg
        else
        $err_msg = <<ERR
        
The Version of Vagrant is to old to be affective.  Please use 1.4.0 and above.

Visit http://www.vagrantup.com/downloads.html and update to continue

ERR
            puts $err_msg
            abort()
        end


        if Vagrant.has_plugin?("vagrant-hosts")
            $ok_msg = "The vagrant-hosts plugin is loaded"
            puts $ok_msg
        else
        $err_msg = <<ERR
    
WARNING

The vagrant-hosts plugin is required to ensure proper functionality. Use the
following command to install this plugin before continuing:

$ vagrant plugin install vagrant-hosts      
        
ERR
            puts $err_msg
            abort()
        end

        if defined? VagrantPlugins::HostsUpdater
            $ok_msg = "The vagrant-hostsupdater plugin is loaded"
            puts $ok_msg
        else
        $err_msg = <<ERR
    
WARNING

The vagrant-hostsupdater plugin is required to ensure proper functionality. Use the
following command to install this plugin before continuing:

$ vagrant plugin install vagrant-hostsupdater      
        
ERR
            puts $err_msg
            abort()
        end



        # Virtualbox specific settings for the virtual machine.
        ################################################################ 
        config.vm.provider :virtualbox do |v|
            v.gui = false
            v.name = CONFIG[:hostname]
            v.memory = CONFIG[:memory]
            
            if cores>1
                v.customize ["modifyvm", :id, "--cpus", CONFIG[:cores] ]
                if host_64bit
                    v.customize ["modifyvm", :id, "--ioapic", "on"]
                end
            end
        end
        

        # CentOS 6.4, 64 bit release
        ################################################################  
        config.vm.box     = "centos-64-x64-puppetlabs"
        config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210-nocm.box"
        
        # Set networking options
        ################################################################           
        if !(hostname.nil? || !hostname.empty?)
            config.vm.hostname = CONFIG[:hostname]
        end
        config.vm.network :private_network, ip: CONFIG[:ip]


        # register hosts for all hosts for apps and the server
        ################################################################
        # Local Machine Hosts
        # Capture the paths to all `hosts` files under the repository's provision directory.
        paths = []
        hosts = []
        apps.each do |app|
            Dir.glob(vagrant_dir + "/app/#{app}/provision/salt/config/hosts").each do |path|
              paths << path
            end
            # Parse through the `hosts` files in each of the found paths and put the hosts
            # that are found into a single array. Lines commented out with # will be skipped.
            
            paths.each do |path|
              new_hosts = []
              file_hosts = IO.read(path).split( "\n" )
              file_hosts.each do |line|
                if line[0..0] != "#"
                  new_hosts << line
                end
              end
              hosts.concat new_hosts
            end
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
        # Map the provisioning directory to the guest machine and initiate the provisioning process
        # with salt. On the first build of a virtual machine, if Salt has not yet been installed, it
        # will be bootstrapped automatically. We have provided a modified local bootstrap script to
        # avoid network connectivity issues and to specify that a newer version of Salt be installed.
        
        $provision_script=""
        #$provision_script<<"curl -L https://raw.github.com/washingtonstateuniversity/WSU-Web-Serverbase/master/bootstrap.sh | sudo sh -s -- -m #{CONFIG[:minion]} \n"

        $provision_script<<"curl -L https://raw.github.com/jeremyBass/WSU-Web-Serverbase/bootstrap/bootstrap.sh | sudo sh -s --  -i -b bootstrap -o jeremyBass \n"
        
        # Set up the web apps
        #########################
        apps.each do |app| 
            config.vm.synced_folder "app/#{app}/provision/salt", "/srv/salt/#{app}"
            $provision_script<<"salt-call --local --log-level=info --config-dir=/etc/salt state.highstate env=#{app}\n"
        end

        config.vm.provision "shell", inline: $provision_script
    end