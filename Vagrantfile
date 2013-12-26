# WSUWP Environment Vagrant Configuration
#
# This is the development Vagrantfile for the WSUWP Environment project. This
# Vagrant setup helps to describe an environment for local development that
# matches the WSUWP Environment production setup as closely as possible.
#
# We recommend Vagrant 1.3.5 and Virtualbox 4.3.
#
# -*- mode: ruby -*-
# vi: set ft=ruby :

#######################
# CONFIGS
#####################
#~salt-values
ip="10.10.30.30"
hostname="wsumage"
memory=512
cores=2
host_64bit=true
#~end-salt-values



#######################
# Setup
######################
#base
vagrant_dir = File.expand_path(File.dirname(__FILE__))

# Look for the machine ID file. This should indicate if the VM state is suspended, halted, or up.
machines_file = vagrant_dir + '/.vagrant/machines/default/virtualbox/id'
machine_exists = File.file?(machines_file)

#the sub projects
projects = []
Dir.glob(vagrant_dir + '/www/*/').each do |f|
    parts=f.split("/")
    puts parts.last
    if parts.last != 'html'
        projects << parts.last
    end
end


Vagrant.configure("2") do |config|
    # Virtualbox specific setting to allocate 512MB of memory to the virtual machine.
    config.vm.provider :virtualbox do |v|
        v.gui = false
        v.name = hostname
        v.memory = memory
        if cores>1
            v.customize ["modifyvm", :id, "--cpus", cores]
            if host_64bit
                v.customize ["modifyvm", :id, "--ioapic", "on"]
            end
        end
    end
    
    # CentOS 6.4, 64 bit release
    #
    # Provides a fairly bare-bones CentOS box created by Puppet Labs.
    config.vm.box     = "centos-64-x64-puppetlabs"
    config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210-nocm.box"
    
    
    if !(hostname.nil? || !hostname.empty?)
        config.vm.hostname = hostname
    end
    config.vm.network :private_network, ip: ip

    # Mount the local project's www/ directory as /var/www inside the virtual machine. This will
    # be mounted as the 'vagrant' user at first, then unmounted and mounted again as 'www-data'
    # during provisioning.
    if machine_exists
        config.vm.synced_folder "www", "/var/www", owner: 'www-data', group: 'www-data', :mount_options => [ "dmode=775", "fmode=774" ]
    else
        config.vm.synced_folder "www", "/var/www", :mount_options => [ "dmode=775", "fmode=774" ]
    end

    # Local Machine Hosts
    if defined? VagrantPlugins::HostsUpdater
        # Capture the paths to all `hosts` files under the repository's provision directory.
        paths = []
        hosts = []
        projects.each do |project|
            Dir.glob(vagrant_dir + "/www/#{project}/provision/salt/hosts").each do |path|
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
        config.hostsupdater.aliases = hosts
    end

    # Salt Provisioning
    #
    # Map the provisioning directory to the guest machine and initiate the provisioning process
    # with salt. On the first build of a virtual machine, if Salt has not yet been installed, it
    # will be bootstrapped automatically. We have provided a modified local bootstrap script to
    # avoid network connectivity issues and to specify that a newer version of Salt be installed.
    config.vm.synced_folder "provision/salt", "/srv/salt"
    
    config.vm.provision "shell",
    inline: "cp /srv/salt/config/yum.conf /etc/yum.conf"
    
    #the base
    config.vm.provision :salt do |salt|
        salt.bootstrap_script = 'provision/bootstrap_salt.sh'
        salt.install_type = 'testing'
        salt.verbose = true
        salt.minion_config = 'provision/salt/minions/vagrant.conf'
        salt.run_highstate = true
    end

    projects.each do |project|
        config.vm.synced_folder "www/#{project}/provision/salt", "/srv/#{project}/salt"
        config.vm.provision :salt do |salt|
            salt.bootstrap_script = 'provision/bootstrap_salt.sh'
            salt.install_type = 'testing'
            salt.verbose = true
            salt.minion_config = "www/#{project}/provision/salt/minions/vagrant.conf"
            salt.run_highstate = true
        end
    end
end
