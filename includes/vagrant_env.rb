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